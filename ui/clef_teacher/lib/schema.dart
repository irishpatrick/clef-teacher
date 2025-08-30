import 'package:clef_teacher/piano/piano.dart';

class HighScore {
  final String name;
  final int score;

  const HighScore({required this.name, required this.score});

  factory HighScore.fromJson(Map<String, dynamic> json) {
    final name = json['name'];
    if (name is! String) {
      throw const FormatException("name must be a string");
    }

    final score = json['score'];
    if (score is! int) {
      throw const FormatException("score must be a number");
    }

    return HighScore(name: name, score: score);
  }
}

class MidiNote {
  final Note name;
  final Accidental accidental;
  final int octave;

  const MidiNote({
    required this.name,
    required this.accidental,
    required this.octave,
  });

  @override
  bool operator ==(Object other) {
    if (other is! MidiNote) {
      return false;
    }

    var enharmonic = getEnharmonic();

    return (name == other.name &&
            accidental == other.accidental &&
            octave == other.octave) ||
        (enharmonic.name == other.name &&
            enharmonic.accidental == other.accidental &&
            enharmonic.octave == other.octave);
  }

  MidiNote coerce(MidiNote other) {
    if (accidental == Accidental.None ||
        other.accidental == Accidental.None ||
        accidental == other.accidental) {
      return this;
    }

    return getEnharmonic();
  }

  MidiNote getEnharmonic() {
    if (accidental == Accidental.None) {
      return this;
    }

    var noteIndexMap = {
      Note.C: 0,
      Note.D: 1,
      Note.E: 2,
      Note.F: 3,
      Note.G: 4,
      Note.A: 5,
      Note.B: 6,
    };

    var modifierMap = {Accidental.Sharp: 1, Accidental.Flat: -1};

    var enharmonicMap = {
      Accidental.Sharp: Accidental.Flat,
      Accidental.Flat: Accidental.Sharp,
    };

    var newIndex = noteIndexMap[name]! + modifierMap[accidental]!;
    var octaveDir = 0;
    if (newIndex >= 7) {
      octaveDir = 1;
    }
    if (newIndex < 0) {
      octaveDir = -1;
    }
    newIndex = newIndex % 7;

    return MidiNote(
      name: noteIndexMap.keys.elementAt(newIndex),
      accidental: enharmonicMap[accidental]!,
      octave: octave + octaveDir,
    );
  }

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
