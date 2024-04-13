import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
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
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;


  @override
  Widget build(BuildContext context) {
    // writeSongToDatabase();
    writeSongToDatabase2();
    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme
                  .of(context)
                  .textTheme
                  .headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          writeSongToDatabase2();
        },
        tooltip: 'bài hát lên Firebase',
        child: Icon(Icons.upload),
      ),

    ); // This trailing comma makes auto-formatting nicer for build methods.
  }

  void writeSongToDatabase2() {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
    databaseReference.child('yokaratv').set(
        [
          {
            "_id": 0,
            'title': 'Hoa Tím Người Xưa ',
            'artist': 'Lê Minh Trung & Lan Vy',
            'lyrics': [],
            'songUrl': 'https://data4.ikara.co/data/minio/ikara-data/youtubesongs/mp3/nNT_qCREu3k.mp3',
            'dateTime': ServerValue.timestamp,
          },
          {
            "_id": 0,
            'title': "Áo cưới cà mau",
            'artist': 'Hoài Tâm',
            'lyrics': [],
            'songUrl': "https://data4.ikara.co/data/minio/ikara-data/youtubesongs/mp3/TGSFpC58V0Q.mp3",
            "thumbnailUrl": "https://data4.ikara.co/data/minio/ikara-data/youtubesongs/thumbnail/TGSFpC58V0Q.jpg",
            'dateTime': ServerValue.timestamp,
          },
        ]
    ).then((value) {
      print("Bài hát đã được thêm vào Firebase Realtime Database!");
    }).catchError((error) {
      print("Lỗi: $error");
    });
  }
}