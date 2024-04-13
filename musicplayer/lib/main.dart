import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/duphong2.dart';
import 'package:musicplayer/page/video_page.dart';
import 'package:musicplayer/page/video_page1.dart';
import 'package:musicplayer/page/video_page111.dart';
import 'package:musicplayer/page/video_pageDT.dart';
import 'package:musicplayer/page/video_pageui.dart';
import 'package:musicplayer/taonut.dart';
import 'package:musicplayer/twoapp.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MusicPlayerApp());
}

class MusicPlayerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: VideoPlayerPageUI1(),
      debugShowCheckedModeBanner: false,
    );
  }
}

