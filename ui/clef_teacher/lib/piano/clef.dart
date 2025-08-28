/* 
 * Copyright 2021 Craig McMahon
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the 
 * following conditions are met:
 * 
 * 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following 
 * disclaimer.
 * 
 * 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the
 * following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote
 * products derived from this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
 * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import 'note_position.dart';

enum Clef { Bass, Alto, Treble }

extension ClefSymbols on Clef {
  String get symbol {
    switch (this) {
      case Clef.Treble:
        return "𝄞";
      case Clef.Bass:
        return "𝄢";
      case Clef.Alto:
        return "𝄡";
    }
  }
}

extension ClefNotePositions on Clef {
  NotePosition get firstLineNotePosition {
    switch (this) {
      case Clef.Bass:
        return NotePosition(note: Note.G, octave: 2);
      case Clef.Alto:
        return NotePosition(note: Note.F, octave: 3);
      case Clef.Treble:
        return NotePosition(note: Note.E, octave: 4);
    }
  }

  NotePosition get lastLineNotePosition {
    switch (this) {
      case Clef.Bass:
        return NotePosition(note: Note.A, octave: 3);
      case Clef.Alto:
        return NotePosition(note: Note.G, octave: 4);
      case Clef.Treble:
        return NotePosition(note: Note.F, octave: 5);
    }
  }
}
