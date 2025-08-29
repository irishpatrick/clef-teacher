import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SecondaryText extends StatelessWidget {
  final String text;
  final double? fontSize;

  const SecondaryText(this.text, {super.key, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: GoogleFonts.instrumentSans(fontSize: fontSize));
  }
}
