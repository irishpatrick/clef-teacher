import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:retry/retry.dart';
import 'package:clef_teacher/schema.dart';

class Api {
  static final r = RetryOptions(
    maxAttempts: 10,
    delayFactor: Duration(milliseconds: 10),
  );

  static Future<List<String>> getDevices() async {
    final resp = await r.retry(
      () => http
          .get(Uri.parse('http://localhost:5050/api/devices'))
          .timeout(Duration(seconds: 5)),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );

    if (resp.statusCode != 200) {
      return [];
    }

    Iterable list = json.decode(resp.body);
    return List<String>.from(list.map((x) => x));
  }

  static Future<String> connectDevice(String name) async {
    final resp = await r.retry(
      () => http
          .post(
            Uri.parse('http://localhost:5050/api/devices/connect'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{'device': name}),
          )
          .timeout(Duration(seconds: 5)),
    );

    if (resp.statusCode != 200) {
      return 'error: ${resp.statusCode} - ${resp.body}';
    }

    return "ok";
  }

  static Future<List<MidiNote>> pollNotes() async {
    final resp = await r.retry(
      () => http
          .get(Uri.parse('http://localhost:5050/api/poll/notes'))
          .timeout(Duration(seconds: 5)),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );

    if (resp.statusCode != 200) {
      return [];
    }

    Iterable list = json.decode(resp.body);
    return List<MidiNote>.from(list.map((x) => MidiNote.fromJson(x)));
  }

  static Future<MidiNote?> getRandomNote(String lower, String upper) async {
    final resp = await r.retry(
      () => http
          .get(
            Uri.parse(
              'http://localhost:5050/api/random-note?lower=$lower&upper=$upper',
            ),
          )
          .timeout(Duration(seconds: 5)),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );

    if (resp.statusCode != 200) {
      return null;
    }

    return MidiNote.fromJson(json.decode(resp.body));
  }
}
