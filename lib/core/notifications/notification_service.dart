import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Background notification: ${message.messageId}');
}

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'order_updates',
    'Order Updates',
    description: 'Notifications about your order status',
    importance: Importance.high,
  );

  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await _requestPermission();
    await _initializeLocalNotifications();

    await _saveCurrentToken();

    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _saveCurrentToken();
      }
    });

    _messaging.onTokenRefresh.listen(_saveToken);

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    final initialMessage = await _messaging.getInitialMessage();

    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }
  }

  Future<void> _requestPermission() async {
    await _messaging.requestPermission(alert: true, badge: true, sound: true);
  }

  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const iosSettings = DarwinInitializationSettings();

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;

        if (payload != null) {
          debugPrint('Notification tapped. Order: $payload');
        }
      },
    );

    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.createNotificationChannel(_channel);
  }

  Future<void> _saveCurrentToken() async {
    final token = await _messaging.getToken();

    if (token != null) {
      await _saveToken(token);
    }
  }

  Future<void> _saveToken(String token) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('devices')
        .doc(token)
        .set({
          'token': token,
          'platform': defaultTargetPlatform.name,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

    debugPrint('FCM token saved');
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    final notification = message.notification;

    if (notification == null) return;

    await _localNotifications.show(
      id: message.hashCode,
      title: notification.title ?? 'SUFRA',
      body: notification.body ?? '',
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: message.data['orderId'],
    );
  }

  void _handleNotificationTap(RemoteMessage message) {
    final orderId = message.data['orderId'];
    final status = message.data['status'];

    debugPrint('Order notification opened: orderId=$orderId status=$status');

    // هنضيف Navigation لصفحة تفاصيل الطلب لاحقًا.
  }
}
