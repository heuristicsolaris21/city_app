import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseApi {
  final _databaseReference = FirebaseDatabase.instance.reference();
  final _androidChannel = const AndroidNotificationChannel(
    'High Importance Channel',
    'High Importance Notification',
    description: 'this is the channe used for most important notification',
    importance: Importance.defaultImportance,
    sound: RawResourceAndroidNotificationSound('notify'),
  );
  final _localNotifications = FlutterLocalNotificationsPlugin();

  final _firebaseMessaging = FirebaseMessaging.instance;
  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print("***********************************************#######################");
    final snapshot = await _databaseReference
        .child('usertokens')
        .orderByValue()
        .equalTo(fCMToken)
        .once();

    if (snapshot.snapshot.value == null) {
      // If the token does not exist, add it to the database
      _databaseReference.child('usertokens').push().set(fCMToken);
    }
    await initPushNotifications();
    await initLocalNotification();
    FirebaseMessaging.onBackgroundMessage(handleBackgroungMessage);
  }

  void handlemessage(RemoteMessage? message) {
    if (message == null) return;
  }

  Future initLocalNotification() async {
    const android = AndroidInitializationSettings('cityapplogo');
    const settings = InitializationSettings(android: android);
    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final message = RemoteMessage.fromMap(jsonDecode(response.payload!));
        handlemessage(message);
      },
    );
    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  Future initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance.getInitialMessage().then(handlemessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handlemessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroungMessage);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;
      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
              _androidChannel.id, _androidChannel.name,
              channelDescription: _androidChannel.description,
              icon: 'cityapplogo'),
        ),
        payload: jsonEncode(message.toMap()),
      );
    });
  }
}

Future<void> handleBackgroungMessage(RemoteMessage message) async {
  print('title:${message.notification?.title}');
  print('body:${message.notification?.body}');
  print('payload:${message.data}');
}














