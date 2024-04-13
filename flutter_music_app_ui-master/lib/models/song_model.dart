import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';

class Song {
  final String songName;
  final String description;
  final String songUrl;
  final String thumbnailUrl;

  Song({
    required this.songName,
    required this.description,
    required this.songUrl,
    required this.thumbnailUrl,
  });

  static List<Song> songs = [];
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    fetchAndUploadSongs();
  }

  Future<void> fetchAndUploadSongs() async {
    List<Song> songs = await fetchSongsFromAPI();
    uploadSongsToFirebase(songs);
    setState(() {
      Song.songs = songs;
    });
  }

  Future<List<Song>> fetchSongsFromAPI() async {
    Dio dio = Dio(BaseOptions(
      baseUrl: 'https://ikara-development.appspot.com',
      headers: {
        "authorization": 'Bearer ${""}',
        'content-Type' : 'application/x-www-form-urlencoded',
        // options.contentType ='application/x-www-form-urlencoded';
      },
    ),);

    try {
      String param64 =
          'eyJ1c2VySWQiOiIyQ0JERTZFRS00M0JBLTQ0NEItOUZENy1EREM3ODZBRDhGMzEtMzc1NTctMDAwMDEwMEREODlDNDU0MiIsInBsYXRmb3JtIjoiSU9TIiwibGFuZ3VhZ2UiOiJlbi55b2thcmEiLCJwYWNrYWdlTmFtZSI6ImNvbS5kZXYueW9rYXJhIiwicHJvcGVydGllcyI6eyJjdXJzb3IiOm51bGx9fQ==-915376685910417';
      Map<String, dynamic> params = {'parameters': param64};
      Response response = await dio.post('https://ikara-development.appspot.com/v32.TopSongs',data: params);

      List<Song> songs = (response.data as List).map((item) {
        return Song(
          songName: item['title'],
          description: item['description'],
          songUrl: item['url'],
          thumbnailUrl: item['coverUrl'],
        );
      }).toList();

      return songs;
    } catch (e) {
      print('Error fetching songs: $e');
      return [];
    }
  }

  void uploadSongsToFirebase(List<Song> songs) {
    final databaseReference = FirebaseDatabase.instance.ref();

    for (int i = 0; i < songs.length; i++) {
      databaseReference.child('yokaratv').push().set({
        'title': songs[i].songName,
        'description': songs[i].description,
        'songUrl': songs[i].songUrl,
        'thumbnailUrl': songs[i].thumbnailUrl,
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
          itemCount: Song.songs.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(Song.songs[index].songName),
              subtitle: Text(Song.songs[index].description),
              leading: Image.network(Song.songs[index].thumbnailUrl),
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



// class Song {
//   final String title;
//   final String description;
//   final String url;
//   final String coverUrl;
//
//   Song({
//     required this.title,
//     required this.description,
//     required this.url,
//     required this.coverUrl,
//   });
//
//   static List<Song> songs = [
//     Song(
//       title: 'Glass',
//       description: 'Glass',
//       url: 'assets/music/glass.mp3',
//       coverUrl: 'assets/images/glass.jpg',
//     ),
//     Song(
//       title: 'Illusions',
//       description: 'Illusions',
//       url: 'assets/music/illusions.mp3',
//       coverUrl: 'assets/images/illusions.jpg',
//     ),
//     Song(
//       title: 'Pray',
//       description: 'Pray',
//       url: 'assets/music/pray.mp3',
//       coverUrl: 'assets/images/pray.jpg',
//     )
//   ];
// }