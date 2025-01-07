import 'dart:typed_data';

import 'package:record/record.dart';

/// Helper class for recording audio.
class Recorder {
  /// Records audio for a given [duration] and makes the device vibrate if the volume surpasses the given [threshold].
  static Future<void> recordAndVibrate({
    Duration duration = const Duration(seconds: 10),
    double threshold = 0.5,
  }) async {
    final AudioRecorder recorder = AudioRecorder();
    final Stream<Uint8List> stream = await recorder.startStream(RecordConfig());
    stream.listen((Uint8List data) {
      // Calculate the volume of the audio data.
      final double volume =
          data.fold<int>(0, (int acc, int value) => acc + value) /
              data.length /
              255;
      print("[DEBUG] Volume: $volume");
      if (volume > threshold) {
        // TODO: Vibrate
        print("[DEBUG] Vibrating...");
      }
    });

    await Future.delayed(duration);
    await recorder.stop();
    await recorder.dispose();
  }
}
