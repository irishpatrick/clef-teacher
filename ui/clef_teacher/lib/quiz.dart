import 'dart:async';

import 'package:clef_teacher/schema.dart';
import 'package:flutter/material.dart';
import 'package:clef_teacher/api.dart';
import 'package:clef_teacher/piano/piano.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<StatefulWidget> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  String _stage = "";
  MidiNote? _answer;
  MidiNote? _guess;
  bool _waitingForGuess = true;

  void _startPolling() {
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      Api.pollNotes().then((notes) {
        if (_waitingForGuess) {
          if (notes.length != 1) {
            return;
          }
          setState(() {
            _guess = notes[0];
            _waitingForGuess = false;
          });
        } else {
          if (notes.isEmpty) {
            timer.cancel();
            Timer(Duration(seconds: 1), () {
              Api.getRandomNote("f2", "e4").then((value) {
                setState(() {
                  _guess = null;
                  _answer = value;
                  _startPolling();
                  _waitingForGuess = true;
                });
              });
            });
          }
        }
      });
    });
  }

  List<NoteImage> buildNoteImages() {
    var images = [
      NoteImage(
        notePosition: NotePosition(
          note: _answer!.name,
          octave: _answer!.octave,
          accidental: _answer!.accidental,
        ),
      ),
    ];

    if (_guess != null) {
      images.insert(
        1,
        NoteImage(
          color: _guess! == _answer! ? Colors.green : Colors.red,
          offset: 0.7,
          notePosition: NotePosition(
            note: _guess!.name,
            octave: _guess!.octave,
            accidental: _guess!.accidental,
          ),
        ),
      );
    }

    return images;
  }

  @override
  void initState() {
    _stage = "loading";
    Api.getRandomNote("f2", "e4").then((value) {
      setState(() {
        _guess = null;
        _answer = value;
        _startPolling();
        _stage = "ready";
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_stage == "loading") {
      return CircularProgressIndicator();
    } else if (_stage == "ready" && _answer != null) {
      return SizedBox(
        width: 600,
        height: 200,
        child: ClefImage(
          size: Size.infinite,
          clef: Clef.Bass,
          noteRange: NoteRange.forClefs([Clef.Treble, Clef.Bass]),
          noteImages: buildNoteImages(),
          clefColor: Colors.black,
          noteColor: Colors.black,
        ),
      );
    } else {
      return CircularProgressIndicator();
    }
  }
}
