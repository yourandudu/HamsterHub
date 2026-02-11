import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';

class PermissionService {
  static final PermissionService _instance = PermissionService._internal();
  factory PermissionService() => _instance;
  PermissionService._internal();

  // Check and request camera permission
  Future<bool> requestCameraPermission() async {
    try {
      if (Platform.isAndroid) {
        final deviceInfo = DeviceInfoPlugin();
        final androidInfo = await deviceInfo.androidInfo;
        
        // Android 13+ requires different permission handling
        if (androidInfo.version.sdkInt >= 33) {
          final status = await Permission.camera.request();
          return status.isGranted;
        } else {
          final status = await Permission.camera.request();
          return status.isGranted;
        }
      } else if (Platform.isIOS) {
        final status = await Permission.camera.request();
        return status.isGranted;
      }
      return false;
    } catch (e) {
      debugPrint('Error requesting camera permission: $e');
      return false;
    }
  }

  // Check and request photo library permission
  Future<bool> requestPhotoPermission() async {
    try {
      if (Platform.isAndroid) {
        final deviceInfo = DeviceInfoPlugin();
        final androidInfo = await deviceInfo.androidInfo;
        
        if (androidInfo.version.sdkInt >= 33) {
          // Android 13+ uses granular media permissions
          final status = await Permission.photos.request();
          return status.isGranted;
        } else {
          final status = await Permission.storage.request();
          return status.isGranted;
        }
      } else if (Platform.isIOS) {
        final status = await Permission.photos.request();
        return status.isGranted;
      }
      return false;
    } catch (e) {
      debugPrint('Error requesting photo permission: $e');
      return false;
    }
  }

  // Request multiple permissions at once
  Future<Map<Permission, PermissionStatus>> requestMultiplePermissions(List<Permission> permissions) async {
    return await permissions.request();
  }

  // Check if permission is granted
  Future<bool> isPermissionGranted(Permission permission) async {
    final status = await permission.status;
    return status.isGranted;
  }

  // Open app settings
  Future<void> openAppSettings() async {
    await openAppSettings();
  }

  // Get permission status text for UI
  String getPermissionStatusText(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
        return 'Granted';
      case PermissionStatus.denied:
        return 'Denied';
      case PermissionStatus.restricted:
        return 'Restricted';
      case PermissionStatus.limited:
        return 'Limited';
      case PermissionStatus.permanentlyDenied:
        return 'Permanently Denied';
      default:
        return 'Unknown';
    }
  }

  // Check all required permissions for the app
  Future<Map<String, bool>> checkAllRequiredPermissions() async {
    return {
      'camera': await isPermissionGranted(Permission.camera),
      'photos': await isPermissionGranted(Permission.photos),
      'storage': Platform.isAndroid ? await isPermissionGranted(Permission.storage) : true,
    };
  }

  // Request all required permissions
  Future<bool> requestAllRequiredPermissions() async {
    final cameraGranted = await requestCameraPermission();
    final photoGranted = await requestPhotoPermission();
    
    return cameraGranted && photoGranted;
  }
}