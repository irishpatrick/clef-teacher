import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:google_fonts/google_fonts.dart';

import 'clef.dart';
import 'note_position.dart';
import 'note_range.dart';

class NoteImage {
  final NotePosition notePosition;
  final double offset;
  final Color? color;

  NoteImage({required this.notePosition, this.offset = 0.5, this.color});
}

class ClefPainter extends CustomPainter with EquatableMixin {
  final Clef clef;

  /// The note range we'll make space for in this drawing.
  final NoteRange noteRange;

  /// The note range we'll actually draw notes for.
  final NoteRange? noteRangeToClip;
  final List<NoteImage> noteImages;
  final EdgeInsets padding;
  final int lineHeight;
  final Color clefColor;
  final Color noteColor;

  /// Satisfies `EquatableMixin` and used in shouldRepaint for redraw efficiency
  @override
  List<Object?> get props => [
    clef,
    noteRange,
    noteRangeToClip,
    noteImages,
    padding,
    lineHeight,
    clefColor,
    noteColor,
  ];

  final Paint _linePaint;
  final Paint _notePaint;
  final Paint _tailPaint;

  TextPainter? _clefSymbolPainter;
  final Map<Accidental, TextPainter> _accidentalSymbolPainters = {};
  Size? _lastClefSize;
  final List<NotePosition> _naturalPositions;

  ClefPainter({
    required this.clef,
    required this.noteRange,
    this.noteRangeToClip,
    this.noteImages = const [],
    this.padding = const EdgeInsets.all(16),
    this.clefColor = Colors.black,
    this.noteColor = Colors.black,
    this.lineHeight = 1,
  }) : _naturalPositions = noteRange.naturalPositions,
       _linePaint = Paint()
         ..color = clefColor
         ..strokeWidth = lineHeight.toDouble(),
       _notePaint = Paint(),
       _tailPaint = Paint()..strokeWidth = lineHeight.toDouble();

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = padding.deflateRect(Offset.zero & size);

    if (bounds.height <= 0) {
      return;
    }

    naturalPositionOf(notePosition) =>
        (noteRangeToClip?.contains(notePosition) == false)
        ? -1
        : _naturalPositions.indexWhere(
            (i) =>
                i.note == notePosition.note && i.octave == notePosition.octave,
          );

    final clefSize = Size(80, bounds.height);

    final noteHeight = bounds.height / _naturalPositions.length.toDouble();

    final firstLineIndex = _naturalPositions.indexOf(
      clef.firstLineNotePosition,
    );
    final lastLineIndex = _naturalPositions.indexOf(clef.lastLineNotePosition);

    final firstLineIsEven = firstLineIndex % 2 == 0;

    final ovalHeight = noteHeight * 2;
    final ovalWidth = ovalHeight * 1.5;

    double? firstLineY, lastLineY;

    for (
      var line = firstLineIsEven ? 0 : 1;
      line < _naturalPositions.length;
      line += 2
    ) {
      NoteImage? ledgerLineImage;
      if (line < firstLineIndex || line > lastLineIndex) {
        ledgerLineImage = line < firstLineIndex
            ? noteImages.firstWhereOrNull((i) {
                final position = naturalPositionOf(i.notePosition);
                return position != -1 && position <= line;
              })
            : noteImages.firstWhereOrNull(
                (i) => naturalPositionOf(i.notePosition) >= line,
              );
        if (ledgerLineImage == null) {
          continue;
        }
      } else {
        ledgerLineImage = null;
      }
      final y = (bounds.height - ((line * noteHeight) - noteHeight / 2))
          .roundToDouble();
      if (ledgerLineImage != null) {
        final ledgerLineLeft =
            bounds.left +
            clefSize.width +
            (bounds.width - ovalWidth * 2 - clefSize.width) *
                ledgerLineImage.offset;
        final ledgerLineRight = ledgerLineLeft + ovalWidth * 1.6;
        canvas.drawLine(
          Offset(ledgerLineLeft, y),
          Offset(ledgerLineRight, y),
          _linePaint,
        );
      } else {
        canvas.drawLine(
          Offset(bounds.left, y),
          Offset(bounds.right, y),
          _linePaint,
        );

        firstLineY ??= y;
        lastLineY = y;
      }
    }

