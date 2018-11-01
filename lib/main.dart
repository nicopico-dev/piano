import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:piano/piano.dart';
import 'package:piano/player.dart';

void main() {
  // Disable the status bar and the system bar
  // Then lock the app in landscape orientation
  SystemChrome.setEnabledSystemUIOverlays([])
      .then(
        (_) => SystemChrome.setPreferredOrientations(
              [
                DeviceOrientation.landscapeLeft,
                DeviceOrientation.landscapeRight,
              ],
            ),
      )
      .then((_) => runApp(PianoApp()));
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
        future: Player.create(),
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
