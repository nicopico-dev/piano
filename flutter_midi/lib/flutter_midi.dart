import 'dart:async';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

class FlutterMidi {
  static const MethodChannel _channel =
      MethodChannel('fr.nicopico.piano/flutter_midi');

  /// Needed so that the sound font is loaded
  /// On iOS make sure to include the sound_font.SF2 in the Runner folder.
  /// This does not work in the simulator.
  static Future<String> prepare() async {
    final String result = await _channel.invokeMethod('prepare_midi');
    return result;
  }

  /// Play a midi note from the sound_font.SF2 library bundled with the application.
  /// Play a midi note in the range between 0-256
  /// Multiple notes can be played at once as seperate calls.
  static Future<String> playMidiNote({@required int midi}) async {
    return await _channel.invokeMethod(
      'play_midi_note',
      {'note': midi},
    );
  }

  /// Use this when stopping the sound onTouchUp or to cancel a long file.
  /// Not needed if playing midi onTap.
  static Future<String> stopMidiNote() async {
    final String result = await _channel.invokeMethod('stop_midi_note');
    return result;
  }
}
