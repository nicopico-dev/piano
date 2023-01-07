import 'package:piano/note.dart';

int convertToMidi(Note note, int octave) {
  int midiNote = 60 + note.index;
  if (octave != OCTAVE_BASE) {
    int octaveOffset = (octave - OCTAVE_BASE) * OCTAVE_SIZE;
    midiNote += octaveOffset;
  }
  return midiNote;
}
