import 'package:flutter/material.dart';
import 'package:clef_teacher/primary_text.dart';
import 'package:clef_teacher/quiz.dart';
import 'package:clef_teacher/settings_page.dart';
import 'package:clef_teacher/device_chooser.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.inversePrimary,
        title: Center(
          child: Row(
            children: [
              PrimaryText("Clef Teacher", fontSize: 36),
              Expanded(child: Container()),
              DeviceChooser(),
              SizedBox(width: 10),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
                  );
                },
                icon: Icon(Icons.settings),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(children: [Quiz()]),
      ),
    );
  }
}
