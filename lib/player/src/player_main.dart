import 'package:flutter/foundation.dart';
import 'package:piano/note.dart';

class Player {
  void startNote({@required Note note, int octave = 5}) {
    throw UnsupportedError('startNote is Unsupported');
  }

  void stopNote({@required Note note, int octave = 5}) {
    throw UnsupportedError('stopNote Unsupported');
  }
}
