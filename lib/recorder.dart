import 'dart:async';

import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

/// Helper class for recording audio.
class Recorder {
  factory Recorder() => _instance;
  static final Recorder _instance = Recorder._internal();
  Recorder._internal();

  /// Whether the app has permission to record audio.
  Future<bool> get hasPermission => Permission.microphone.status.isGranted;

  /// Records audio for a given [duration] and makes the device vibrate if the volume surpasses the given [threshold].
  Future<void> recordAndVibrate({
    Duration duration = const Duration(seconds: 20),
    double threshold = -10,
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
          // TODO: Vibrate
          print("[DEBUG] Vibrate");
        }
      },
    );

    await Future.delayed(duration);
    timer.cancel();

    await recorder.stop();
    await recorder.dispose();
  }
}
