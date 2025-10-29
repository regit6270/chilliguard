import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';

import '../utils/app_logger.dart';

/// Firebase Cloud Messaging & Local Notifications Service
@lazySingleton
class NotificationService {
  final FirebaseMessaging _firebaseMessaging;
  final FlutterLocalNotificationsPlugin _localNotifications;

  NotificationService(
    this._firebaseMessaging,
    this._localNotifications,
  );

  /// Initialize notification service
  Future<void> initialize() async {
    try {
      // Request permission
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      AppLogger.info(
          'Notification permission: ${settings.authorizationStatus}');

      // Initialize local notifications
      const androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosSettings = DarwinInitializationSettings();
      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _localNotifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTap,
      );

      // Configure foreground notifications
      await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // Listen to messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

      AppLogger.info('Notification service initialized');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to initialize notifications', e, stackTrace);
    }
  }

  /// Get FCM token
  Future<String?> getToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      AppLogger.info('FCM Token: $token');
      return token;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to get FCM token', e, stackTrace);
      return null;
    }
  }

  /// Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    AppLogger.info('Foreground message: ${message.messageId}');
    _showLocalNotification(message);
  }

  /// Handle background messages
  void _handleBackgroundMessage(RemoteMessage message) {
    AppLogger.info('Background message: ${message.messageId}');
  }

  /// Show local notification
  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    const androidDetails = AndroidNotificationDetails(
      'chilliguard_channel',
      'ChilliGuard Notifications',
      channelDescription: 'Crop health alerts and updates',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const iosDetails = DarwinNotificationDetails();
    const details =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      details,
      payload: message.data.toString(),
    );
  }

  /// Handle notification tap
  void _onNotificationTap(NotificationResponse response) {
    AppLogger.info('Notification tapped: ${response.payload}');
    // TODO: Navigate to relevant screen based on payload
  }

  /// Show local notification manually
  Future<void> showNotification({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'chilliguard_channel',
      'ChilliGuard Notifications',
      channelDescription: 'Crop health alerts and updates',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();
    const details =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: data?.toString(),
    );
  }

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      AppLogger.info('Subscribed to topic: $topic');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to subscribe to topic', e, stackTrace);
    }
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      AppLogger.info('Unsubscribed from topic: $topic');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to unsubscribe from topic', e, stackTrace);
    }
  }
}
