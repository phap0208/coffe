// // import 'package:firebase_core/firebase_core.dart';
// // import 'package:firebase_database/firebase_database.dart';
// // import 'package:flutter/material.dart';
// //
// // void main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   await Firebase.initializeApp();
// //   runApp(MyApp());
// // }
// //
// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Flutter Firebase Chat',
// //       theme: ThemeData(
// //         primarySwatch: Colors.blue,
// //       ),
// //       home: ChatScreen(),
// //     );
// //   }
// // }
// //
// // class ChatScreen extends StatefulWidget {
// //   @override
// //   _ChatScreenState createState() => _ChatScreenState();
// // }
// //
// // class _ChatScreenState extends State<ChatScreen> {
// //   final reference = FirebaseDatabase.instance.reference().child('messages');
// //   TextEditingController _controller = TextEditingController();
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Chat App'),
// //       ),
// //       body: Column(
// //         children: [
// //           Expanded(
// //             child: StreamBuilder(
// //               stream: reference.onValue,
// //               builder: (context, snapshot) {
// //                 if (snapshot.hasData && snapshot.data?.snapshot.value != null) {
// //                   Map<dynamic, dynamic> values = snapshot.data?.snapshot.value as Map<dynamic, dynamic>; // Cast to Map
// //                   List<Message> messages = [];
// //                   values.forEach((key, value) {
// //                     messages.add(Message.fromJson(value));
// //                   });
// //                   return ListView.builder(
// //                     itemCount: messages.length,
// //                     itemBuilder: (context, index) {
// //                       return ListTile(
// //                         title: Text(messages[index].text),
// //                       );
// //                     },
// //                   );
// //                 } else {
// //                   return Center(
// //                     child: CircularProgressIndicator(),
// //                   );
// //                 }
// //               },
// //             ),
// //           ),
// //           Padding(
// //             padding: const EdgeInsets.all(8.0),
// //             child: Row(
// //               children: [
// //                 Expanded(
// //                   child: TextField(
// //                     controller: _controller,
// //                     decoration: InputDecoration(
// //                       hintText: 'Enter your message...',
// //                     ),
// //                   ),
// //                 ),
// //                 IconButton(
// //                   icon: Icon(Icons.send),
// //                   onPressed: () {
// //                     sendMessage(_controller.text);
// //                     _controller.clear();
// //                   },
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   void sendMessage(String text) {
// //     if (text.isNotEmpty) {
// //       final newMessageRef = reference.push();
// //       newMessageRef.set({'text': text});
// //     }
// //   }
// // }
// //
// // class Message {
// //   final String text;
// //
// //   Message(this.text);
// //
// //   Message.fromJson(Map<dynamic, dynamic> json) : text = json['text'];
// //
// //   Map<dynamic, dynamic> toJson() => {'text': text};
// // }
//
// // import 'package:flutter/material.dart';
// // import 'package:firebase_core/firebase_core.dart';
// // import 'package:firebase_database/firebase_database.dart';
// //
// // void main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   await Firebase.initializeApp();
// //   runApp(VideoPlayerApp());
// // }
// //
// // class VideoPlayerApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Video Player',
// //       home: VideoPlayerScreen(),
// //     );
// //   }
// // }
// //
// // class VideoPlayerScreen extends StatefulWidget {
// //   @override
// //   _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
// // }
// //
// // class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
// //   String _videoUrl = "https://www.example.com/sample.mp4";
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Video Player'),
// //       ),
// //       body: Center(
// //         child: VideoPlayerWidget(videoUrl: _videoUrl),
// //       ),
// //     );
// //   }
// // }
// //
// // class VideoPlayerWidget extends StatelessWidget {
// //   final String videoUrl;
// //
// //   const VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return AspectRatio(
// //       aspectRatio: 16 / 9, // Assuming 16:9 aspect ratio for the video
// //       child: Container(
// //         color: Colors.black,
// //         child: VideoPlayerApp(/* Video Player widget with 'videoUrl' */),
// //       ),
// //     );
// //   }
// // }
//
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(ControlApp());
// }
//
// class ControlApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Video Control',
//       home: ControlScreen(),
//     );
//   }
// }
//
// class ControlScreen extends StatefulWidget {
//   @override
//   _ControlScreenState createState() => _ControlScreenState();
// }
//
// class _ControlScreenState extends State<ControlScreen> {
//   final DatabaseReference _database = FirebaseDatabase.instance.reference();
//   TextEditingController _urlController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Video Control'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _urlController,
//               decoration: InputDecoration(
//                 labelText: 'Enter Video URL',
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 String newUrl = _urlController.text;
//                 _database.child('videoUrl').set(newUrl);
//               },
//               child: Text('Set Video URL'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Đảm bảo Flutter đã khởi tạo widgets
  await Firebase.initializeApp(); // Khởi tạo Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Title',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
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
      debugPrint("datatataatat ${response.data}");
      final data = json.decode(response.data);
      if (response.statusCode == 200) {
        setState(() {
          jsonList = data['songs'] as List<dynamic>;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your App Title'),
      ),
      body: Center(
        child: jsonList == null
            ? const CircularProgressIndicator()
            : ListView.builder(
          itemCount: jsonList!.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(jsonList![index]['song_name']),
              subtitle: Text(jsonList![index]['artist_name']),
            );
          },
        ),
      ),
    );
  }
}
