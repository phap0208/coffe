import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class PlayerControlPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Player Control'),
      ),
      body: Center(
        child: StreamBuilder(
          stream: FirebaseDatabase.instance
              .reference()
              .child('player_control')
              .child('current_state')
              .onValue,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            String currentState =
            (snapshot.data!.snapshot.value ?? 'unknown') as String; // Ép kiểu dữ liệu thành String
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Current State: $currentState'),
                ElevatedButton(
                  onPressed: () {
                    // Gửi lệnh điều khiển tới Realtime Database
                    FirebaseDatabase.instance
                        .reference()
                        .child('player_control')
                        .child('current_state')
                        .set('playing');
                  },
                  child: Text('Play'),
                ),
                ElevatedButton(
                  onPressed: () {
                    FirebaseDatabase.instance
                        .reference()
                        .child('player_control')
                        .child('current_state')
                        .set('paused');
                  },
                  child: Text('Pause'),
                ),
                ElevatedButton(
                  onPressed: () {
                    FirebaseDatabase.instance
                        .reference()
                        .child('player_control')
                        .child('current_state')
                        .set('stopped');
                  },
                  child: Text('Stop'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: PlayerControlPage(),
  ),
  );
}