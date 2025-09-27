// ignore_for_file: library_private_types_in_public_api
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_guys_fyp/pages/FireBase/fire_registeration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverTrackingMap extends StatefulWidget {
  const DriverTrackingMap({super.key});

  @override
  _DriverTrackingMapState createState() => _DriverTrackingMapState();
}

class _DriverTrackingMapState extends State<DriverTrackingMap> {
  late GoogleMapController _controller;
  final AuthService _authService = AuthService();
  bool _isMapCreated = false;
  String? orderid = "";

  @override
  void initState() {
    super.initState();
    _gettingdriverID();
  }

  void _gettingdriverID() async {
    User? user = _authService.getCurrentUser();
    String? customerName = await _authService.getUserFullName(user!.uid);
    String? id = await _authService.getDriverIdByCustomerName(customerName!);
    setState(() {
      orderid = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (orderid == null || orderid!.isEmpty) {
      return const Center(child: Text("No active deliveries"));
    }
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        // Stream to listen to real-time updates for the driver's location
        stream: FirebaseFirestore.instance
            .collection('location')
            .doc(orderid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var driverData = snapshot.data!;
          String status = driverData['status'];
          double latitude = driverData['latitude'];
          double longitude = driverData['longitude'];

          if(status == 'new'){}
          if (_isMapCreated) {
            // Move the camera to the driver's new location
            _moveCamera(LatLng(latitude, longitude));
          }

          return GoogleMap(
            mapType: MapType.normal,
            markers: {
              Marker(
                position: LatLng(latitude, longitude),
                markerId: MarkerId(orderid!),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueMagenta),
              ),
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(latitude, longitude),
              zoom: 14.47,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
              setState(() {
                _isMapCreated = true;
              });
            },
          );
        },
      ),
    );
  }

  void _moveCamera(LatLng newPosition) {
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: newPosition, zoom: 14.47),
      ),
    );
  }
}
