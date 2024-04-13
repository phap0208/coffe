import 'dart:math';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:musicplayer/model/PlaylistModel.dart';
import 'package:video_player/video_player.dart';
import 'package:dio/dio.dart';

class VideoPlayerPageDT extends StatefulWidget {
  const VideoPlayerPageDT({Key? key}) : super(key: key);

  @override
  State<VideoPlayerPageDT> createState() => _VideoPlayerPageDTState();
}

class _VideoPlayerPageDTState extends State<VideoPlayerPageDT> {
  late VideoPlayerController? _controller;
  late DatabaseReference reference;
  int _currentIndex = 0;
  final connectionRef = FirebaseDatabase.instance.ref().child('connections');
  List<PlaylistModel> songs = [];
  bool loading = false;
  String currentSongTitle = '';
  bool _isFullScreen = true;
  bool _showControls = true;
  bool isSongPlaying = false;
  final Random _random = Random();
  String roomId = '';
  double _volume = 0.5;
  double _maxVolume = 1.0;

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

  void fetchRoomData() async {
    try {
      setState(() {
        songs.clear();
      });

      String path = 'https://us-central1-ikara-development.cloudfunctions.net/ktv1_createRoom-createRoom';
      Dio dio = Dio();
      String param64 = 'eyJ1c2VySWQiOiIyQ0JERTZFRS00M0JBLTQ0NEItOUZENy1EREM3ODZBRDhGMzEtMzc1NTctMDAwMDEwMEREODlDNDU0MiIsInBsYXRmb3JtIjoiSU9TIiwibGFuZ3VhZ2UiOiJlbi55b2thcmEiLCJwYWNrYWdlTmFtZSI6ImNvbS5kZXYueW9rYXJhIiwicHJvcGVydGllcyI6eyJjdXJzb3IiOm51bGx9fQ==-915376685910417';
      Map<String, dynamic> params = {'parameters': param64};

      final Response response = await dio.get(path);

      if (response.data != null) {
        print('Room ID: $roomId');
        print('hahaha: ${response.data}');
        setState(() {
          roomId = response.data.split(": ")[1];
        });
        initPlay();
        updateCurrentSongTitle();
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
    String path = 'yokaratv/rooms/402525/songQueue';
    reference = FirebaseDatabase.instance.ref().child(path);
    _initData();
    _toggleFullScreen();

    reference.limitToLast(1).onChildAdded.listen((event) {
      setState(() {});
    });
    connectionRef.onChildAdded.listen((event) {
      final connectedClient = event.snapshot.value;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$connectedClient đã kết nối!'),
        ),
      );
    });
    fetchRoomData();
  }

  _initData() {
    reference.once().then((value) {
      if (value.snapshot.value != null && value.snapshot.value != '') {
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

  void initPlay() {
    if (songs.isNotEmpty) {
      _controller = VideoPlayerController.network(
        songs[0].songUrl ?? '',
      )
        ..addListener(_onListen)
        ..initialize().then((_) => _controller?.play());
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
        songs.clear();
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
    }
  }

  void _increaseVolume() {
    setState(() {
      if (_volume < _maxVolume) {
        _volume = (_volume + 0.1).clamp(0.0, 1.0);
        _controller!.setVolume(_volume);
      }
    });
  }

  void _decreaseVolume() {
    setState(() {
      if (_volume > 0.0) {
        _volume = (_volume - 0.1).clamp(0.0, 1.0);
        _controller!.setVolume(_volume);
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

  void _exitFullScreen() {
    setState(() {
      _isFullScreen = false;
      _toggleOrientation(_isFullScreen);
      _showControls = true;
    });
  }

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
            VideoProgressIndicator(_controller!, allowScrubbing: true),
            Positioned(
              top: 10,
              left: 10,
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
                      color: Colors.white,
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
            top: 10,
            left: 10,
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
                    color: Colors.white,
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
        // Text(
        //   'Tổng số bài hát : ${songs.length}',
        //   textAlign: TextAlign.center,
        //   style: TextStyle(
        //     fontSize: 18,
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
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
