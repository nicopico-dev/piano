import 'package:flutter/material.dart';
import 'package:piano/note.dart';
import 'package:piano/player.dart';

class PianoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final windowPadding = MediaQuery.of(context).padding;

    return Container(
      color: Theme.of(context).backgroundColor,
      child: Padding(
        padding: EdgeInsets.only(
          left: windowPadding.left,
          right: windowPadding.right,
          bottom: windowPadding.bottom,
        ),
        child: LayoutBuilder(
          builder: (context, box) {
            var availableWidth = box.maxWidth;
            var keyWidth = availableWidth / (PLAIN_OCTAVE_SIZE + 1);

            return Row(
              children: <Widget>[
                _PianoOctave(
                  keyWidth: keyWidth,
                  octave: OCTAVE_BASE,
                ),
                _PianoKey(
                  note: Note.Do,
                  octave: OCTAVE_BASE + 1,
                  width: keyWidth,
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PianoOctave extends StatelessWidget {
  static final _plainNotes = Note.values.where((n) => !isSharp(n));
  static final _sharpNotes = Note.values.where(isSharp);

  final double keyWidth;
  final int octave;

  const _PianoOctave(
      {Key key, @required this.keyWidth, this.octave = OCTAVE_BASE})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Row(
        children: _plainNotes
            .map((note) => _PianoKey(
                  note: note,
                  octave: octave,
                  width: keyWidth,
                ))
            .toList(),
      ),
      Transform.translate(
        offset: Offset(keyWidth / 2.0, 0.0),
        child: Row(
          children: _sharpNotes
              .map((note) => _SharpKey(
                    note: note,
                    octave: octave,
                    width: keyWidth,
                  ))
              .cast<Widget>()
              .toList()
                ..insert(2, SizedBox(width: keyWidth)),
        ),
      ),
    ]);
  }
}

class _PianoKey extends StatelessWidget {
  final Note note;
  final double width;
  final int octave;

  const _PianoKey({
    Key key,
    @required this.note,
    @required this.width,
    @required this.octave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () => _playNote(context),
        child: Container(
          width: width,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black87),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(4.0),
            ),
          ),
        ),
      ),
    );
  }

  void _playNote(BuildContext context) {
    PlayerWidget.of(context).playNote(note: note, octave: octave);
  }
}

class _SharpKey extends _PianoKey {
  const _SharpKey({
    Key key,
    @required Note note,
    @required double width,
    @required int octave,
  }) : super(key: key, note: note, width: width, octave: octave);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: FractionallySizedBox(
        widthFactor: .5,
        heightFactor: .70,
        alignment: Alignment.topCenter,
        child: Material(
          elevation: 4.0,
          child: InkWell(
            onTap: () => _playNote(context),
            child: Ink(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black87),
                color: Colors.black,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(4.0),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
