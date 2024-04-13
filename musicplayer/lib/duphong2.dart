import 'dart:math';
import 'dart:convert';
// import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:musicplayer/model/PlaylistModel.dart';
import 'package:video_player/video_player.dart';
import 'package:dio/dio.dart';


class VideoPlayerPage11 extends StatefulWidget {
  const VideoPlayerPage11({Key? key}) : super(key: key);

  @override
  State<VideoPlayerPage11> createState() => _VideoPlayerPage11State();
// moi them phuong thuc controller
}

class _VideoPlayerPage11State extends State<VideoPlayerPage11> {
  late VideoPlayerController? _controller;
  int _currentIndex = 0;
  final reference = FirebaseDatabase.instance.ref().child('yokaratv');
  List<PlaylistModel> songs = [];
  bool loading = false;
  String currentSongTitle = '';
  bool _isFullScreen = false;
  bool _showControls = true;
  final Random _random = Random();
  String roomID = ''; // Biến để lưu ID phòng


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

  // Future<void> fetchRoomData(String roomID) async {
  //   try {
  //     // Tạo một đối tượng Dio với baseUrl
  //     String path = '/ktv1_createRoom';
  //     Dio dio = Dio(BaseOptions(
  //     ));
  //     String param64 =
  //         'ewogICJ1c2VySWQiOiAiN0IzMEQ4MDgtQkUzNi00OTJCLUEwMDItMUY5QkNCMTc1NUU2LTg5My0wMDAwMDA1ODMyQTBCNUYxIiwKICAicGxhdGZvcm0iOiAiSU9TIiwKICAibGFuZ3VhZ2UiOiAidmkiLAogICJwcm9wZXJ0aWVzIjogewogICJjdXJzb3IiOiAiQ2xNS0VRb0xkbWxsZDBOdmRXNTBaWElTQWdnRUVqcHFDWE4tYVd0aGNtRTBiWEl0Q3hJUVJHRnBiSGxXYVdWM1EyOTFiblJsY2lJWE5EazROaU14TmprMU9ESXpNakF3TURBd0kzWnBJeklNR0FBZ0FROjo6QUFBQUFRPT0iCiAgfQ==';
  //     Map<String, dynamic> params = {'parameters': param64};
  //
  //
  //     // Đường dẫn tới endpoint cụ thể, thêm vào sau baseUrl
  //     // String path = 'https://ikara.co/ktv1_createRoom';
  //
  //     // Thực hiện request sử dụng Dio
  //     final Response response = await dio.post(
  //       'https://ikara.co' + path,);
  //
  //     if (response.data != null) {
  //       // In dữ liệu roomId
  //       print('Room ID: $roomID');
  //       // Xử lý dữ liệu trả về nếu cần
  //       print('hahaha: ${response.data}');
  //     } else {
  //       // Xử lý lỗi nếu có
  //       print('Failed with error code: ${response.data}');
  //     }
  //   } catch (e) {
  //     // Xử lý exception nếu có
  //     print('Error: $e');
  //   }
  // }

  @override
  void initState() {
    super.initState();
    _initData();

    reference
        .limitToLast(1)
        .onChildAdded
        .listen((event) {
      setState(() {
        songs.add(PlaylistModel.fromJson(event.snapshot.value));
        songs.sort((a, b) => a.dateTime!.compareTo(b.dateTime!));
      });
    });
  }

  _initData() {
    reference.get().then((value) {
      List data = value.value as List;
      print("dataaaaaa ${jsonEncode(data)}");
      for (int i = 0; i < data.length; i++) {
        songs.add(PlaylistModel.fromJson(data[i]));
      }
      print("ddddddđ");
      initPlay();
      updateCurrentSongTitle();
    });
  }

  initPlay() {
    if (songs.isNotEmpty) { // Kiểm tra xem danh sách songs có dữ liệu không
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
      print("vvvvvvvvv");

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
        songs.removeAt(1);
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
    if (index < 0 || index >= songs.length) return;

    loading = true; // Bắt đầu quá trình tải

    _controller?.removeListener(_onListen);
    _controller?.pause();
    _controller?.dispose().then((_) {
      setState(() {
        // Thực hiện setState sau khi dispose hoàn thành
        _currentIndex = index;
        initPlay();
        updateCurrentSongTitle();
        loading = false; // Kết thúc quá trình tải
      });
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
    if (isFullScreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    } else {
      SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.manual, overlays: SystemUiOverlay.values);
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
  }

  @override
  Widget build(BuildContext context) =>
      Scaffold(
        appBar: AppBar(
          title: Text(currentSongTitle.isEmpty
              ? 'Video Player'
              : 'Đang phát: $currentSongTitle'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Slider(
                value: _controller!.value.volume,
                onChanged: (newValue) {
                  setState(() {
                    _controller?.setVolume(newValue);
                  });
                },
                min: 0.0,
                max: 1.0,
              ),
              Text(
                'Tổng số bài hát : ${songs.length}',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'CP10: $roomID',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: () {
              //     fetchRoomData('');
              //   },
              //   child: Text('Fetch Room Data'),
              // ),
              ElevatedButton(
                onPressed: _playRandomVideo,
                child: Text('Phát bài hát ngẫu nhiên'),
              ),
              GestureDetector(
                onTap: _toggleFullScreen,
                child: Container(
                  color: Colors.deepPurpleAccent,
                  height: _isFullScreen
                      ? MediaQuery
                      .of(context)
                      .size
                      .width
                      : 300,
                  child: _controller?.value.isInitialized ?? false
                      ? Column(
                    children: [
                      SizedBox(
                        height: _isFullScreen
                            ? MediaQuery
                            .of(context)
                            .size
                            .width
                            : 200,
                        child: AspectRatio(
                          aspectRatio:
                          _controller!.value.aspectRatio,
                          child: VideoPlayer(_controller!),
                        ),
                      ),
                      if (_showControls)
                        const SizedBox(height: 12),
                      if (_showControls)
                        Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          children: [
                            ValueListenableBuilder(
                              valueListenable: _controller!,
                              builder: (context,
                                  VideoPlayerValue value,
                                  child) {
                                return Text(
                                  _videoDuration(
                                      value.position),
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 20,
                                  ),
                                );
                              },
                            ),
                            Expanded(
                              child: SizedBox(
                                height: 20,
                                child: VideoProgressIndicator(
                                  _controller!,
                                  allowScrubbing: true,
                                  padding:
                                  const EdgeInsets.symmetric(
                                    vertical: 0,
                                    horizontal: 12,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              _videoDuration(
                                  _controller!.value.duration),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            IconButton(
                              onPressed: _playPreviousVideo,
                              icon: Icon(
                                Icons.skip_previous,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                if (_controller
                                !.value.isPlaying) {
                                  _controller?.pause();
                                } else {
                                  _controller?.play();
                                }
                              },
                              icon: Icon(
                                _controller!.value.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            IconButton(
                              onPressed: _playNextVideo,
                              icon: Icon(
                                Icons.skip_next,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                    ],
                  )
                      : const Center(
                    child: CircularProgressIndicator(
                        color: Colors.cyan),
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => _playVideo(index: index),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12),
                      child: Row(
                        children: [
                          SizedBox(
                            height: 70,
                            width: 70,
                            child: Image.network(
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQPaCLNGbXyPHuwWA_l3mGa2bm6fG2QZALZDg&s",
                              semanticLabel:
                              songs[index].songName,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(width: 30),
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                songs[index].songName ?? '',
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
}