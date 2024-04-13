import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ControlApp());
}
class ControlApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Control App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ControlScreen(),
    );
  }
}
class ControlScreen extends StatefulWidget {
  @override
  _ControlScreenState createState() => _ControlScreenState();
}
class _ControlScreenState extends State<ControlScreen> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  void _sendCommand(String command) {
    _database.child('commands').set({'command': command});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Control Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Control the Player:',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => _sendCommand('play'),
              child: Text('Play'),
            ),
            ElevatedButton(
              onPressed: () => _sendCommand('pause'),
              child: Text('Pause'),
            ),
            ElevatedButton(
              onPressed: () => _sendCommand('stop'),
              child: Text('Stop'),
            ),
          ],
        ),
      ),
    );
  }
}