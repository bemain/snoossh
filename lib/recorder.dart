import 'dart:async';

import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:snoossh/persistent_value.dart';
import 'package:vibration/vibration.dart';

/// Helper class for recording audio.
class Recorder {
  factory Recorder() => _instance;
  static final Recorder _instance = Recorder._internal();
  Recorder._internal();

  /// Whether the app has permission to record audio.
  Future<bool> get hasPermission => Permission.microphone.status.isGranted;

  /// The minimum sound volume required for the device to vibrate.
  double get threshold => thresholdNotifier.value;
  set threshold(double value) => thresholdNotifier.value = value;
  PersistentValue<double> thresholdNotifier = PersistentValue(
    "vibration/threshold",
    initialValue: -10,
  );

  int get vibrationAmplitude => vibrationAmplitudeNotifier.value;
  set vibrationAmplitude(int value) => vibrationAmplitudeNotifier.value = value;
  PersistentValue<int> vibrationAmplitudeNotifier = PersistentValue(
    "vibration/amplitude",
    initialValue: 255,
  );

  /// Records audio for a given [duration] and makes the device vibrate if the volume surpasses the given [threshold].
  Future<void> recordAndVibrate({
    Duration duration = const Duration(minutes: 5),
  }) async {
    if (!await hasPermission) {
      throw Exception("No permission to record audio.");
    }

    final AudioRecorder recorder = AudioRecorder();
    await recorder.startStream(RecordConfig());
    final Timer timer = Timer.periodic(
      const Duration(milliseconds: 50),
      (timer) async {
        final Amplitude amplitude = await recorder.getAmplitude();

        if (amplitude.current > threshold) {
          Vibration.vibrate(duration: 200, amplitude: vibrationAmplitude);
        }
      },
    );

    await Future.delayed(duration);
    timer.cancel();

    await recorder.stop();
    await recorder.dispose();
  }
}
