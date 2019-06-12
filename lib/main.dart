import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'database_helper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
  Position lastLocation;

  @override
  void initState() {
    super.initState();
    _getLocations().then((position) {
      userLocation = position;
    });

    _getLastKnowLocation().then((position) {
      lastLocation = position;
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

  Future<Position> _getLastKnowLocation() async {
    var lastKnownLocation;
    try {
      lastKnownLocation = await geolocator.getLastKnownPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      lastKnownLocation = null;
    }
    return lastKnownLocation;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 1.0,
      ),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            _getPosition(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                  onPressed: () {
                    _getLocations().then((value) {
                      setState(() {
                        userLocation = value;
                      });
                    });
                  },
                  child: Text("Get Location")),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                onPressed: _saveLocation,
                child: Text("Save Location"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                onPressed: _listLocation,
                child: Text("List Locations"),
              ),
            )
          ])),
    );
  }

  Widget _getPosition() {
    if (userLocation != null) {
      return Text("Latitude: " +
          userLocation.latitude.toString() +
          ", Logitude: " +
          userLocation.longitude.toString() +
          ", Altitude: " +
          userLocation.altitude.toString());
    } else if (lastLocation != null && userLocation == null) {
      return Text("The last know Location is: " +
          "Latitude: " +
          lastLocation.latitude.toString() +
          ", Longitude: " +
          lastLocation.longitude.toString() +
          ", Altitude: " +
          lastLocation.altitude.toString());
    } else {
      return CircularProgressIndicator();
    }
  }

  _saveLocation() async {
    Location location = Location();
    location.latitude = '2131324.1234';
    location.longitude = '234234.21342';
    DatabaseHelper helper = DatabaseHelper.instance;
    int id = await helper.insert(location);
    print('inserted row: $id');
  }

  _listLocation() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    int rowId = 1;
    Location location = await helper.queryLocation(rowId);
    if (location == null) {
      print('list row $rowId: empty');
    } else {
      print('list row $rowId: ${location.longitude} ${location.latitude}');
    }
  }
}
