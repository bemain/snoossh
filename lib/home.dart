import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:snoossh/permission_builder.dart';
import 'package:snoossh/recorder.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Recorder().hasPermission,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          // Loading
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.data == false) {
          return Scaffold(
            body: PermissionBuilder(
              permission: Permission.microphone,
              permissionName: "microphone",
              permissionText:
                  "For the app to function, it needs permission to record in the background.",
              permissionDeniedIcon:
                  const Icon(Symbols.mic_off_rounded, size: 128),
              permissionGrantedIcon: const Icon(Symbols.mic_rounded, size: 128),
              onPermissionGranted: () async {
                setState(() {});
              },
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text("Snoossh"),
          ),
          body: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text("Threshold"),
                ValueListenableBuilder(
                  valueListenable: Recorder().thresholdNotifier,
                  builder: (context, threshold, child) {
                    return Slider(
                      value: threshold,
                      min: -50,
                      max: 0,
                      onChanged: (value) {
                        Recorder().threshold = value;
                      },
                    );
                  },
                ),
                Text("Vibration amplitude"),
                ValueListenableBuilder(
                  valueListenable: Recorder().vibrationAmplitudeNotifier,
                  builder: (context, amplitude, child) {
                    return Slider(
                      value: amplitude.toDouble(),
                      min: 1,
                      max: 255,
                      divisions: 10,
                      onChanged: (value) {
                        Recorder().vibrationAmplitude = value.toInt();
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
