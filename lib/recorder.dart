import 'dart:typed_data';

import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

/// Helper class for recording audio.
class Recorder {
  /// Whether the app has permission to record audio.
  static Future<bool> get hasPermission =>
      Permission.microphone.status.isGranted;

  /// Records audio for a given [duration] and makes the device vibrate if the volume surpasses the given [threshold].
  static Future<void> recordAndVibrate({
    Duration duration = const Duration(seconds: 20),
    double threshold = 0.5,
  }) async {
    if (!await hasPermission) {
      throw Exception("No permission to record audio.");
    }

    final AudioRecorder recorder = AudioRecorder();
    final Stream<Uint8List> stream = await recorder
        .startStream(RecordConfig(encoder: AudioEncoder.pcm16bits));
    stream.listen((Uint8List data) {
      // Calculate the volume of the audio data.
      final double volume = data.fold<double>(
              0, (double acc, int value) => acc + value.toDouble()) /
          data.length /
          255;

      print("[DEBUG] Volume: $volume");
      print("[DATA] Data: $data");
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
