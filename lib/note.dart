const int OCTAVE_SIZE = 12;
const int OCTAVE_BASE = 5;
const int PLAIN_OCTAVE_SIZE = 7;

enum Note {
  Do,
  DoSharp,
  Re,
  ReSharp,
  Mi,
  Fa,
  FaSharp,
  Sol,
  SolSharp,
  La,
  LaSharp,
  Si
}

bool isSharp(Note note) {
  switch (note) {
    case Note.DoSharp:
    case Note.ReSharp:
    case Note.FaSharp:
    case Note.SolSharp:
    case Note.LaSharp:
      return true;
    default:
      return false;
  }
}
