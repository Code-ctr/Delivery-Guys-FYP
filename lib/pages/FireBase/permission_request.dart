import 'dart:convert';
import 'package:delivery_guys_fyp/pages/Driver/new_order.dart';
import 'package:delivery_guys_fyp/pages/GroceryStore/view_order.dart';
import 'package:delivery_guys_fyp/pages/Water/feed_back.dart';
import 'package:delivery_guys_fyp/pages/Water/water_home.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class LocalNotification {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLNPin =
      FlutterLocalNotificationsPlugin();
  final GlobalKey<NavigatorState>? navigatorKey;

  LocalNotification({required this.navigatorKey});

  Future<void> requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    } else {}
  }

  Future<void> init() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLNPin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        handleNotificationResponse(notificationResponse);
      },
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        showNotification(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Map<String, dynamic>? data = message.data;
      handleNotificationResponse(
        NotificationResponse(
          notificationResponseType:
              NotificationResponseType.selectedNotification,
          id: 0,
          payload: jsonEncode(data),
        ),
      );
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'channel_id',
      'Channel Name',
      channelDescription: 'Channel Description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await flutterLNPin.show(
      0, // Notification ID
      message.notification!.title,
      message.notification!.body,
      notificationDetails,
      payload: jsonEncode(message.data),
    );
    print("Message Data: ${message.data}");
  }

  Future<void> handleNotificationResponse(
      NotificationResponse notificationResponse) async {
    String? payload = notificationResponse.payload;
    if (payload != null) {
      try {
        Map<String, dynamic> data = jsonDecode(payload);
        print("Parsed Data: $data");

        // Example: Checking for required fields
        if (data.containsKey('customerName') &&
            data.containsKey('driverName')) {
          print("Customer Name: ${data['customerName']}");
          print("Driver Name: ${data['driverName']}");
        } else {
          print("Missing necessary fields in data");
        }

        // Existing switch logic
        switch (data['type']) {
          case 'New Order':
            navigatorKey?.currentState?.pushReplacement(
                MaterialPageRoute(builder: (context) => const NewOrders()));
            break;
          case 'Rejected':
            navigatorKey?.currentState?.pushReplacement(
                MaterialPageRoute(builder: (context) => const MyWidget()));
            break;
          case 'G Order':
            navigatorKey?.currentState?.pushReplacement(
                MaterialPageRoute(builder: (context) => const ReceivedOrder()));
            break;
          case 'Deliverd':
            navigatorKey?.currentState
                ?.pushReplacement(MaterialPageRoute(builder: (context) {
              return FeedBack(
                userName: data['customerName'] ?? "Null",
                driverName: data['driverName'] ?? "Null",
                deliveryId: data['order_id'] ?? "Null",
              );
            }));
            break;

          default:
            break;
        }
      } catch (e) {
        // Handle errors
        print("Error parsing payload: $e");
        print("Payload received: $payload");
      }
    }
  }
}
