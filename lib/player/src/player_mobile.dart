import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:piano/note.dart';

import 'midi_utils.dart';

class Player {
  static const SF2_ASSET_FILE = 'assets/Piano.sf2';
  final FlutterMidi _flutterMidi;

  Player() : _flutterMidi = FlutterMidi() {
    _initialize();
  }

  void _initialize() async {
    ByteData sf2Bytes = await rootBundle.load(SF2_ASSET_FILE);
    await _flutterMidi.prepare(sf2: sf2Bytes).catchError((e) => print(e));
  }

  void startNote({@required Note note, int octave = 5}) async {
    int midi = convertToMidi(note, octave);
    _flutterMidi.playMidiNote(midi: midi).catchError((dynamic e) => print(e));
  }

  void stopNote({@required Note note, int octave = 5}) async {
    int midi = convertToMidi(note, octave);
    _flutterMidi.stopMidiNote(midi: midi).catchError((dynamic e) => print(e));
  }
}
