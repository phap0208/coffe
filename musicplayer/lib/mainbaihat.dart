import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:musicplayer/playlisst.dart';

import 'model/PlaylistModel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyHomePage());
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final Playlist playlist;
  List<PlaylistModel>? songs;

  Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://ikara-development.appspot.com',
    headers: {
      'authorization': 'Bearer ${""}',
      'content-Type': 'application/x-www-form-urlencoded',
    },
  ));

  @override
  void initState() {
    super.initState();
    playlist = Playlist();
    fetchAPI();
  }

  Future<void> fetchAPI() async {
    try {
      Map<String, dynamic> parameter = {
        "userId": 123456789,
        "platform": "IOS",
        "language": "vi",
        "properties": {
          "cursor":
          "ClMKEQoLdmlld0NvdW50ZXISAggEEjpqCXN-aWthcmE0bXItCxIQRGFpbHlWaWV3Q291bnRlciIXNDk4NiMxNjk1ODIzMjAwMDAwI3ZpIzIMGAAgAQ:::AAAAAQ=="
        },
      };

      String param64 =
          'eyJ1c2VySWQiOiIyQ0JERTZFRS00M0JBLTQ0NEItOUZENy1EREM3ODZBRDhGMzEtMzc1NTctMDAwMDEwMEREODlDNDU0MiIsInBsYXRmb3JtIjoiSU9TIiwibGFuZ3VhZ2UiOiJlbi55b2thcmEiLCJwYWNrYWdlTmFtZSI6ImNvbS5kZXYueW9rYXJhIiwicHJvcGVydGllcyI6eyJjdXJzb3IiOm51bGx9fQ==-915376685910417';
      Map<String, dynamic> params = {'parameters': param64};
      String path = 'https://ikara-development.appspot.com/v32.TopSongs';
      final Response response = await _dio.post(path, data: params);
      final data = json.decode(response.data);
      if (response.statusCode == 200) {
        List<dynamic> jsonList = data['songs'];
        setState(() {
          songs = jsonList.map((json) => PlaylistModel.fromJson(json)).toList();
        });
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Playlist App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Music Playlist'),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: songs?.length ?? 0,
                itemBuilder: (context, index) {
                  final song = songs![index];
                  return ListTile(
                    title: Text(song.songName ?? ''),
                    leading: Image.network(song.thumbnailUrl ?? ''),
                    trailing: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        _navigateToPlaylist(context, song);
                      },
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlaylistScreen(
                      playlist: playlist,
                    ),
                  ),
                );
              },
              child: Text('View Playlist'),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToPlaylist(BuildContext context, PlaylistModel song) {
    setState(() {
      playlist.addSong(song); // Thêm bài hát vào danh sách phát
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlaylistScreen(
          playlist: playlist,
        ),
      ),
    );
  }
}