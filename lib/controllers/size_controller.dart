import 'dart:ui';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';

class SizeController extends GetxController {
  Future<void> changeScreenSize(width, height) async {
    WindowOptions windowOptions = WindowOptions(
      size: Size(width, height),
      center: true,
      skipTaskbar: false,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
    update();
  }
}
