import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:airy_connect/app.dart';
import 'package:airy_connect/models/certificate.dart';
import 'package:airy_connect/models/device.dart';
import 'package:airy_connect/widgets/pages/devices_page.dart';
import 'package:flutter/material.dart';

class AddDevicePage extends StatefulWidget {
  @override
  _AddDevicePageState createState() => new _AddDevicePageState();
}

class _AddDevicePageState extends State<AddDevicePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Добавление устройства'),
      ),
      body: new Container(
        padding: const EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new TextFormField(
                decoration: new InputDecoration(
                  labelText: 'Название устройства',
                  hintText: 'Macbook Pro',
                ),
                controller: _deviceNameController,
                validator: _deviceNameValidator,
                autofocus: true,
              ),
              new TextFormField(
                decoration: new InputDecoration(
                  labelText: 'Адрес устройства',
                  hintText: '192.168.1.34',
                ),
                controller: _deviceHostController,
                validator: _deviceHostValidator,
              ),
              new FlatButton(
                color: Colors.blue,
                textColor: Colors.white,
                onPressed: () => _onSubmitButtonPressed(context),
                child: const Text('Добавить'),
              )
            ].map((Widget child) {
              return new Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                ),
                child: child,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  final _formKey = new GlobalKey<FormState>();

  TextEditingController _deviceNameController = new TextEditingController();

  TextEditingController _deviceHostController = new TextEditingController();

  String _deviceNameValidator(String name) {
    if (name.trim().isEmpty) {
      return 'Поле не может быть пустым';
    }
    return null;
  }

  String _deviceHostValidator(String host) {
    if (host.trim().isEmpty) {
      return 'Поле не может быть пустым';
    }
    // return 'Устройство не найдено.';
    return null;
  }

  void _onSubmitButtonPressed(context) async {
    final state = _formKey.currentState;
    if (!state.validate()) return;

    final name = _deviceNameController.text;
    final host = _deviceHostController.text;

    var authorizationStatus = await _getAuthorizationStatus(host);

    if (authorizationStatus == 'BANNED') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text('Не удалось подключиться'),
            content: new Text('Ваше устройство находится в черном списке'),
          );
        },
      );
      return;
    }

    final serverCertificate = await _getServerCertificate(host);

    if (authorizationStatus == 'AUTHORIZED') {
      var device = await Device.findByCertificateFingerprint(
        serverCertificate.fingerprint,
      );

      if (device == null) {
        device = new Device(
          name: name,
          host: host,
          certificateFingerprint: serverCertificate.fingerprint,
        );
        await device.save();
      }

      final route = new MaterialPageRoute(builder: (context) {
        return new DevicesPage();
      });
      Navigator.of(context).pushAndRemoveUntil(route, (_) => false);

      return;
    }

    if (authorizationStatus == 'NOT_AUTHORIZED') {
      await _sendAuthorizationRequest(host);
      authorizationStatus = await _getAuthorizationStatus(host);
      if (authorizationStatus == 'BANNED') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return new AlertDialog(
              title: new Text('Не удалось подключиться'),
              content: new Text('Ваше устройство находится в черном списке'),
            );
          },
        );
        return;
      }
      if (authorizationStatus == 'PENDING') {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return new AlertDialog(
              title: new Text('Сравните отпечатки'),
              content: new Text(
                'Отпечаток сертификата вашего устройства:\n'
                    '${App.clientCertificate.fingerprint}\n\n'
                    'Отпечаток сертификата удаленного устройства:\n'
                    '${serverCertificate.fingerprint}',
              ),
            );
          },
        );
      }
      while (true) {
        await Future.delayed(const Duration(seconds: 1));
        authorizationStatus = await _getAuthorizationStatus(host);

        if (authorizationStatus == 'PENDING') {
          continue;
        }

        if (authorizationStatus == 'NOT_AUTHORIZED') {
          Navigator.of(context).pop();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return new AlertDialog(
                title: new Text('Не удалось подключиться'),
                content: new Text('Владелец устройства отклонил запрос'),
              );
            },
          );
          return;
        }

        if (authorizationStatus == 'AUTHORIZED') {
          final device = new Device(
            name: name,
            host: host,
            certificateFingerprint: serverCertificate.fingerprint,
          );
          device.save();

          final route = new MaterialPageRoute(builder: (context) {
            return new DevicesPage();
          });
          Navigator.of(context).pushAndRemoveUntil(route, (_) => false);

          return;
        }
      }
    }
  }

  HttpClient _getHttpClient() {
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

  Future<Certificate> _getServerCertificate(host) async {
    final httpClient = _getHttpClient();
    final url = Uri.parse('https://$host:8420/getAuthorizationStatus');
    final request = await httpClient.getUrl(url);
    final response = await request.close();
    return new Certificate(publicKey: response.certificate.pem);
  }

  Future<String> _getAuthorizationStatus(host) async {
    final httpClient = _getHttpClient();
    final url = Uri.parse('https://$host:8420/getAuthorizationStatus');
    final request = await httpClient.getUrl(url);
    final response = await request.close();
    final encodedJson = await response.transform(utf8.decoder).join();
    final decodedJson = json.decode(encodedJson);
    return decodedJson['authorizationStatus'];
  }

  Future<void> _sendAuthorizationRequest(host) async {
    final httpClient = _getHttpClient();
    final url = Uri.parse('https://$host:8420/sendAuthorizationRequest');
    final request = await httpClient.getUrl(url);
    await request.close();
  }
}
