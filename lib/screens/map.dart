import 'package:flutter/material.dart';
import "package:latlong/latlong.dart" as latLng;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class MapWebView extends StatefulWidget {
  dynamic _customerLocation;
  MapWebView(this._customerLocation);
  @override
  _MapWebViewState createState() => _MapWebViewState();
}

class _MapWebViewState extends State<MapWebView> {
  latLng.LatLng pin;
  @override
  void initState() {
    super.initState();
    setState(() {
      pin = latLng.LatLng(
          widget._customerLocation["lat"], widget._customerLocation["lng"]);
    });
  }

  InAppWebViewController webView;
  String url = "";
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
          child: InAppWebView(
            initialUrl:
                "https://www.google.com/maps/search/${widget._customerLocation["lat"]},${widget._customerLocation["lng"]}",
            initialHeaders: {},
            initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
              debuggingEnabled: true,
            )),
            onWebViewCreated: (InAppWebViewController controller) {
              webView = controller;
            },
            onLoadStart: (InAppWebViewController controller, String url) {
              setState(() {
                this.url = url;
              });
            },
            onLoadStop: (InAppWebViewController controller, String url) async {
              setState(() {
                this.url = url;
              });
            },
            onProgressChanged:
                (InAppWebViewController controller, int progress) {
              setState(() {
                this.progress = progress / 100;
              });
            },
          ),
        ),
      ),
    );
  }
}
