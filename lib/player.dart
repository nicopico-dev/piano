import 'package:flutter/widgets.dart';

import 'package:piano/note.dart';
import 'package:flutter_midi/flutter_midi.dart';

class Player {
  bool _initialized = false;

  Player._();

  static Future<Player> create() async {
    var player = Player._();
    player._initialize();
    return player;
  }

  void _initialize() async {
    if (!_initialized) {
      var message = await FlutterMidi.prepare();
      print("MIDI: $message");
    } else {
      print("Skipped MIDI initialization");
    }
  }

  void startNote({@required Note note, int octave = 5}) async {
    int midi = _convertToMidi(note, octave);
    FlutterMidi.playMidiNote(midi: midi)
        .then((dynamic message) => print(message))
        .catchError((dynamic e) => print(e));
  }

  void stopNote({@required Note note, int octave = 5}) async {
    FlutterMidi.stopMidiNote()
        .then((dynamic message) => print(message))
        .catchError((dynamic e) => print(e));
  }
}

int _convertToMidi(Note note, int octave) {
  int midiNote = 60 + note.index;
  if (octave != OCTAVE_BASE) {
    int octaveOffset = (octave - OCTAVE_BASE) * OCTAVE_SIZE;
    midiNote += octaveOffset;
  }
  return midiNote;
}

class PlayerWidget extends InheritedWidget {
  final Player player;

  PlayerWidget({Key key, @required Widget child, @required this.player})
      : super(key: key, child: child);

  static Player of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(PlayerWidget) as PlayerWidget)
        .player;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }
}
