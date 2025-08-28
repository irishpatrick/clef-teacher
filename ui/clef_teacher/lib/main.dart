import 'dart:io';

import 'package:clef_teacher/device_chooser.dart';
import 'package:clef_teacher/quiz.dart';
import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('Clef Teacher');
    setWindowMinSize(const Size(640, 480));
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
    );
    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: theme.colorScheme.inversePrimary,
          title: Text(
            "Clef Teacher",
            style: GoogleFonts.averiaSerifLibre(fontSize: 36),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(48),
          child: Column(children: [DeviceChooser(), Quiz()]),
        ),
      ),
    );
  }
}
