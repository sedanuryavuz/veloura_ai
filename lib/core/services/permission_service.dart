import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  PermissionService._privateConstructor();
  static final PermissionService instance = PermissionService._privateConstructor();

  /// Requests and handles photo gallery permission.
  /// Returns [true] if permission is granted or limited (iOS).
  Future<bool> requestGalleryPermission(BuildContext context) async {
    Permission permission;
    if (Platform.isIOS) {
      permission = Permission.photos;
    } else {
      // For Android 13 (API 33) and above, use photos. For older versions, use storage.
      // We check the status of photos. If it's not determined or denied, we'll try to request both.
      permission = Permission.photos;
    }

    PermissionStatus status = await permission.status;

    // On Android, if photos status is not supported/restricted, we might need storage.
    if (!Platform.isIOS && status == PermissionStatus.restricted) {
      permission = Permission.storage;
      status = await permission.status;
    }

    if (status.isGranted || status.isLimited) {
      return true;
    }

    if (status.isDenied) {
      // Request permission
      Map<Permission, PermissionStatus> statuses;
      if (Platform.isAndroid) {
        statuses = await [Permission.photos, Permission.storage].request();
        status = statuses[Permission.photos] ?? statuses[Permission.storage] ?? PermissionStatus.denied;
      } else {
        status = await permission.request();
      }

      if (status.isGranted || status.isLimited) {
        return true;
      }
    }

    // Handle permanently denied status (redirect to app settings)
    if (status.isPermanentlyDenied) {
      if (context.mounted) {
        await _showSettingsDialog(
          context,
          title: "Gallery Permission Required",
          content: "Veloura AI needs access to your gallery to upload clothing items. Please enable photo access in your device settings.",
        );
      }
      return false;
    }

    return false;
  }

  /// Requests and handles camera permission.
  /// Returns [true] if permission is granted.
  Future<bool> requestCameraPermission(BuildContext context) async {
    final permission = Permission.camera;
    PermissionStatus status = await permission.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      status = await permission.request();
      if (status.isGranted) {
        return true;
      }
    }

    if (status.isPermanentlyDenied) {
      if (context.mounted) {
        await _showSettingsDialog(
          context,
          title: "Camera Permission Required",
          content: "Veloura AI needs access to your camera to take photos of your clothes. Please enable camera access in your device settings.",
        );
      }
      return false;
    }

    return false;
  }

  Future<void> _showSettingsDialog(
    BuildContext context, {
    required String title,
    required String content,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Text(content),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await openAppSettings();
              },
              child: const Text("Open Settings", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }
}
