import 'dart:math';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:musicplayer/model/PlaylistModel.dart';
import 'package:video_player/video_player.dart';
import 'package:dio/dio.dart';


class VideoPlayerPageUI1 extends StatefulWidget {
  const VideoPlayerPageUI1({Key? key}) : super(key: key);

  @override
  State<VideoPlayerPageUI1> createState() => _VideoPlayerPageUIState();
// moi them phuong thuc controller
}

class _VideoPlayerPageUIState extends State<VideoPlayerPageUI1> {
  late VideoPlayerController? _controller;
  late DatabaseReference reference;
  int _currentIndex = 0;
  // final reference = FirebaseDatabase.instance.ref().child(
  //     'yokaratv');
  final connectionRef = FirebaseDatabase.instance.ref().child('connections');
  List<PlaylistModel> songs = [];
  bool loading = false;
  String currentSongTitle = '';
  bool _isFullScreen = true;
  bool _showControls = true;
  bool isSongPlaying = false; // Thêm biến cờ
  final Random _random = Random();
  // late String roomId; // Biến để lưu ID phòng
  String roomId = '';
  double _volume = 0.5; // Giá trị âm lượng hiện tại, có thể thay đổi tùy ý
  double _maxVolume = 1.0; // Giá trị tối đa của âm lượng


  // Phương thức khi người dùng kết nối
  void onConnected(String clientId) {
    connectionRef.push().set({
      'clientId': clientId,
      'connectedAt': ServerValue.timestamp,
    });
  }

  void updateCurrentSongTitle() {
    setState(() {
      currentSongTitle = songs [_currentIndex].songName ?? '';
    });
  }

  void _playRandomVideo() {
    // Sinh một chỉ số ngẫu nhiên trong phạm vi từ 0 đến songs.length - 1
    int randomIndex = _random.nextInt(songs.length);

    // Gọi hàm _playVideo với chỉ số ngẫu nhiên đã sinh
    _playVideo(index: randomIndex);
  }


