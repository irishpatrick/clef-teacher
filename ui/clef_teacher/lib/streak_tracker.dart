import 'package:clef_teacher/primary_text.dart';
import 'package:clef_teacher/schema.dart';
import 'package:clef_teacher/api.dart';
import 'package:clef_teacher/secondary_text.dart';
import 'package:flutter/material.dart';

class StreakTracker extends StatefulWidget {
  int current;
  StreakTracker({super.key, this.current = 0});

  @override
  State<StatefulWidget> createState() => _StreakTrackerState();
}

class _StreakTrackerState extends State<StreakTracker> {
  String _stage = "";
  String _name = "";
  int _playerBest = 0;
  HighScore? _highScore;
  @override
  void initState() {
    _stage = "loading";
    Api.getHighScore().then((value) {
      setState(() {
        _highScore = value;
        _stage = "ready";
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_stage == "ready") {
      if (widget.current == 0 && _playerBest > _highScore!.score) {
        return Row(
          children: [
            PrimaryText("New high score:", fontSize: 24),
            SizedBox(width: 16),
            SizedBox(
              width: 200,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Name",
                ),
                onChanged: (value) => _name = value,
              ),
            ),
            SizedBox(width: 32),
            ElevatedButton(
              onPressed: () {
                Api.setHighScore(
                  HighScore(name: _name, score: _playerBest),
                ).then((_) {
                  setState(() {
                    Api.getHighScore().then((value) {
                      setState(() {
                        _highScore = value;
                        _stage = "ready";
                        _playerBest = 0;
                      });
                    });
                  });
                });
              },
              child: SecondaryText("Submit", fontSize: 20),
              style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.secondaryContainer,
                elevation: 2,
                minimumSize: Size(150, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
            ),
          ],
        );
      }
      _playerBest = widget.current;
      return Row(
        children: [
          PrimaryText("Current Streak:  $_playerBest", fontSize: 24),
          SizedBox(width: 32),
          PrimaryText(
            "High Score:  ${_highScore!.score} -- ${_highScore!.name}",
            fontSize: 24,
          ),
        ],
      );
    } else {
      return CircularProgressIndicator();
    }
  }
}
