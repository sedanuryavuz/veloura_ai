import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  PermissionService._privateConstructor();
  static final PermissionService instance = PermissionService._privateConstructor();

  /// Requests and handles photo gallery permission.
  /// Returns [true] if permission is granted or limited (iOS).
  Future<bool> requestGalleryPermission(BuildContext context) async {
    PermissionStatus status;

    if (Platform.isIOS) {
      status = await Permission.photos.status;
    } else {
      // For Android, check both photos (API 33+) and storage (API < 33)
      final photosStatus = await Permission.photos.status;
      final storageStatus = await Permission.storage.status;

      if (photosStatus.isGranted || storageStatus.isGranted) {
        status = PermissionStatus.granted;
      } else if (photosStatus.isPermanentlyDenied && storageStatus.isPermanentlyDenied) {
        status = PermissionStatus.permanentlyDenied;
      } else if (photosStatus.isLimited || storageStatus.isLimited) {
        status = PermissionStatus.limited;
      } else {
        status = PermissionStatus.denied;
      }
    }

    // 1. If already granted or limited, return true immediately.
    if (status.isGranted || status.isLimited) {
      if (status.isLimited && context.mounted) {
        _showLimitedAccessSnackBar(context);
      }
      return true;
    }

    // 2. If permanently denied, show settings redirect dialog and return false.
    if (status.isPermanentlyDenied) {
      if (context.mounted) {
        await _showSettingsDialog(
          context,
          title: "Gallery Permission Required",
          content: "Veloura AI has been permanently denied access to your photos. Please enable photo access in your device settings to upload clothing items.",
        );
      }
      return false;
    }

    // 3. Otherwise, it is denied (not yet permanently denied, or first-time request).
    // Show the native system permission dialog.
    PermissionStatus result;
    if (Platform.isAndroid) {
      final results = await [Permission.photos, Permission.storage].request();
      result = results[Permission.photos] ?? results[Permission.storage] ?? PermissionStatus.denied;
    } else {
      result = await Permission.photos.request();
    }

    if (result.isGranted || result.isLimited) {
      if (result.isLimited && context.mounted) {
        _showLimitedAccessSnackBar(context);
      }
      return true;
    }

    if (result.isPermanentlyDenied) {
      if (context.mounted) {
        await _showSettingsDialog(
          context,
          title: "Gallery Permission Required",
          content: "Veloura AI has been permanently denied access to your photos. Please enable photo access in your device settings to upload clothing items.",
        );
      }
      return false;
    }

    // If they just clicked "Deny" (standard denial, not permanently denied),
    // show a friendly explanation dialog and allow them to try again later.
    if (result.isDenied) {
      if (context.mounted) {
        await _showExplanationDialog(
          context,
          title: "Photo Access Needed",
          content: "We need access to your photos so you can select and upload clothing items to your digital wardrobe. You can grant access whenever you're ready!",
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

    if (status.isPermanentlyDenied) {
      if (context.mounted) {
        await _showSettingsDialog(
          context,
          title: "Camera Permission Required",
          content: "Veloura AI has been permanently denied access to your camera. Please enable camera access in your device settings to take photos of your clothes.",
        );
      }
      return false;
    }

    // Request natively
    final result = await permission.request();

    if (result.isGranted) {
      return true;
    }

    if (result.isPermanentlyDenied) {
      if (context.mounted) {
        await _showSettingsDialog(
          context,
          title: "Camera Permission Required",
          content: "Veloura AI has been permanently denied access to your camera. Please enable camera access in your device settings to take photos of your clothes.",
        );
      }
      return false;
    }

    if (result.isDenied) {
      if (context.mounted) {
        await _showExplanationDialog(
          context,
          title: "Camera Access Needed",
          content: "We need access to your camera so you can snap a picture of your clothes and add them directly to your wardrobe. You can try again later!",
        );
      }
      return false;
    }

    return false;
  }

  void _showLimitedAccessSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Limited photo access: you can only pick photos that you have selected. Manage this in settings."),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 4),
      ),
    );
  }

  Future<void> _showExplanationDialog(
    BuildContext context, {
    required String title,
    required String content,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Text(content),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
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
