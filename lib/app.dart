import 'package:airy_connect/models/certificate.dart';
import 'package:airy_connect/widgets/pages/devices_page.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  static Certificate clientCertificate;

  @override
  Widget build(BuildContext context) {
    // TODO: https://github.com/flutter/flutter/issues/13736
    MaterialPageRoute.debugEnableFadingRoutes = true;
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: new DevicesPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
