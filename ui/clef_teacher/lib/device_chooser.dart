import 'package:clef_teacher/api.dart';
import 'package:clef_teacher/secondary_text.dart';
import 'package:flutter/material.dart';

class DeviceChooser extends StatefulWidget {
  const DeviceChooser({super.key});

  @override
  State<StatefulWidget> createState() => _DeviceChooserState();
}

class _DeviceChooserState extends State<DeviceChooser> {
  String _stage = "";
  String _current = "";
  List<String> _devices = List.empty();

  @override
  void initState() {
    _stage = "loading";
    Api.getDevices().then((value) {
      setState(() {
        _devices = value;
        _devices.add("Disconnected");
        _current = _devices.first;
        _stage = "ready";
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_stage == "loading") {
      return CircularProgressIndicator();
    } else if (_stage == "ready") {
      return Row(
        children: [
          SecondaryText("MIDI Device", fontSize: 20),
          Padding(padding: EdgeInsets.all(10)),
          DropdownButton(
            value: _current,
            items: _devices
                .map(
                  (x) => DropdownMenuItem<String>(
                    value: x,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: SecondaryText(x, fontSize: 20),
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                _current = value ?? 'unknown';
                if (_current == "Disconnected") {
                  return;
                }
                Api.connectDevice(_current).then((ok) {}, onError: (err) {});
              });
            },
          ),
        ],
      );
    }

    return Text("error");
  }
}
