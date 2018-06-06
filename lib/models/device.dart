import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:airy_connect/app.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Device {
  static Future<Device> findByCertificateFingerprint(fingerprint) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    String encodedJson = sharedPreferences.getString('devices');
    if (encodedJson == null) {
      encodedJson = '[]';
    }
    final List devices = json.decode(encodedJson);
    final foundDevices = devices.where((device) {
      return device['certificateFingerprint'] == fingerprint;
    });
    if (foundDevices.isEmpty) return null;
    final device = foundDevices.first;
    return new Device(
      name: device['name'],
      host: device['host'],
      certificateFingerprint: device['certificateFingerprint'],
    );
  }

  static Future<List<Device>> get all async {
    final sharedPreferences = await SharedPreferences.getInstance();
    String encodedJson = sharedPreferences.getString('devices');
    if (encodedJson == null) {
      encodedJson = '[]';
    }
    final List devices = json.decode(encodedJson);
    return devices.map((device) {
      return new Device(
        name: device['name'],
        host: device['host'],
        certificateFingerprint: device['certificateFingerprint'],
      );
    }).toList();
  }

  Device({
    @required this.name,
    @required this.host,
    @required this.certificateFingerprint,
  }) {
//    final url = 'https://${this.host}:8420';
  }

  final String name;
  final String host;
  final String certificateFingerprint;

  Future<bool> get isOnline async {
    try {
      await _authorizationStatus;
      return true;
    } catch (_) {}
    return false;
  }

  Future<String> get _authorizationStatus async {
    final httpClient = _httpClient;
    final url = Uri.parse('https://$host:8420/getAuthorizationStatus');
    final request = await httpClient.getUrl(url);
    final response = await request.close();
    final encodedJson = await response.transform(utf8.decoder).join();
    final decodedJson = json.decode(encodedJson);
    return decodedJson['authorizationStatus'];
  }

  HttpClient get _httpClient {
    final clientCertificate = App.clientCertificate;
    final securityContext = new SecurityContext();
    securityContext.useCertificateChainBytes(
      utf8.encode(clientCertificate.publicKey),
    );
    securityContext.usePrivateKeyBytes(
      utf8.encode(clientCertificate.privateKey),
    );
    final httpClient = new HttpClient(
      context: securityContext,
    );
    httpClient.badCertificateCallback = (cert, host, port) {
      return true;
    };
    return httpClient;
  }

  Future<void> save() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    String encodedJson = sharedPreferences.getString('devices');
    if (encodedJson == null) {
      encodedJson = '[]';
    }
    List devices = json.decode(encodedJson);
    final isDeviceNotExists = devices.where((device) {
      return device['certificateFingerprint'] == certificateFingerprint;
    }).isEmpty;
    if (isDeviceNotExists) {
      // CREATE
      devices.add({
        'name': name,
        'host': host,
        'certificateFingerprint': certificateFingerprint,
      });
    } else {
      // UPDATE
      devices = devices.map((device) {
        if (device['certificateFingerprint'] != certificateFingerprint) {
          return device;
        }
        return {
          'name': name,
          'host': host,
          'certificateFingerprint': certificateFingerprint,
        };
      }).toList();
    }
    sharedPreferences.setString('devices', json.encode(devices));
  }

  Future<void> delete() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    String encodedJson = sharedPreferences.getString('devices');
    if (encodedJson == null) {
      encodedJson = '[]';
    }
    List devices = json.decode(encodedJson);
    devices.removeWhere((device) {
      return device['certificateFingerprint'] == certificateFingerprint;
    });
    sharedPreferences.setString('devices', json.encode(devices));
  }
}
