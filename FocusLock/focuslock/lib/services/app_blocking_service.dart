import 'dart:async';
import 'package:flutter/services.dart';
import '../models/app_info.dart';

class AppBlockingService {
  static final AppBlockingService _instance = AppBlockingService._internal();
  factory AppBlockingService() => _instance;
  AppBlockingService._internal();

  static const MethodChannel _channel = MethodChannel('focuslock/app_blocking');
  
  List<AppInfo> _blockedApps = [];
  bool _isActive = false;
  Timer? _checkTimer;

  // Initialize the service
  Future<void> init() async {
    try {
      await _channel.invokeMethod('init');
    } catch (e) {
      print('Failed to initialize app blocking service: $e');
    }
  }

  // Start app blocking
  Future<void> startBlocking(List<AppInfo> blockedApps) async {
    _blockedApps = blockedApps.where((app) => app.isBlocked).toList();
    _isActive = true;

    try {
      await _channel.invokeMethod('startBlocking', {
        'blockedApps': _blockedApps.map((app) => app.packageName).toList(),
      });

      // Start periodic check for blocked apps
      _startPeriodicCheck();
    } catch (e) {
      print('Failed to start app blocking: $e');
    }
  }

  // Stop app blocking
  Future<void> stopBlocking() async {
    _isActive = false;
    _checkTimer?.cancel();
    _checkTimer = null;

    try {
      await _channel.invokeMethod('stopBlocking');
    } catch (e) {
      print('Failed to stop app blocking: $e');
    }
  }

  // Check if an app is currently blocked
  bool isAppBlocked(String packageName) {
    if (!_isActive) return false;
    
    return _blockedApps.any((app) => 
      app.packageName == packageName && app.isBlocked
    );
  }

  // Get blocked app info
  AppInfo? getBlockedAppInfo(String packageName) {
    return _blockedApps.firstWhere(
      (app) => app.packageName == packageName,
      orElse: () => AppInfo(
        packageName: packageName,
        appName: packageName,
        isBlocked: false,
      ),
    );
  }

  // Start periodic check for blocked apps
  void _startPeriodicCheck() {
    _checkTimer?.cancel();
    _checkTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (!_isActive) {
        timer.cancel();
        return;
      }

      try {
        final currentApp = await _channel.invokeMethod('getCurrentApp');
        if (currentApp != null && isAppBlocked(currentApp)) {
          await _showBlockedAppDialog(currentApp);
        }
      } catch (e) {
        print('Error checking current app: $e');
      }
    });
  }

  // Show dialog when blocked app is detected
  Future<void> _showBlockedAppDialog(String packageName) async {
    final appInfo = getBlockedAppInfo(packageName);
    if (appInfo == null) return;

    try {
      await _channel.invokeMethod('showBlockedAppDialog', {
        'appName': appInfo.appName,
        'packageName': packageName,
      });
    } catch (e) {
      print('Failed to show blocked app dialog: $e');
    }
  }

  // Request necessary permissions
  Future<bool> requestPermissions() async {
    try {
      final result = await _channel.invokeMethod('requestPermissions');
      return result ?? false;
    } catch (e) {
      print('Failed to request permissions: $e');
      return false;
    }
  }

  // Check if permissions are granted
  Future<bool> checkPermissions() async {
    try {
      final result = await _channel.invokeMethod('checkPermissions');
      return result ?? false;
    } catch (e) {
      print('Failed to check permissions: $e');
      return false;
    }
  }

  // Get list of installed apps
  Future<List<AppInfo>> getInstalledApps() async {
    try {
      final result = await _channel.invokeMethod('getInstalledApps');
      if (result is List) {
        return result.map((app) => AppInfo.fromJson(app)).toList();
      }
      return [];
    } catch (e) {
      print('Failed to get installed apps: $e');
      return [];
    }
  }

  // Dispose
  void dispose() {
    _checkTimer?.cancel();
    _checkTimer = null;
  }
} 