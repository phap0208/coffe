import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  List<dynamic>? jsonList;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final TextEditingController _searchController = TextEditingController();
  Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://ikara-development.appspot.com',
    headers: {
      "authorization": 'Bearer ${""}',
      'content-Type': 'application/x-www-form-urlencoded',
    },
  ));


  @override
  void initState() {
    super.initState();
    fetchAPI();
  }

  Future<void> fetchAPI() async {
    try {
      Map<String, dynamic> parameter = {
        "userId": "7B30D808-BE36-492B-A002-1F9BCB1755E6-893-0000005832A0B5F1",
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
      log("datatataatat ${response.data}");
      final data = json.decode(response.data);
      if (response.statusCode == 200) {
        setState(() {
          jsonList = data['songs'] as List<dynamic>;
        });
        await uploadDataToFirebase(jsonList!);
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> uploadDataToFirebase(List<dynamic> data) async {
    try {
      int index = 0;
      for (var song in data) {
        // Thêm thời gian cho mỗi bài hát
        song['time'] = ServerValue.timestamp;
        // Đưa dữ liệu lên Firebase Realtime Database với tên node là số thứ tự
        await _database.child('yokaratv').child(index.toString()).set(song);
        print('Song $index uploaded successfully');
        index++;
      }
    } catch (e) {
      print('Error uploading song: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music'),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          final song = jsonList![index];
          return Card(
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(80),
                child: Image.network(
                  song['thumbnailUrl'],
                  fit: BoxFit.fill,
                  width: 50,
                  height: 50,
                ),
              ),
              title: Text(song['songName']),
            ),
            key: Key(song['videoId']), // Use videoId as key
          );
        },
        itemCount: jsonList == null ? 0 : jsonList!.length,
      ),
    );
  }
}



