import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:piano/piano.dart';
import 'package:piano/player/player.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Disable the status bar and the system bar
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: []);
  // Lock the app in landscape orientation
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ],
  );

  // Launch the app itself
  runApp(PianoApp());
}

class PianoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Piano',
      theme: ThemeData.light().copyWith(
        backgroundColor: Colors.grey[100],
      ),
      home: FutureBuilder<Player>(
        future: createPlayer(),
        builder: (context, snap) {
          switch (snap.connectionState) {
            case ConnectionState.done:
              if (snap.hasData) {
                return PlayerWidget(
                  player: snap.data,
                  child: PianoScreen(),
                );
              } else {
                return Center(
                  child: Text("AN ERROR OCCURED : ${snap.error}"),
                );
              }
              break;
            case ConnectionState.waiting:
            default:
              return Center(
                child: CircularProgressIndicator(),
              );
          }
        },
      ),
    );
  }
}
