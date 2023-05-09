import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class AppPermission {
  static Future<bool> requestAlbum() async {
    try {

      final PermissionStatus status = await Permission.photos.request();

      switch (status) {
        case PermissionStatus.granted:
        case PermissionStatus.restricted:
        case PermissionStatus.limited:
          return true;

        case PermissionStatus.denied:
        case PermissionStatus.permanentlyDenied:
          return false;
      }

    } catch (e) {
      debugPrint('[AppPermission.requestAlbum] err: $e');
      return false;
    }
  }

  static Future<bool> requestCamera() async {
    try {

      final PermissionStatus status = await Permission.camera.request();

      switch (status) {
        case PermissionStatus.granted:
        case PermissionStatus.restricted:
        case PermissionStatus.limited:
          return true;

        case PermissionStatus.denied:
        case PermissionStatus.permanentlyDenied:
          return false;
      }

    } catch (e) {
      debugPrint('[AppPermission.requestCamera] err: $e');
      return false;
    }
  }
}