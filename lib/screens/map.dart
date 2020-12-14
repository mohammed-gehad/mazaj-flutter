import 'package:flutter/material.dart';
import "package:latlong/latlong.dart" as latLng;
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class MapWebView extends StatefulWidget {
  dynamic _customerLocation;
  MapWebView(this._customerLocation);
  @override
  _MapWebViewState createState() => _MapWebViewState();
}

class _MapWebViewState extends State<MapWebView> {
  String url;
  @override
  void initState() {
    super.initState();
    url =
        'https://www.google.com/maps/search/${widget._customerLocation["lat"]},${widget._customerLocation["lng"]}';
  }

  double progress = 0;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'خريطة',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Container(
          child: WebviewScaffold(
            url: url,
            withZoom: true,
            hidden: true,
            geolocationEnabled: true,
          ),
        ),
      ),
    );
  }
}
