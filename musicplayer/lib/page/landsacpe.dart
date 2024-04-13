

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class LandscapePlayerPage extends StatefulWidget {
  const LandscapePlayerPage({Key? key, required this.controller}) : super(key: key);
  final VideoPlayerController controller;


  @override
  State<LandscapePlayerPage> createState() => _LandscapePlayerPageState();
}


class _LandscapePlayerPageState extends State<LandscapePlayerPage> {
  Future _LandscapeMode() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
  
  Future _setAllOrientation() async {
    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }
  @override
  void initState() {
    super.initState();

    _LandscapeMode();
  }

  @override
  void dispose() {
    _setAllOrientation();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container();
}