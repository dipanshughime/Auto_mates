import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  LatLng _center = LatLng(45.521563, -122.677433);

  @override
  void initState() {
    super.initState();
    getUserCurrentLocation();
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  Future<Position> getUserCurrentLocation() async {
    var permission = await Geolocator.checkPermission();
    print('the permission is $permission');
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever ||
        permission == LocationPermission.unableToDetermine) {
      await Geolocator.requestPermission().catchError((error) {
        print("error: $error");
      });
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
          markers: Set<Marker>.of([
            Marker(
              markerId: MarkerId('user_location'),
              position: _center,
              infoWindow: InfoWindow(title: 'Your Location'),
            ),
          ]),
        ),
      ),
    );
  }
}
