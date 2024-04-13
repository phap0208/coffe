// import 'dart:math';
// import 'dart:convert';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
// import 'package:musicplayer/model/PlaylistModel.dart';
// import 'package:video_player/video_player.dart';
// import 'package:dio/dio.dart';
//
//
// class VideoPlayerPageUI extends StatefulWidget {
//   const VideoPlayerPageUI({Key? key}) : super(key: key);
//
//   @override
//   State<VideoPlayerPageUI> createState() => _VideoPlayerPageUIState();
// // moi them phuong thuc controller
// }
//
// class _VideoPlayerPageUIState extends State<VideoPlayerPageUI> {
//   late VideoPlayerController? _controller;
//   int _currentIndex = 0;
//   final reference = FirebaseDatabase.instance.ref().child('yokaratv');
//   final connectionRef = FirebaseDatabase.instance.ref().child('connections');
//   List<PlaylistModel> songs = [];
//   bool loading = false;
//   String currentSongTitle = '';
//   bool _isFullScreen = true;
//   bool _showControls = true;
//   final Random _random = Random();
//   String roomId = ''; // Biến để lưu ID phòng
//
//
//
//   // Phương thức khi người dùng kết nối
//   void onConnected(String clientId) {
//     connectionRef.push().set({
//       'clientId': clientId,
//       'connectedAt': ServerValue.timestamp,
//     });
//   }
//
//   void updateCurrentSongTitle() {
//     setState(() {
//       currentSongTitle = songs[_currentIndex].songName ?? '';
//     });
//   }
//
//   void _playRandomVideo() {
//     // Sinh một chỉ số ngẫu nhiên trong phạm vi từ 0 đến songs.length - 1
//     int randomIndex = _random.nextInt(songs.length);
//
//     // Gọi hàm _playVideo với chỉ số ngẫu nhiên đã sinh
//     _playVideo(index: randomIndex);
//   }
//
//   Future<void> fetchRoomData() async {
//     try {
//       // Tạo một đối tượng Dio với baseUrl
//       String path = 'https://us-central1-ikara-development.cloudfunctions.net/ktv1_createRoom-createRoom';
//       Dio dio = Dio();
//       String param64 =
//           'eyJ1c2VySWQiOiIyQ0JERTZFRS00M0JBLTQ0NEItOUZENy1EREM3ODZBRDhGMzEtMzc1NTctMDAwMDEwMEREODlDNDU0MiIsInBsYXRmb3JtIjoiSU9TIiwibGFuZ3VhZ2UiOiJlbi55b2thcmEiLCJwYWNrYWdlTmFtZSI6ImNvbS5kZXYueW9rYXJhIiwicHJvcGVydGllcyI6eyJjdXJzb3IiOm51bGx9fQ==-915376685910417';
//       Map<String, dynamic> params = {'parameters': param64};
//
//
//       // Đường dẫn tới endpoint cụ thể, thêm vào sau baseUrl
//       // String path = 'https://ikara.co/ktv1_createRoom';
//
//       // Thực hiện request sử dụng Dio
//       final Response response = await dio.post(path);
//
//       if (response.data != null) {
//         // In dữ liệu roomId
//         print('Room ID: $roomId');
//         // Xử lý dữ liệu trả về nếu cần
//         print('hahaha: ${response.data}');
//         setState(() {
//           // roomId = response.data['roomId'];
//           roomId = response.data.split(": ")[1];
//         });
//       } else {
//         // Xử lý lỗi nếu có
//         print('Failed with error code: ${response.data}');
//       }
//     } catch (e) {
//       // Xử lý exception nếu có
//       print('Error: $e');
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _initData();
//     _toggleFullScreen();
//
//     reference
//         .limitToLast(1)
//         .onChildAdded
//         .listen((event) {
//       // setState(() {
//       //   songs.add(PlaylistModel.fromJson(event.snapshot.value));
//       //   songs.sort((a, b) => a.dateTime!.compareTo(b.dateTime!));
//       // });
//     });
//     connectionRef.onChildAdded.listen((event) {
//       final connectedClient = event.snapshot.value;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('$connectedClient đã kết nối!'),
//         ),
//       );
//     });
//   }
//
//   _initData() {
//     reference.limitToLast(1).once().then((value) {
//       // print("dataaaaaa ${value.value?.value}");
//       print("dataaaaaa111111 ${value.snapshot.value}");
//       if (value.snapshot.value != null) {
//         Map data = value.snapshot.value as Map;
//         data.forEach((key, value) {
//           print("dataaaaaa ${value}");
//           print("keyyy ${key}");
//           if (key != 'rooms') {
//             songs.add(PlaylistModel.fromJson(value));
//           }
//         });
//         // for (int i = 0; i < data.length; i++) {
//         //   print("dataaaaaa ${data[i]}");
//         //   if(data[i] != null) {
//         //     songs.add(KaraokeSong.from  Json(data[i]));
//         //   }
//         // }
//         print("ddddddđ");
//       }
//       initPlay();
//       updateCurrentSongTitle();
//     });
//   }
//
//   initPlay() {
//     if (songs.isNotEmpty) {
//       print(songs);
//       print(_currentIndex); // Kiểm tra xem danh sách songs có dữ liệu không
//       _controller = VideoPlayerController.networkUrl(
//           Uri.parse(songs[_currentIndex].songUrl ?? ''))
//         ..addListener(_onListen)
//         ..initialize().then((value) => _controller?.play());
//     }
//   }
//
//   _onListen() async {
//     setState(() {
//
//     });
//     if (!_controller!.value.isPlaying &&
//         _controller?.value.duration == _controller?.value.position &&
//         _currentIndex < songs.length - 1) {
//       print("vvvvvvvvv");
//
//       setState(() async {
//         loading = true;
//         _currentIndex += 1;
//         _controller?.removeListener(_onListen);
//         _controller?.pause();
//         await _controller?.dispose();
//
//         initPlay();
//         updateCurrentSongTitle();
//       });
//     } else if (!_controller!.value.isPlaying &&
//         _controller?.value.duration == _controller?.value.position &&
//         _currentIndex == songs.length - 1) {
//       setState(() {
//         _controller?.dispose();
//         _currentIndex = 0;
//         songs.removeAt(1);
//         if (songs.isNotEmpty) {
//           initPlay();
//           updateCurrentSongTitle();
//         }
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }
//
//   void _playPreviousVideo() {
//     int previousIndex = _currentIndex - 1;
//     if (previousIndex >= 0) {
//       _playVideo(index: previousIndex);
//     }
//   }
//
//   void _playNextVideo() {
//     int nextIndex = _currentIndex + 1;
//     if (nextIndex < songs.length) {
//       _playVideo(index: nextIndex);
//     }
//   }
//
//   void _playVideo({int index = 0}) {
//     if (_controller != null) {
//       loading = true; // Start loading process
//       _controller!.removeListener(_onListen);
//       _controller!.pause();
//       _controller!.dispose().then((_) {
//         setState(() {
//           // Set state after dispose completion
//           _currentIndex = index;
//           initPlay();
//           updateCurrentSongTitle();
//           loading = false; // End loading process
//         });
//       });
//     }
//   }
//
//   String _videoDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     final hours = twoDigits(duration.inHours);
//     final minutes = twoDigits(duration.inMinutes.remainder(60));
//     final seconds = twoDigits(duration.inSeconds.remainder(60));
//
//     return "$hours:$minutes:$seconds";
//   }
//
//   void _toggleFullScreen() {
//     setState(() {
//       _isFullScreen = !_isFullScreen;
//       _toggleOrientation(_isFullScreen);
//       _showControls = !_isFullScreen;
//     });
//   }
//
//   void _toggleOrientation(bool isFullScreen) {
//     setState(() {
//       if (isFullScreen) {
//         SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
//         SystemChrome.setPreferredOrientations(
//             [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
//       } else {
//         SystemChrome.setEnabledSystemUIMode(
//             SystemUiMode.manual, overlays: SystemUiOverlay.values);
//         SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//       }
//       _isFullScreen = isFullScreen;
//     });
//   }
//   void _exitFullScreen() {
//     setState(() {
//       _isFullScreen = false;
//       _toggleOrientation(_isFullScreen);
//       _showControls = true;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(currentSongTitle.isEmpty
//             ? 'Video Player'
//             : 'Đang phát: $currentSongTitle'),
//         centerTitle: true,
//       ),
//       body: _isFullScreen
//           ? Container(
//         color: Colors.black,
//         width: MediaQuery.of(context).size.width,
//         child: AspectRatio(
//           aspectRatio: _controller!.value.aspectRatio,
//           child: Stack(
//             alignment: Alignment.bottomCenter,
//             children: [
//               VideoPlayer(_controller!),
//               VideoProgressIndicator(_controller!, allowScrubbing: true),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     IconButton(
//                       onPressed: _playPreviousVideo,
//                       icon: Icon(Icons.skip_previous),
//                     ),
//                     IconButton(
//                       onPressed: () {
//                         if (_controller!.value.isPlaying) {
//                           _controller!.pause();
//                         } else {
//                           _controller!.play();
//                         }
//                       },
//                       icon: Icon(_controller!.value.isPlaying
//                           ? Icons.pause
//                           : Icons.play_arrow),
//                     ),
//                     IconButton(
//                       onPressed: _playNextVideo,
//                       icon: Icon(Icons.skip_next),
//                     ),
//                     IconButton(
//                       onPressed: () {
//                         _toggleFullScreen(); // Call _toggleFullScreen when the button is pressed
//                       },
//                       icon: Icon(_isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       )
//           : SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             AspectRatio(
//               aspectRatio: 16 / 9,
//               child: Stack(
//                 alignment: Alignment.bottomCenter,
//                 children: [
//                   VideoPlayer(_controller!),
//                   VideoProgressIndicator(_controller!,
//                       allowScrubbing: true),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         IconButton(
//                           onPressed: _playPreviousVideo,
//                           icon: Icon(Icons.skip_previous),
//                         ),
//                         IconButton(
//                           onPressed: () {
//                             if (_controller!.value.isPlaying) {
//                               _controller!.pause();
//                             } else {
//                               _controller!.play();
//                             }
//                           },
//                           icon: Icon(_controller!.value.isPlaying
//                               ? Icons.pause
//                               : Icons.play_arrow),
//                         ),
//                         IconButton(
//                           onPressed: _playNextVideo,
//                           icon: Icon(Icons.skip_next),
//                         ),
//                         IconButton(
//                           onPressed: _toggleFullScreen,
//                           icon: Icon(Icons.fullscreen),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 10),
//             Text(
//               'Tổng số bài hát : ${songs.length}',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () {
//                 fetchRoomData();
//               },
//               child: Text('Lấy Mã'),
//             ),
//             ElevatedButton(
//               onPressed: _playRandomVideo,
//               child: Text('Phát bài hát ngẫu nhiên'),
//             ),
//             ListView.builder(
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(),
//               itemCount: songs.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   onTap: () => _playVideo(index: index),
//                   leading: SizedBox(
//                     width: 70,
//                     height: 70,
//                     child: Image.network(
//                       'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQPaCLNGbXyPHuwWA_l3mGa2bm6fG2QZALZDg&s',
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   title: Text(
//                     songs[index].songName ?? '',
//                     style: TextStyle(fontSize: 18),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:math';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:musicplayer/model/PlaylistModel.dart';
import 'package:video_player/video_player.dart';
import 'package:dio/dio.dart';


class VideoPlayerPageUI extends StatefulWidget {
  const VideoPlayerPageUI({Key? key}) : super(key: key);

  @override
  State<VideoPlayerPageUI> createState() => _VideoPlayerPageUIState();
// moi them phuong thuc controller
}

class _VideoPlayerPageUIState extends State<VideoPlayerPageUI> {
  late VideoPlayerController? _controller;
  int _currentIndex = 0;
  final reference = FirebaseDatabase.instance.ref().child('yokaratv');
  final connectionRef = FirebaseDatabase.instance.ref().child('connections');
  List<PlaylistModel> songs = [];
  bool loading = false;
  String currentSongTitle = '';
  bool _isFullScreen = true;
  bool _showControls = true;
  final Random _random = Random();
  String roomId = ''; // Biến để lưu ID phòng



  // Phương thức khi người dùng kết nối
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
    // Sinh một chỉ số ngẫu nhiên trong phạm vi từ 0 đến songs.length - 1
    int randomIndex = _random.nextInt(songs.length);

    // Gọi hàm _playVideo với chỉ số ngẫu nhiên đã sinh
    _playVideo(index: randomIndex);
  }

  Future<void> fetchRoomData() async {
    try {
      // Tạo một đối tượng Dio với baseUrl
      String path = 'https://us-central1-ikara-development.cloudfunctions.net/ktv1_createRoom-createRoom';
      Dio dio = Dio();
      String param64 =
          'eyJ1c2VySWQiOiIyQ0JERTZFRS00M0JBLTQ0NEItOUZENy1EREM3ODZBRDhGMzEtMzc1NTctMDAwMDEwMEREODlDNDU0MiIsInBsYXRmb3JtIjoiSU9TIiwibGFuZ3VhZ2UiOiJlbi55b2thcmEiLCJwYWNrYWdlTmFtZSI6ImNvbS5kZXYueW9rYXJhIiwicHJvcGVydGllcyI6eyJjdXJzb3IiOm51bGx9fQ==-915376685910417';
      Map<String, dynamic> params = {'parameters': param64};


      // Đường dẫn tới endpoint cụ thể, thêm vào sau baseUrl
      // String path = 'https://ikara.co/ktv1_createRoom';

      // Thực hiện request sử dụng Dio
      final Response response = await dio.post(path);

      if (response.data != null) {
        // In dữ liệu roomId
        print('Room ID: $roomId');
        // Xử lý dữ liệu trả về nếu cần
        print('hahaha: ${response.data}');
        setState(() {
          // roomId = response.data['roomId'];
          roomId = response.data.split(": ")[1];
        });
      } else {
        // Xử lý lỗi nếu có
        print('Failed with error code: ${response.data}');
      }
    } catch (e) {
      // Xử lý exception nếu có
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _initData();
    _toggleFullScreen();

    reference
        .limitToLast(1)
        .onChildAdded
        .listen((event) {
      // setState(() {
      //   songs.add(PlaylistModel.fromJson(event.snapshot.value));
      //   songs.sort((a, b) => a.dateTime!.compareTo(b.dateTime!));
      // });
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
    reference.limitToLast(11).once().then((value) {
      // print("dataaaaaa ${value.value?.value}");
      print("dataaaaaa111111 ${value.snapshot.value}");
      if (value.snapshot.value != null) {
        Map data = value.snapshot.value as Map;
        data.forEach((key, value) {
          print("dataaaaaa ${value}");
          print("keyyy ${key}");
          if (key != 'rooms') {
            songs.add(PlaylistModel.fromJson(value));
          }
        });
        // for (int i = 0; i < data.length; i++) {
        //   print("dataaaaaa ${data[i]}");
        //   if(data[i] != null) {
        //     songs.add(KaraokeSong.from  Json(data[i]));
        //   }
        // }
        print("ddddddđ");
      }
      initPlay();
      updateCurrentSongTitle();
    });
  }

  initPlay() {
    if (songs.isNotEmpty) {
      print(songs);
      print(_currentIndex); // Kiểm tra xem danh sách songs có dữ liệu không
      _controller = VideoPlayerController.networkUrl(
          Uri.parse(songs[_currentIndex].songUrl ?? ''))
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
        // Không cần xóa bài hát khỏi danh sách
        // songs.removeAt(1);
        if (songs.isNotEmpty) {
          initPlay();
          updateCurrentSongTitle();
        }
      });
    }
  }
  // _onListen() async {
  //   setState(() {
  //
  //   });
  //   if (!_controller!.value.isPlaying &&
  //       _controller?.value.duration == _controller?.value.position &&
  //       _currentIndex < songs.length - 1) {
  //     print("vvvvvvvvv");
  //
  //     setState(() async {
  //       loading = true;
  //       _currentIndex += 1;
  //       _controller?.removeListener(_onListen);
  //       _controller?.pause();
  //       await _controller?.dispose();
  //
  //       initPlay();
  //       updateCurrentSongTitle();
  //     });
  //   } else if (!_controller!.value.isPlaying &&
  //       _controller?.value.duration == _controller?.value.position &&
  //       _currentIndex == songs.length - 1) {
  //     setState(() {
  //       _controller?.dispose();
  //       _currentIndex = 0;
  //       songs.removeAt(1);
  //       if (songs.isNotEmpty) {
  //         initPlay();
  //         updateCurrentSongTitle();
  //       }
  //     });
  //   }
  // }

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
      loading = true; // Start loading process
      _controller!.removeListener(_onListen);
      _controller!.pause();
      _controller!.dispose().then((_) {
        setState(() {
          // Set state after dispose completion
          _currentIndex = index;
          initPlay();
          updateCurrentSongTitle();
          loading = false; // End loading process
        });
      });
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
        SystemChrome.setEnabledSystemUIMode(
            SystemUiMode.manual, overlays: SystemUiOverlay.values);
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
          aspectRatio: _controller!.value.aspectRatio,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              VideoPlayer(_controller!),
              VideoProgressIndicator(_controller!, allowScrubbing: true),
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
                      onPressed: () {
                        _toggleFullScreen(); // Call _toggleFullScreen when the button is pressed
                      },
                      icon: Icon(_isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen),
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
                  VideoPlayer(_controller!),
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