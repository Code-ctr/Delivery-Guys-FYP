import 'dart:convert';
import 'package:delivery_guys_fyp/model/cart_model.dart';
import 'package:delivery_guys_fyp/pages/FireBase/permission_request.dart';
import 'package:delivery_guys_fyp/sigin_sigup/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  LocalNotification localNotification =
      LocalNotification(navigatorKey: navigatorKey);
  await localNotification.requestPermission();
  await localNotification.init();

  runApp(MyApp(localNotification: localNotification));
}

class MyApp extends StatefulWidget {
  final LocalNotification? localNotification;
  const MyApp({super.key, this.localNotification});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    notificationhandler();
    checkInitialMessage();
  }

  void notificationhandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      widget.localNotification!.showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Map<String, dynamic>? data = message.data;
      widget.localNotification!.handleNotificationResponse(
        NotificationResponse(
          notificationResponseType:
              NotificationResponseType.selectedNotification,
          id: 0,
          payload: jsonEncode(data),
        ),
      );
    });
  }

  void checkInitialMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    Map<String, dynamic>? data = initialMessage?.data;
    if (initialMessage != null) {
      widget.localNotification!.handleNotificationResponse(
        NotificationResponse(
          notificationResponseType:
              NotificationResponseType.selectedNotification,
          id: 0,
          payload: jsonEncode(data),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        home: const LoginPage(),
      ),
    );
  }
}
