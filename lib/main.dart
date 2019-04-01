import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'SensorApp v4'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Geolocator geolocator = Geolocator();
  Position userLocation;

  @override
  void initState() {
    super.initState();
    _getLocations().then((position) {
      setState(() {
        userLocation = position;
      });
    });
  }

  Future<Position> _getLocations() async {
    var currentLocation;
    try {
      currentLocation = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          elevation: 1.0,
        ),
        body: Center(
            child: (userLocation != null)
                ? _getMap()
                : CircularProgressIndicator()));
  }

  Widget _getMap() {
    return FlutterMap(
      options: MapOptions(
          center: LatLng(userLocation.latitude, userLocation.longitude),
          zoom: 14.0),
      layers: [
        TileLayerOptions(
            urlTemplate:
                "https://api.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}",
            additionalOptions: {
              'accessToken':
                  'pk.eyJ1IjoibG9yZHZlbGlzY2giLCJhIjoiY2p0eXF2ZjNiMWxuYjN5bHo3eGw1c2xzZiJ9.oCPujMZX5MytQpGwN9c4Kg',
              'id': 'mapbox.streets'
            }),
        new MarkerLayerOptions(
          markers: [
            new Marker(
              width: 80.0,
              height: 80.0,
              point: new LatLng(userLocation.latitude, userLocation.longitude),
              builder: (ctx) => new Container(
                    child: Icon(Icons.my_location),
                  ),
            ),
          ],
        ),
      ],
    );
  }
}
