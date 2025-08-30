import 'dart:io';

import 'package:clef_teacher/device_chooser.dart';
import 'package:clef_teacher/primary_text.dart';
import 'package:clef_teacher/quiz.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:window_size/window_size.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  GoogleFonts.config.allowRuntimeFetching = false;

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
          title: Center(
            child: Row(
              children: [
                PrimaryText("Clef Teacher", fontSize: 36),
                Expanded(child: Container()),
                DeviceChooser(),
                SizedBox(width: 10),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(children: [Quiz()]),
        ),
      ),
    );
  }
}
