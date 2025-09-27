import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:delivery_guys_fyp/pages/FireBase/serverkey.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Register with email and password
  Future<User?> registerWithEmailAndPassword(
      String email, String password, Map<String, dynamic> userInfo) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save additional user information in Firestore
      await _firestore
          .collection('users')
          .doc(userCredential.user?.uid)
          .set(userInfo);

      return userCredential.user;
    } catch (e) {
      return null;
    }
  }

  Future<void> updateDeviceToken(String uid) async {
    String? currentToken = await getUserTokenMessaging();

    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(uid).get();
    if (userDoc.exists) {
      String? storedToken = userDoc['token'];

      if (currentToken != storedToken) {
        await _firestore.collection('users').doc(uid).update({
          'token': currentToken,
        });
      }
    }
  }

  // Login with email and password
  Future<User?> loginWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user != null) {
        // Update the device token on login
        await updateDeviceToken(user.uid);
      }
      return user;
    } catch (e) {
      return null;
    }
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Get user role
  Future<String?> getUserRole(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();
      return userDoc['role'];
    } catch (e) {
      return null;
    }
  }

  Future<String?> getUserState(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();
      return userDoc['state'];
    } catch (e) {
      return null;
    }
  }

  Future<String?> getUserFullName(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();
      return userDoc['fullName'];
    } catch (e) {
      return null;
    }
  }

  Future<String?> getUserAddress(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();
      return userDoc['address'];
    } catch (e) {
      return null;
    }
  }

  Future<String?> getUserMobileNo(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();
      return userDoc['phone'];
    } catch (e) {
      return null;
    }
  }

  Future<void> updateDriverStatus(String uid, String status) async {
    try {
      await _firestore.collection('users').doc(uid).update({'status': status});
    } catch (e) {
      // ignore: avoid_print
      print("Error updating driver status: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getAvailableDrivers() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'Driver')
          .where('status', isEqualTo: 'available')
          .get();

      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getGStores() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'Grocery Store')
          .get();

      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveOrder(Map<String, dynamic> orderData) async {
    try {
      await _firestore.collection('orders').add(orderData);
    } catch (e) {
      // ignore: avoid_print
      print("Error saving order: $e");
    }
  }

  Future<void> notifyDriver(
      String driverName, Map<String, dynamic> orderData) async {
    try {
      String driverId = (await _firestore
              .collection('users')
              .where('fullName', isEqualTo: driverName)
              .limit(1)
              .get())
          .docs
          .first
          .id;

      await _firestore
          .collection('users')
          .doc(driverId)
          .collection('orders')
          .add(orderData);
    } catch (e) {
      // ignore: avoid_print
      print("Error notifying driver: $e");
    }
  }

  Future<List<Map<String, dynamic>>> fetchDriverOrders(String driverId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('orders')
          .where('selectedDriver', isEqualTo: driverId)
          .where('status', whereIn: ['new', 'inProgress']).get();

      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['orderId'] = doc.id; // Add the order ID to the data
        return data;
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchStoreOrders(String driverId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('orders')
          .where('store', isEqualTo: driverId)
          .where('status', isEqualTo: 'new')
          .get();

      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['orderId'] = doc.id; // Add the order ID to the data
        return data;
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await _firestore
          .collection('orders')
          .doc(orderId)
          .update({'status': status});
    } catch (e) {
      // ignore: avoid_print
      print("Error updating order status: $e");
    }
  }

  Future<String> getUserTokenMessaging() async {
    String? token = await _firebaseMessaging.getToken();
    return token ?? '';
  }

  Future<String?> getToken(String name) async {
    try {
      QuerySnapshot driverSnapshot = await _firestore
          .collection('users')
          .where('fullName', isEqualTo: name)
          .limit(1)
          .get();

      if (driverSnapshot.docs.isNotEmpty) {
        DocumentSnapshot driverDoc = driverSnapshot.docs.first;
        return driverDoc['token'] as String?;
      } else {
        // ignore: avoid_print
        print("No driver found with that name.");
        return null;
      }
    } catch (e) {
      // ignore: avoid_print
      print("Error fetching driver token: $e");
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getUserFeedbackHistory(
      String role, String userName) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('feedback')
        .where(role, isEqualTo: userName)
        .orderBy('time', descending: true)
        .get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<void> saveItem(Map<String, dynamic> itemData) async {
    try {
      await _firestore.collection('items').add(itemData);
    } catch (e) {
      print("Error saving item: $e");
    }
  }

  Future<String?> getDriverIdByCustomerName(String customerName) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('location')
          .where('customerName', isEqualTo: customerName)
          .where('status', isEqualTo: 'new')
          .get();

      print("Query returned ${querySnapshot.docs.length} documents");

      // Check if any documents were returned
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;

        // Print the document data to see what's inside
        print("Document data: ${doc.data()}");

        // Attempt to retrieve the "orderId" field
        String driverId = doc['orderId'];
        print(driverId);
        return driverId;
      } else {
        return null; // No documents found
      }
    } catch (e) {
      print("Error getting driver ID: $e");
      return null;
    }
  }
}
