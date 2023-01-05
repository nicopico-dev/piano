import 'dart:js';

import 'package:piano/note.dart';
import 'package:tonic/tonic.dart' as tonic;

import 'player.dart';

class WebPlayer implements Player {
  @override
  void startNote({Note note, int octave = 5}) {
    final _note = _prepareNote(note: note, octave: octave);
    context.callMethod('playNote', [_note]);
  }

  @override
  void stopNote({Note note, int octave = 5}) {
    final _note = _prepareNote(note: note, octave: octave);
    context.callMethod('stopNote', [_note]);
  }

  String _prepareNote({Note note, int octave}) {
    final int midi = convertToMidi(note, octave);
    String _note = tonic.Pitch.fromMidiNumber(midi).toString();
    return _note.replaceAll('♭', 'b').replaceAll('♯', '#');
  }
}
