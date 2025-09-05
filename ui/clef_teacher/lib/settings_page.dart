import 'package:clef_teacher/button.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Padding(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(4),
                child: SizedBox(
                  width: double.infinity,
                  child: Button(
                    onPressed: () {},
                    child: const Text("Refresh Device List"),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(4),
                child: SizedBox(
                  width: double.infinity,
                  child: Button(
                    onPressed: () {},
                    color: Theme.of(context).colorScheme.errorContainer,
                    child: const Text("Reset High Scores"),
                  ),
                ),
              ),
              Expanded(child: Container()),
              Padding(
                padding: EdgeInsets.all(4),
                child: SizedBox(
                  width: double.infinity,
                  child: Button(
                    onPressed: () {},
                    color: Colors.grey.shade300,
                    child: const Text("Report an Issue"),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(4),
                child: SizedBox(
                  width: double.infinity,
                  child: Button(
                    onPressed: () {},
                    color: Colors.grey.shade300,
                    child: const Text("Legal"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