  void fetchRoomData() async {
    try {
      // Xóa danh sách bài hát hiện tại
      setState(() {
        songs.clear();
      });


      // Tạo một đối tượng Dio với baseUrl
      String path = 'https://us-central1-ikara-development.cloudfunctions.net/ktv1_createRoom-createRoom';
      Dio dio = Dio();
      // String param64 =
      //     'eyJ1c2VySWQiOiIyQ0JERTZFRS00M0JBLTQ0NEItOUZENy1EREM3ODZBRDhGMzEtMzc1NTctMDAwMDEwMEREODlDNDU0MiIsInBsYXRmb3JtIjoiSU9TIiwibGFuZ3VhZ2UiOiJlbi55b2thcmEiLCJwYWNrYWdlTmFtZSI6ImNvbS5kZXYueW9rYXJhIiwicHJvcGVydGllcyI6eyJjdXJzb3IiOm51bGx9fQ==-915376685910417';
      // Map<String, dynamic> params = {'parameters': param64};

      // Thực hiện request sử dụng Dio
      final Response response = await dio.get(path);
      String newRoomId = response.data.split(": ")[1]; // Extract roomId

      if (response.data != null) {
        // In dữ liệu roomId
        print('Room ID: $newRoomId');
        // Xử lý dữ liệu trả về nếu cần
// print('hahaha: ${response.data}');
        setState(() {
          roomId = newRoomId;// Lưu lại mã số phòng
          // roomId = response.data['roomId'];
          // roomId = response.data.split(": ")[1];
        });
        String path = 'yokaratv/rooms/$roomId/songQueue';
        reference = FirebaseDatabase.instance.ref().child(path);
        _registerListen();

      } else {
        print('Dữ liệu trả về null');
        initPlay();
        updateCurrentSongTitle();
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
    if (roomId.isNotEmpty) {
      // Nếu có, tham gia vào phòng đã lưu trữ
      _registerListen();
    } else {
      // Nếu không, tạo phòng mới và lưu lại mã số phòng
      fetchRoomData();
    }
  }


  _registerListen() {
    String path = 'yokaratv/rooms/$roomId/songQueue';
    print("pathpathpathpath ${path}");
    print("bbbbbb $roomId");
    reference = FirebaseDatabase.instance.ref().child(path);
    reference.onChildAdded.listen((event) {
      // Kiểm tra xem danh sách songs có rỗng không
      if (songs.isEmpty) {
        setState(() {
          // Cập nhật danh sách các bài hát khi có sự thay đổi
          songs.add(PlaylistModel.fromJson(event.snapshot.value));
        });
      } else {
        // Thêm dữ liệu vào danh sách songs chỉ khi có dữ liệu từ songQueue
        if (event.snapshot.value != null) {
          setState(() {
            // Cập nhật danh sách các bài hát khi có sự thay đổi
            songs.add(PlaylistModel.fromJson(event.snapshot.value));
          });
        } else {
          // Xử lý khi không có dữ liệu từ songQueue
          print('No data available from songQueue');
        }
      }
    });
    // _controller = VideoPlayerController.network(
    //   songs[0].songUrl ?? '',
    // )..addListener(_onListen)
    //   ..initialize().then((_) => _controller?.play());
    // Khởi tạo các giá trị âm lượng
    _volume = 0.5; // Giá trị âm lượng mặc định
    _maxVolume = 1.0; // Giá trị tối đa của âm lượng
    _initData();
    _toggleFullScreen();

    reference
        .limitToLast(1)
        .onChildAdded
        .listen((event) {
      setState(() {
        // songs.add(PlaylistModel.fromJson(event.snapshot.value));
        // songs.sort((a, b) => a.dateTime!.compareTo(b.dateTime!));
      });
    });
    reference.onChildAdded.listen((event) {
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
      print("dataaaaaa111111 ${value.snapshot.value}");
      if (value.snapshot.value != null && value.snapshot.value != '') {
        Map data = value.snapshot.value as Map;
        Set<String> uniqueSongs = Set<String>(); // Tạo một Set để lưu trữ các bài hát duy nhất
        data.forEach((key, value) {
          if (key != 'rooms' && value is Map) {
            value.forEach((innerKey, innerValue) {
              print("dataaaaaa ${innerValue}");
              print("keyyy ${innerKey}");
              if (innerKey != 'rooms') {
                PlaylistModel song = PlaylistModel.fromJson(value);
                String songKey = '${song.songName}-${song.songUrl}'; // Tạo một key duy nhất cho bài hát
                if (!uniqueSongs.contains(songKey)) { // Kiểm tra xem bài hát đã tồn tại trong Set chưa
                  uniqueSongs.add(songKey); // Thêm bài hát vào Set
                  songs.add(song); // Thêm bài hát vào danh sách nếu chưa tồn tại
                }
              }
            });
          }
        });
        print("ddddddđ");
      }
      if (songs.isNotEmpty) { // Kiểm tra xem danh sách songs có dữ liệu không
        initPlay();
        updateCurrentSongTitle();
      }
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
  // void initPlay() {
  //   if (songs.isNotEmpty) {
  //     _controller = VideoPlayerController.network(
  //       songs[0].songUrl ?? '',
  //     )..addListener(_onListen)
  //       ..initialize().then((_) => _controller?.play());
  //   }
  // }

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
        songs.clear(); // Xóa danh sách bài hát khi kết thúc danh sách
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

  void _increaseVolume() {
    setState(() {
      if (_volume < _maxVolume) {
        _volume = (_volume + 0.1).clamp(0.0, 1.0); // Tăng âm lượng lên 0.1
        _controller!.setVolume(_volume); // Đặt lại âm lượng mới
      }
    });
  }

  void _decreaseVolume() {
    setState(() {
      if (_volume > 0.0) {
        _volume = (_volume - 0.1).clamp(0.0, 1.0); // Giảm âm lượng đi 0.1
        _controller!.setVolume(_volume); // Đặt lại âm lượng mới
      }
    });
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
            [
              DeviceOrientation.landscapeLeft,
              DeviceOrientation.landscapeRight
            ]);
      } else {
        SystemChrome.setEnabledSystemUIMode(
            SystemUiMode.manual, overlays: SystemUiOverlay.values);
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      }
      _isFullScreen = isFullScreen;
    });
  }

  // void _exitFullScreen() {
  //   setState(() {
  //     _isFullScreen = false;
  //     _toggleOrientation(_isFullScreen);
  //     _showControls = true;
  //   });
  // }

  Widget build(BuildContext context) {
    if (_controller == null) {
      return CircularProgressIndicator(); // hoặc một widget thay thế khác
    }
    if (songs.isEmpty) {
      // Không có dữ liệu trong songQueue, bạn có thể hiển thị một video mặc định
      return Scaffold(
        appBar: AppBar(
          title: Text('Video Player'),
          centerTitle: true,
        ),
        body: Center(
          child: Text('Không có bài hát nào để phát'),
        ),
      );
    }
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
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            VideoPlayer(_controller!),
            if (songs.isNotEmpty) // Check if songs list is not empty
              Positioned.fill(
                child: Image.network(
                  songs[_currentIndex].thumbnailUrl ?? '', // Display thumbnail image
                  fit: BoxFit.cover,
                ),
              ),
            VideoProgressIndicator(_controller!, allowScrubbing: true),
            Positioned(
              top: 10, // Điều chỉnh vị trí theo chiều dọc từ đỉnh màn hình xuống
              left: 10, // Điều chỉnh vị trí theo chiều ngang từ bên trái
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  currentSongTitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Thời lượng: ${_videoDuration(_controller!.value.duration)}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white, // Đặt màu chữ thành màu đỏ
                    ),
                  ),
                  IconButton(
                    onPressed: _playPreviousVideo,
                    icon: Icon(Icons.skip_previous,color: Colors.white,),
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
                        : Icons.play_arrow,  color: Colors.white,),
                  ),
                  IconButton(
                    onPressed: _playNextVideo,
                    icon: Icon(Icons.skip_next,color: Colors.white,),
                  ),
                  IconButton(
                    onPressed: _toggleFullScreen,
                    icon: Icon(_isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,color: Colors.white,),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 55,
              right: 0,
              left: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _decreaseVolume,
                    icon: Icon(Icons.volume_down,color: Colors.white,),
                  ),
                  Slider(
                    value: _volume,
                    min: 0.0,
                    max: _maxVolume,
                    onChanged: (value) {
                      setState(() {
                        _volume = value;
                        _controller!.setVolume(_volume);
                      });
                    },
                  ),
                  IconButton(
                    onPressed: _increaseVolume,
                    icon: Icon(Icons.volume_up,color: Colors.white,),
                  ),
                ],
              ),
            ),
          ],
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
                  if (songs.isNotEmpty)
                    Positioned.fill(
                      child: Image.network(
                        songs[_currentIndex].thumbnailUrl ?? '',
                        fit: BoxFit.cover,
                      ),
                    ),
                  VideoProgressIndicator(_controller!,
                      allowScrubbing: true),
                  Positioned(
                    top: 10, // Điều chỉnh vị trí theo chiều dọc từ đỉnh màn hình xuống
                    left: 10, // Điều chỉnh vị trí theo chiều ngang từ bên trái
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        currentSongTitle,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Thời lượng: ${_videoDuration(_controller!.value.duration)}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white, // Đặt màu chữ thành màu trắng
                          ),
                        ),
                        IconButton(
                          onPressed: _playPreviousVideo,
                          icon: Icon(Icons.skip_previous,color: Colors.white,),
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
                              : Icons.play_arrow, color: Colors.white,),
                        ),
                        IconButton(
                          onPressed: _playNextVideo,
                          icon: Icon(Icons.skip_next,color: Colors.white,),
                        ),
                        IconButton(
                          onPressed: _toggleFullScreen,
                          icon: Icon(Icons.fullscreen,color: Colors.white,),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 55,
                    right: 0,
                    left: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: _decreaseVolume,
                          icon: Icon(Icons.volume_down,color: Colors.white,),
                        ),
                        Slider(
                          value: _volume,
                          min: 0.0,
                          max: _maxVolume,
                          onChanged: (value) {
                            setState(() {
                              _volume = value;
                              _controller!.setVolume(_volume);
                            });
                          },
                        ),
                        IconButton(
                          onPressed: _increaseVolume,
                          icon: Icon(Icons.volume_up,color: Colors.white,),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            SizedBox(height: 10),
            Text(
              'Mã Số: $roomId',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
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
                      songs[index].thumbnailUrl ?? '',
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
