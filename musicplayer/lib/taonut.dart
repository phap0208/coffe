// import 'package:cloud_functions/cloud_functions.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
//
// import 'package:musicplayer/page/video_page.dart';
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Video Player App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: VideoConnect(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
//
// class VideoConnect extends StatefulWidget {
//   const VideoConnect({Key? key}) : super(key: key);
//
//   @override
//   State<VideoConnect> createState() => _VideoConnectState();
// }
//
// class _VideoConnectState extends State<VideoConnect> {
//   final reference = FirebaseDatabase.instance.ref().child('yokaratv');
//   final String fixedConnectionCode = "68686868"; // Mã kết nối cố định
//
//   String enteredConnectionCode = ''; // Mã kết nối người dùng nhập
//
//   @override
//   Widget build(BuildContext context) => Scaffold(
//     appBar: AppBar(
//       title: Text('TRÌNH PHÁT NHẠC YOKARA'),
//       centerTitle: true,
//     ),
//     body: SingleChildScrollView(
//       child: Column(
//         children: [
//           // Widget để nhập mã kết nối
//           Padding(
//             padding: EdgeInsets.all(16.0),
//             child: TextField(
//               onChanged: (value) {
//                 setState(() {
//                   enteredConnectionCode = value;
//                 });
//               },
//               decoration: InputDecoration(
//                 hintText: 'Nhập mã kết nối',
//                 labelText: 'Mã kết nối',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               if (enteredConnectionCode == fixedConnectionCode) {
//                 // Mã kết nối hợp lệ, cho phép truy cập và phát video
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => VideoPlayerPage(),
//                   ),
//                 );
//               } else {
//                 // Mã kết nối không hợp lệ, hiển thị thông báo hoặc xử lý khác
//                 showDialog(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return AlertDialog(
//                       title: Text('Thông báo'),
//                       content: Text('Mã kết nối không hợp lệ!'),
//                       actions: <Widget>[
//                         TextButton(
//                           onPressed: () {
//                             Navigator.of(context).pop();
//                           },
//                           child: Text('Đóng'),
//                         ),
//                       ],
//                     );
//                   },
//                 );
//               }
//             },
//             child: Text('Xác nhận'),
//           ),
//         ],
//       ),
//     ),
//   );
// }
//

import 'dart:math';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:dio/dio.dart';

import 'model/PlaylistModel.dart';

class VideoPlayerPageUX extends StatefulWidget {
  const VideoPlayerPageUX({Key? key}) : super(key: key);

  @override
  State<VideoPlayerPageUX> createState() => _VideoPlayerPageUXState();
}

class _VideoPlayerPageUXState extends State<VideoPlayerPageUX> {
  VideoPlayerController? _controller;
  int _currentIndex = 0;
  final reference = FirebaseDatabase.instance.ref().child('yokaratv/rooms/{roomId}/songQueue');
  final connectionRef = FirebaseDatabase.instance.ref().child('connections');
  List<PlaylistModel> songs = [];
  bool loading = false;
  String currentSongTitle = '';
  bool _isFullScreen = true;
  bool _showControls = true;
  final Random _random = Random();
  String roomId = '';

  void goToNewRoom() {
    setState(() {
      songs.clear();
      _controller?.dispose();
      _controller = null;
      roomId = '';
      currentSongTitle = '';
    });
  }

  void onConnected(String clientId) {
    connectionRef.push().set({
      'clientId': clientId,
      'connectedAt': ServerValue.timestamp,
    });
  }

  void updateCurrentSongTitle() {
    setState(() {
      currentSongTitle = songs[_currentIndex].songName ?? '';
    });
  }

  void _playRandomVideo() {
    int randomIndex = _random.nextInt(songs.length);
    _playVideo(index: randomIndex);
  }

  Future<void> fetchRoomData() async {
    try {
      String path = 'https://us-central1-ikara-development.cloudfunctions.net/ktv1_createRoom-createRoom';
      Dio dio = Dio();
      String param64 =
          'eyJ1c2VySWQiOiIyQ0JERTZFRS00M0JBLTQ0NEItOUZENy1EREM3ODZBRDhGMzEtMzc1NTctMDAwMDEwMEREODlDNDU0MiIsInBsYXRmb3JtIjoiSU9TIiwibGFuZ3VhZ2UiOiJlbi55b2thcmEiLCJwYWNrYWdlTmFtZSI6ImNvbS5kZXYueW9rYXJhIiwicHJvcGVydGllcyI6eyJjdXJzb3IiOm51bGx9fQ==-915376685910417';
      Map<String, dynamic> params = {'parameters': param64};
      final Response response = await dio.post(path, data: params);

      if (response.data != null) {
        setState(() {
          roomId = response.data.split(": ")[1];
        });
      } else {
        print('Failed with error code: ${response.data}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _toggleFullScreen();

    reference.limitToLast(1).onChildAdded.listen((event) {
      setState(() {
        songs.add(PlaylistModel.fromJson(event.snapshot.value));
        songs.sort((a, b) => a.dateTime!.compareTo(b.dateTime!));
      });
    });

    connectionRef.onChildAdded.listen((event) {
      final connectedClient = event.snapshot.value;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$connectedClient đã kết nối!'),
        ),
      );
    });
  }

  _initData() {
    reference.once().then((value) {
      if (value.snapshot.value != null) {
        Map data = value.snapshot.value as Map;
        data.forEach((key, value) {
          if (key != 'rooms') {
            songs.add(PlaylistModel.fromJson(value));
          }
        });
      }
      initPlay();
      updateCurrentSongTitle();
    });
  }

  initPlay() {
    if (songs.isNotEmpty) {
      _controller = VideoPlayerController.network(
          songs[_currentIndex].songUrl ?? '')
        ..addListener(_onListen)
        ..initialize().then((value) => _controller?.play());
    }
  }

  _onListen() async {
    setState(() {});
    if (!_controller!.value.isPlaying &&
        _controller?.value.duration == _controller?.value.position &&
        _currentIndex < songs.length - 1) {
      setState(() async {
        loading = true;
        _currentIndex += 1;
        _controller?.removeListener(_onListen);
        _controller?.pause();
        await _controller?.dispose();
        initPlay();
        updateCurrentSongTitle();
      });
    } else if (!_controller!.value.isPlaying &&
        _controller?.value.duration == _controller?.value.position &&
        _currentIndex == songs.length - 1) {
      setState(() {
        _controller?.dispose();
        _currentIndex = 0;
        if (songs.isNotEmpty) {
          initPlay();
          updateCurrentSongTitle();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _playPreviousVideo() {
    int previousIndex = _currentIndex - 1;
    if (previousIndex >= 0) {
      _playVideo(index: previousIndex);
    }
  }

  void _playNextVideo() {
    int nextIndex = _currentIndex + 1;
    if (nextIndex < songs.length) {
      _playVideo(index: nextIndex);
    }
  }

  void _playVideo({int index = 0}) {
    if (_controller != null) {
      loading = true;
      _controller!.removeListener(_onListen);
      _controller!.pause();
      _controller!.dispose().then((_) {
        setState(() {
          _currentIndex = index;
          initPlay();
          updateCurrentSongTitle();
          loading = false;
        });
      });
    } else {
      print("Controller is null!");
    }
  }

  String _videoDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
      _toggleOrientation(_isFullScreen);
      _showControls = !_isFullScreen;
    });
  }

  void _toggleOrientation(bool isFullScreen) {
    setState(() {
      if (isFullScreen) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
        SystemChrome.setPreferredOrientations(
            [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
      } else {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      }
      _isFullScreen = isFullScreen;
    });
  }

  void _exitFullScreen() {
    setState(() {
      _isFullScreen = false;
      _toggleOrientation(_isFullScreen);
      _showControls = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentSongTitle.isEmpty
            ? 'Video Player'
            : 'Đang phát: $currentSongTitle'),
        centerTitle: true,
      ),
      body: _isFullScreen
          ? Container(
        color: Colors.black,
        width: MediaQuery.of(context).size.width,
        child: AspectRatio(
          aspectRatio: _controller?.value.aspectRatio ?? 16 / 9,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              if (_controller != null)
                VideoPlayer(_controller!)
              else
                Container(), // Add a container if _controller is null
              if (_controller != null)
                VideoProgressIndicator(_controller!,
                    allowScrubbing: true),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: _playPreviousVideo,
                      icon: Icon(Icons.skip_previous),
                    ),
                    IconButton(
                      onPressed: () {
                        if (_controller!.value.isPlaying) {
                          _controller!.pause();
                        } else {
                          _controller!.play();
                        }
                      },
                      icon: Icon(_controller!.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow),
                    ),
                    IconButton(
                      onPressed: _playNextVideo,
                      icon: Icon(Icons.skip_next),
                    ),
                    IconButton(
                      onPressed: _toggleFullScreen,
                      icon: Icon(_isFullScreen
                          ? Icons.fullscreen_exit
                          : Icons.fullscreen),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  if (_controller != null)
                    VideoPlayer(_controller!)
                  else
                    Container(),
                  if (_controller != null)
                    VideoProgressIndicator(_controller!,
                        allowScrubbing: true),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: _playPreviousVideo,
                          icon: Icon(Icons.skip_previous),
                        ),
                        IconButton(
                          onPressed: () {
                            if (_controller!.value.isPlaying) {
                              _controller!.pause();
                            } else {
                              _controller!.play();
                            }
                          },
                          icon: Icon(_controller!.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow),
                        ),
                        IconButton(
                          onPressed: _playNextVideo,
                          icon: Icon(Icons.skip_next),
                        ),
                        IconButton(
                          onPressed: _toggleFullScreen,
                          icon: Icon(Icons.fullscreen),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Tổng số bài hát : ${songs.length}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Mã phòng: $roomId',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                goToNewRoom();
                fetchRoomData();
              },
              child: Text('Lấy Mã'),
            ),
            ElevatedButton(
              onPressed: _playRandomVideo,
              child: Text('Phát bài hát ngẫu nhiên'),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: songs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () => _playVideo(index: index),
                  leading: SizedBox(
                    width: 70,
                    height: 70,
                    child: Image.network(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQPaCLNGbXyPHuwWA_l3mGa2bm6fG2QZALZDg&s',
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    songs[index].songName ?? '',
                    style: TextStyle(fontSize: 18),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
