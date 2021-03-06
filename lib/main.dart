import 'dart:async';
import 'dart:io';

import 'package:airy_connect/app.dart';
import 'package:airy_connect/models/certificate.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  // TODO: https://github.com/flutter/flutter/issues/13736
  MaterialPageRoute.debugEnableFadingRoutes = true;

  runApp(
    new MaterialApp(
      title: 'Airy Connect',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: new Scaffold(
        body: new Center(
          child: new CircularProgressIndicator(),
        ),
      ),
      debugShowCheckedModeBanner: false,
    ),
  );

  App.clientCertificate = await getClientCertificate();

  runApp(new App());
}

Future<Certificate> getClientCertificate() async {
  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;
  final publicKeyFile = new File('$path/publicKey.pem');
  final privateKeyFile = new File('$path/privateKey.pem');
  if (!await publicKeyFile.exists() || !await privateKeyFile.exists()) {
    final certificate = await Certificate.generate();
    await publicKeyFile.writeAsString(certificate.publicKey);
    await privateKeyFile.writeAsString(certificate.privateKey);
    return certificate;
  }
  final publicKey = await publicKeyFile.readAsString();
  final privateKey = await privateKeyFile.readAsString();
  return new Certificate(
    publicKey: publicKey,
    privateKey: privateKey,
  );
}
