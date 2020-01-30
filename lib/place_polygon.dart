import 'dart:convert';
import 'dart:async';
import 'dart:math';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:humango_chart/activitydata.dart';

const double CAMERA_ZOOM = 10;
const double CAMERA_TILT = 0;
const double CAMERA_BEARING = 30;
LatLng sourceLocation = LatLng(40.044184662401676, -105.29530922882259);
LatLng destLocation = LatLng(40.044184662401676, -105.29530922882259);

class MapPage extends StatefulWidget {
  final Widget child;
  final String jsonFile;

  MapPage({Key key, this.child, @required this.jsonFile}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();
  // this set will hold my markers
  Set<Marker> _markers = {};
  // this will hold the generated polylines
  Set<Polyline> _polylines = {};
  // this will hold each polyline coordinate as Lat and Lng pairs
  List<LatLng> polylineCoordinates = [];
  // this is the key object - the PolylinePoints
  // which generates every polyline between start and finish
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPIKey = "AIzaSyA5Ti1-kTecMW7QOql0Z8HwzQar1-rIYy0";
  // for my custom icons
  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;
  List<Activitydata> activityListData;
  bool isLoaded = false;

  _semicirclesTodegrees(double semicircles) {
    semicircles = semicircles != null ? semicircles : 0;
    semicircles = semicircles * (180 / pow(2, 31));
    print('semicircles ');
    print(semicircles);
    return semicircles;
  }

  _generateData({String jsonFile = "jsondata/latlong.json"}) async {
    print('MapPageState ss 3');
    String data = await DefaultAssetBundle.of(context).loadString(jsonFile);
    // final activities = jsonDecode(data);

    final List activityList = json.decode(data);
    activityListData =
        activityList.map((val) => Activitydata.fromJson(val)).toList();
    print(activityListData);

    print('ACTIVITY--1');

    Activitydata sourceLocationData =
        activityListData.firstWhere((act) => act.latitude != null);
    Activitydata destLocationData =
        activityListData.lastWhere((act) => act.latitude != null);

    if (sourceLocationData != null && destLocationData != null) {
      sourceLocation = LatLng(
          _semicirclesTodegrees(double.parse(sourceLocationData.latitude)),
          _semicirclesTodegrees(double.parse(sourceLocationData.longitude)));
      destLocation = LatLng(
          _semicirclesTodegrees(double.parse(destLocationData.latitude)),
          _semicirclesTodegrees(double.parse(destLocationData.longitude)));
      setState(() {
        isLoaded = true;
      });
    }

    activityListData.forEach((Activitydata activity) {
      if (activity.latitude != null && activity.longitude != null) {
        print(activity.latitude);
        double actLat = _semicirclesTodegrees(double.parse(activity.latitude));
        print(activity.longitude);
        double actLong =
            _semicirclesTodegrees(double.parse(activity.longitude));

        polylineCoordinates.add(LatLng(actLat, actLong));
      }
    });

    setState(() {
      isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    setSourceAndDestinationIcons();

    _generateData(jsonFile: this.widget.jsonFile);
  }

  void setSourceAndDestinationIcons() async {
    print('setSourceAndDestinationIcons call');
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'images/maps-and-location.png');
    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'images/destination_map_marker.png');
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialLocation = CameraPosition(
        zoom: CAMERA_ZOOM,
        bearing: CAMERA_BEARING,
        tilt: CAMERA_TILT,
        target: sourceLocation);
    print('ISLOADING');
    print(isLoaded);

    return isLoaded
        ? GoogleMap(
            myLocationEnabled: true,
            compassEnabled: true,
            tiltGesturesEnabled: false,
            markers: _markers,
            polylines: _polylines,
            mapType: MapType.normal,
            initialCameraPosition: initialLocation,
            onMapCreated: onMapCreated,
            onTap: (latlang) {
              print('LATLANG');
              print(latlang);
            })
        : Container(child: Text('Loading'));
  }

  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(Utils.mapStyles);
    _controller.complete(controller);

    setMapPins();
    setPolylines();

    setState(() {
      isLoaded = true;
    });
  }

  void setMapPins() {
    setState(() {
      // source pin
      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          position: sourceLocation,
          icon: sourceIcon));
      // destination pin
      _markers.add(Marker(
          markerId: MarkerId('destPin'),
          position: destLocation,
          icon: destinationIcon));
    });
  }

  setPolylines() async {
    List<PointLatLng> result = await polylinePoints?.getRouteBetweenCoordinates(
        googleAPIKey,
        sourceLocation.latitude,
        sourceLocation.longitude,
        destLocation.latitude,
        destLocation.longitude);
    if (result.isNotEmpty) {
      // loop through all PointLatLng points and convert them
      // to a list of LatLng, required by the Polyline

      // result.forEach((PointLatLng point) {
      // polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      // });
    }

    // await _generateData(jsonFile: this.widget.jsonFile);
    setState(() {
      isLoaded = true;
    });
    setState(() {
      // create a Polyline instance
      // with an id, an RGB color and the list of LatLng pairs
      Polyline polyline = Polyline(
          polylineId: PolylineId("poly"),
          color: Color.fromARGB(255, 40, 122, 198),
          points: polylineCoordinates,
          onTap: () {
            print('TAP on line');
          });

      // add the constructed polyline as a set of points
      // to the polyline set, which will eventually
      // end up showing up on the map
      _polylines.add(polyline);

      isLoaded = true;
    });
  }
}

class Utils {
  static String mapStyles = '''[
  
]''';
}
