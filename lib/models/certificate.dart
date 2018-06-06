import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

class Certificate {
  Certificate({
    @required this.publicKey,
    this.privateKey,
  }) : fingerprint = _generateFingerprint(publicKey);

  final String publicKey;
  final String privateKey;
  final String fingerprint;

  static String _generateFingerprint(String publicKey) {
    final re = new RegExp(
      r'-----BEGIN CERTIFICATE-----|-----END CERTIFICATE-----|\s*',
      multiLine: true,
    );
    publicKey = publicKey.replaceAll(re, '');
    final hash = hex.encode(sha256.convert(base64.decode(publicKey)).bytes);
    return hash.replaceAllMapped(new RegExp(r'.{2}'), (match) {
      return '${match.group(0)}:';
    }).replaceFirst(new RegExp(':\$'), '');
  }

  static Future<Certificate> generate() async {
    final uri = Uri.parse('http://192.168.1.56:8081/api/v1/certificate/client');
    final httpClient = new HttpClient();
    final request = await httpClient.getUrl(uri);
    final response = await request.close();
    final encodedJson = await response.transform(utf8.decoder).join();
    final decodedJson = json.decode(encodedJson);
    final publicKey = decodedJson['certificate'];
    final privateKey = decodedJson['key'];
    return new Certificate(
      publicKey: publicKey,
      privateKey: privateKey,
    );
  }
}
