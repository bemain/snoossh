import 'package:flutter/foundation.dart';
import 'package:snoossh/recorder.dart';
import 'package:workmanager/workmanager.dart';

/// Helper class for scheduling background tasks.
class Background {
  static const String recorderTask = "se.agardh.snoossh.recorderTask";

  /// Initializes the background task scheduler.
  static void initialize() {
    Workmanager().initialize(_callbackDispatcher, isInDebugMode: kDebugMode);
    // FIXME: Remove
    Workmanager().registerOneOffTask(
      "oneoff-task",
      recorderTask,
      initialDelay: const Duration(seconds: 5),
    );
    Workmanager().registerPeriodicTask(
      recorderTask,
      recorderTask,
      initialDelay: const Duration(seconds: 5),
      frequency: const Duration(minutes: 15),
    );
  }
}

/// Callback dispatcher for background tasks.
@pragma('vm:entry-point')
void _callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print("[DEBUG] Native called background task: $task");

    try {
      switch (task) {
        case Background.recorderTask:
          await Recorder().recordAndVibrate();
          break;
      }
    } catch (e) {
      debugPrint("[BACKGROUND] Error: $e");
      rethrow;
    }

    return true;
  });
}
