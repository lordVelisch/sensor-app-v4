import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';


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

  @override
  void initState() {
    super.initState();
    _getLocations().then((position) {
      userLocation = position;
    });
  }

  Future<Position> _getLocations() async {
    var currentLocation;
    try {
      currentLocation = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
      );
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            userLocation == null
                ? CircularProgressIndicator()
                : Text(userLocation.latitude.toString()),
            
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                onPressed: () => _getLocations().then((value) {
                  setState(() {
                    userLocation = value;
                  });
                }) ,
                child: Text("Get Location"),
              ),
            )
          ],          
        )
      ),
    );
  }
}