    const tailHeight = 7;
    final middleLineIndex =
        (firstLineIndex + (lastLineIndex - firstLineIndex - 1) / 2).floor();

    for (final noteImage in noteImages) {
      final noteIndex = naturalPositionOf(noteImage.notePosition);
      if (noteIndex == -1) {
        continue;
      }
      final ovalRect = Rect.fromLTWH(
        bounds.left +
            clefSize.width +
            (bounds.width - ovalWidth * 1.5 - clefSize.width) *
                noteImage.offset,
        bounds.height - (noteIndex * noteHeight) - noteHeight / 2,
        ovalWidth,
        ovalHeight,
      );
      canvas.save();
      canvas.translate(ovalRect.left, ovalRect.top + noteHeight * 0.3);
      canvas.rotate(-0.2);
      _notePaint.color = noteImage.color ?? noteColor;
      canvas.drawOval(Offset.zero & ovalRect.size, _notePaint);
      canvas.restore();

      final isOnOrAboveMiddleLine = noteIndex > middleLineIndex;

      final Offset tailFrom, tailTo;

      if (isOnOrAboveMiddleLine) {
        // Tail hangs down, on the left side
        tailFrom =
            ovalRect.centerLeft -
            Offset(
              -_tailPaint.strokeWidth / 2 - ovalWidth * 0.06,
              -ovalHeight * 0.1,
            );
        tailTo = tailFrom + Offset(0, noteHeight * tailHeight);
      } else {
        // Tail stucks up, on the right side
        tailFrom =
            ovalRect.centerRight +
            Offset(
              -_tailPaint.strokeWidth / 2 + ovalWidth * 0.06,
              -ovalHeight * 0.1,
            );
        tailTo = tailFrom + Offset(0, -noteHeight * tailHeight);
      }

      _tailPaint.color = noteImage.color ?? noteColor;
      canvas.drawLine(tailFrom, tailTo, _tailPaint);

      if (noteImage.notePosition.accidental != Accidental.None) {
        if (_accidentalSymbolPainters[noteImage.notePosition.accidental] ==
            null) {
          _accidentalSymbolPainters[noteImage.notePosition.accidental] =
              TextPainter(
                text: TextSpan(
                  text: noteImage.notePosition.accidental.symbol,
                  style: TextStyle(
                    fontSize: ovalHeight * 2,
                    color: noteImage.color ?? noteColor,
                  ),
                ),
                textDirection: TextDirection.ltr,
              )..layout();
        }

        _accidentalSymbolPainters[noteImage.notePosition.accidental]?.paint(
          canvas,
          ovalRect.topLeft.translate(-ovalHeight, -ovalHeight / 2),
        );
      }
    }

    if (firstLineY == null || lastLineY == null) {
      return;
    }

    final clefHeight = (firstLineY - lastLineY);
    final clefSymbolOffset = (clef == Clef.Treble) ? 0.45 : 0.55;

    if (_clefSymbolPainter == null || clefSize != _lastClefSize) {
      final clefSymbolScale = (clef == Clef.Treble) ? 2.35 : 1.10;
      _clefSymbolPainter = TextPainter(
        text: TextSpan(
          text: clef.symbol,
          // style: TextStyle(
          //   fontSize: clefHeight * clefSymbolScale,
          //   color: clefColor,
          // ),
          style: GoogleFonts.notoMusic(
            fontSize: clefHeight * clefSymbolScale,
            color: clefColor,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
    }
    _lastClefSize = clefSize;

    _clefSymbolPainter?.paint(
      canvas,
      Offset(bounds.left, lastLineY - clefSymbolOffset * clefHeight),
    );
  }

  @override
  bool shouldRepaint(covariant ClefPainter oldDelegate) => oldDelegate != this;
}
