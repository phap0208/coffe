import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // options: FirebaseOptions(
    //   apiKey: "AIzaSyBBrdVJdIB_2xdKMRuFUSqVIUrcOX0D4aw",
    //   appId: "1:855557731516:android:31a23fce1d89d768a5ccb9",
    //   messagingSenderId: "855557731516",
    //   projectId: "thuctap-acdca",
    //   authDomain:'thuctap-acdca.firebaseapp.com',
    //   databaseURL:'https://thuctap-acdca-default-rtdb.firebaseio.com/',
    //   storageBucket:'thuctap-acdca.appspot.com',
    // ),
  );
  runApp( MyApp());
}

class Song {
  final int id;
  final String songName;
  final String songUrl;
  final List<String> lyrics;
  final int viewCounter;
  final String thumbnailUrl;
  final String videoId;
  final Owner owner;
  final int bpm;

  Song({
    required this.id,
    required this.songName,
    required this.songUrl,
    required this.lyrics,
    required this.viewCounter,
    required this.thumbnailUrl,
    required this.videoId,
    required this.owner,
    required this.bpm,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['_id'] ?? 0,
      songName: json['songName'] ?? '',
      songUrl: json['songUrl'] ?? '',
      lyrics: List<String>.from(json['lyrics'] ?? []),
      viewCounter: json['viewCounter'] ?? 0,
      thumbnailUrl: json['thumbnailUrl'] ?? '',
      videoId: json['videoId'] ?? '',
      owner: Owner.fromJson(json['owner'] ?? {}),
      bpm: json['bpm'] ?? 0,
    );
  }
}

class Owner {
  final String name;
  final String facebookId;
  final String facebookLink;
  final String profileImageLink;
  final int type;

  Owner({
    required this.name,
    required this.facebookId,
    required this.facebookLink,
    required this.profileImageLink,
    required this.type,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      name: json['name'] ?? '',
      facebookId: json['facebookId'] ?? '',
      facebookLink: json['facebookLink'] ?? '',
      profileImageLink: json['profileImageLink'] ?? '',
      type: json['type'] ?? 0,
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<Song> _songs = [];
  final databaseReference = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    fetchSongsAndUpload();
  }

  Future<void> fetchSongsAndUpload() async {
    try {
      Dio dio = Dio();
      Response response = await dio.get('https://ikara-development.appspot.com/v32.TopSongs');
      List<dynamic> data = response.data['yokaratv'];
      List<Song> songs = data.map((json) => Song.fromJson(json)).toList();
      setState(() {
        _songs.addAll(songs);
      });
      uploadSongsToFirebase(songs);
    } catch (e) {
      print('Error fetching songs: $e');
    }
  }

  void uploadSongsToFirebase(List<Song> songs) {
    for (int i = 0; i < songs.length; i++) {
      // Mã hóa các trường cần thiết thành mã base64
      String thumbnailBase64 = base64Encode(utf8.encode(songs[i].thumbnailUrl));
      String ownerNameBase64 = base64Encode(utf8.encode(songs[i].owner.name));
      String ownerFacebookLinkBase64 = base64Encode(utf8.encode(songs[i].owner.facebookLink));
      // Các trường khác cũng tương tự

      databaseReference.child('songs').push().set({
        'id': songs[i].id,
        'songName': songs[i].songName,
        'songUrl': songs[i].songUrl,
        'lyrics': songs[i].lyrics,
        'viewCounter': songs[i].viewCounter,
        'thumbnailBase64': thumbnailBase64, // Thêm thông tin mã hóa base64 vào đây
        'videoId': songs[i].videoId,
        'owner': {
          'name': ownerNameBase64, // Thêm thông tin mã hóa base64 vào đây
          'facebookLink': ownerFacebookLinkBase64, // Thêm thông tin mã hóa base64 vào đây
          // Các trường khác tương tự
        },
        'bpm': songs[i].bpm,
      }).then((value) {
        print('Song ${songs[i].songName} uploaded successfully');
      }).catchError((error) {
        print('Failed to upload song ${songs[i].songName}: $error');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Songs List'),
        ),
        body: ListView.builder(
          itemCount: _songs.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_songs[index].songName),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('View Counter: ${_songs[index].viewCounter}'),
                  Text('BPM: ${_songs[index].bpm}'),
                ],
              ),
              leading: Image.network(_songs[index].thumbnailUrl),
              onTap: () {
                // Add your onTap logic here
              },
            );
          },
        ),
      ),
    );
  }
}
