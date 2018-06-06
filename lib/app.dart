import 'package:airy_connect/models/certificate.dart';
import 'package:airy_connect/widgets/pages/devices_page.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  static Certificate clientCertificate;

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Airy Connect',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: new DevicesPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
