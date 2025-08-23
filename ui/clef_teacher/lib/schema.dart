import 'package:clef_teacher/piano/piano.dart';

class MidiNote {
  final Note name;
  final Accidental accidental;
  final int octave;

  const MidiNote({
    required this.name,
    required this.accidental,
    required this.octave,
  });

  factory MidiNote.fromJson(Map<String, dynamic> json) {
    final name = json['note'];
    if (name is! String) {
      throw const FormatException("name must be string");
    }

    final accidental = json['accidental'];
    if (accidental is! String && accidental != null) {
      throw const FormatException("accidental must be string");
    }

    final octave = json['octave'];
    if (octave is! int) {
      throw const FormatException("octave must be int");
    }

    return MidiNote(
      name: {
        "c": Note.C,
        'd': Note.D,
        'e': Note.E,
        'f': Note.F,
        'g': Note.G,
        'a': Note.A,
        'b': Note.B,
      }[name]!,
      accidental: {
        "sharp": Accidental.Sharp,
        "flat": Accidental.Flat,
        null: Accidental.None,
      }[accidental]!,
      octave: octave,
    );
  }
}
