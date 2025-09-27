import 'dart:convert';
import 'package:delivery_guys_fyp/pages/FireBase/serverkey.dart';
import 'package:http/http.dart' as http;

class Constants {
  static const String BASE_URL =
      "https://fcm.googleapis.com/v1/projects/delivery-guys-database/messages:send";
}

class NotificationService {
  Future<void> pushNotification({
    required String title,
    required String body,
    required String token,
    required String type, // Add the type parameter
    String? orderId,
    String? driverName,
    String? customerName,
  }) async {
    GetServerKey tokenkey = GetServerKey();
    String serverKey = await tokenkey.getServerkeyToken();

    Map<String, dynamic> payload = {
      "message": {
        "token": token,
        "notification": {
          "title": title,
          "body": body,
        },
        "data": {
          "type": type,
          if (orderId != null) "order_id": orderId,
          "customerName": customerName,
          "driverName": driverName
        },
        "android": {
          "priority": "high",
          "notification": {
            "sound": "default",
          }
        },
        "apns": {
          "payload": {
            "aps": {
              "sound": "default",
            }
          }
        }
      }
    };

    String dataNotification = jsonEncode(payload);
    var response = await http.post(
      Uri.parse(Constants.BASE_URL),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serverKey',
      },
      body: dataNotification,
    );

    if (response.statusCode == 200) {
      print("Notification sent successfully");
    } else {
      print(
          "Failed to send notification: ${response.statusCode} - ${response.body}");
    }
  }
}
