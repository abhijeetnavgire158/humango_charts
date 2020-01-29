import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ActivityMap extends StatefulWidget {
  @override
  _ActivityMapState createState() => _ActivityMapState();
}

class _ActivityMapState extends State<ActivityMap> {
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _myLocation = CameraPosition(
    target: LatLng(0, 0),
  );

  static const LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Maps Sample App'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          initialCameraPosition: _myLocation,
          mapType: MapType.normal,
          onMapCreated: _onMapCreated,
        ),
      ),
    );
  }
}
