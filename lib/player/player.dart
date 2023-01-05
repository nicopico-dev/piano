import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:piano/note.dart';

import 'mobile_player.dart';
import 'web_player.dart';

abstract class Player {
  void startNote({Note note, int octave = 5});

  void stopNote({Note note, int octave = 5});
}

Future<Player> createPlayer() async {
  if (kIsWeb) {
    return WebPlayer();
  } else {
    return MobilePlayer();
  }
}

int convertToMidi(Note note, int octave) {
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
    return (context.dependOnInheritedWidgetOfExactType<PlayerWidget>()).player;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }
}
