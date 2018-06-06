import 'dart:math';

import 'package:airy_connect/models/device.dart';
import 'package:airy_connect/widgets/pages/add_device_page.dart';
import 'package:airy_connect/widgets/pages/device_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show Key;
import 'package:flutter/material.dart';

class DevicesPage extends StatefulWidget {
  DevicesPage({Key key}) : super(key: key);

  @override
  _DevicesPageState createState() => new _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Ваши устройства'),
      ),
      body: _getBody(context),
      floatingActionButton: new FloatingActionButton(
        onPressed: () async {
          final route = new MaterialPageRoute(
            builder: (BuildContext context) => new AddDevicePage(),
          );
          Navigator.of(context).push(route);
//          _showAddDeviceDialog(context);
//          final addDeviceDialog = new AddDevicePage();
//          await showDialog(
//            context: context,
//            child: addDeviceDialog,
//            barrierDismissible: false,
//          );
//          final route = new MaterialPageRoute(
//            builder: (BuildContext context) => new AddDevicePage(),
//          );
//          Navigator.of(context).push(route);
        },
        tooltip: 'Добавить новое устройство',
        child: new Icon(Icons.add),
      ),
    );
  }

  Widget _getBody(BuildContext context) {
    return new FutureBuilder(
      future: Device.all,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return new Center(
            child: new CircularProgressIndicator(),
          );
        }
        List<Device> devices = snapshot.data;
        if (devices.isEmpty) {
          return new Center(
            child: const Text(
              'Список устройств пуст.\n\n'
                  'Вы можете добавить устройство\n'
                  'нажав на кнопку "+".',
              textAlign: TextAlign.center,
            ),
          );
        }
        return new RefreshIndicator(
          child: new ListView(
            children: devices.map((device) {
              return _buildDeviceListTile(context, device);
            }).toList(),
          ),
          onRefresh: () async {
            setState(() {});
          },
        );
      },
    );
  }

  Widget _buildDeviceListTile(BuildContext context, Device device) {
    return new Dismissible(
      key: new Key(new Random().nextInt(10000000).toString()),
      direction: DismissDirection.endToStart,
      child: new ListTile(
        title: new Text(device.name),
        trailing: new FutureBuilder(
          future: device.isOnline,
          builder: (context, snapshot) {
            var color = Colors.red;
            if (snapshot.hasData) {
              bool isOnline = snapshot.data;
              if (isOnline) {
                color = Colors.green;
              }
            }
            return new Icon(
              Icons.fiber_manual_record,
              color: color,
            );
          },
        ),
        subtitle: new Text(device.host),
        onTap: () {
          final route = new MaterialPageRoute(
            builder: (BuildContext context) => new DevicePage(device),
          );
          Navigator.of(context).push(route);
        },
      ),
      onDismissed: (DismissDirection _) async {
        await device.delete();
        setState(() {});
      },
      background: new Container(
        color: Colors.red,
        child: const ListTile(
          trailing: const Icon(
            Icons.delete,
            color: Colors.white,
            size: 36.0,
          ),
        ),
      ),
    );
  }

/*
  _showAddDeviceDialog(BuildContext context) async {
    final addDeviceDialog = new AlertDialog(
      title: const Text('Добавление устройства'),
      content: new Form(
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
          ],
        ),
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Отмена'),
          textColor: Colors.grey,
        ),
        new FlatButton(
          onPressed: () {
            final formState = _formKey.currentState;
            if (!formState.validate()) return;
            final name = _deviceNameController.text.trim();
            final host = _deviceHostController.text.trim();
            _deviceRepository.add(new Device(name: name, host: host));
            setState(() {
              Navigator.of(context).pop();
              formState.reset();
            });
          },
          child: const Text('Добавить'),
        )
      ],
    );
    await showDialog(
      child: addDeviceDialog,
      context: context,
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
    return null;
  }
  */
}

//class _AddDeviceDialog extends StatefulWidget {
//  @override
//  _AddDeviceDialogState createState() => new _AddDeviceDialogState();
//}
//
//class _AddDeviceDialogState extends State<_AddDeviceDialog> {
//  String _address = null;
//  bool _isDeviceFound = null;
//  String _name = null;
//
//  @override
//  Widget build(BuildContext context) {
//    if (_address == null) {
//      return _showDeviceAddressDialog(context);
//    }
//    if (_isDeviceFound == null) {
//      return _showSearchingDeviceDialog(context);
//    }
//    return null;
//  }
//
//  Widget _showDeviceAddressDialog(BuildContext context) {
//    return new AlertDialog(
//      title: const Text('Введите адрес устройства'),
//      actions: <Widget>[
//        new FlatButton(
//          onPressed: () {
//            Navigator.of(context).pop();
//          },
//          child: const Text('Отмена'),
//          textColor: Colors.grey,
//        ),
//        new FlatButton(
//          onPressed: () {
//            setState(() {
//              _address = "192.168.1.34";
//            });
//          },
//          child: const Text('Далее'),
//        )
//      ],
//    );
//  }
//
//  Widget _showSearchingDeviceDialog(BuildContext context) {
//    return new AlertDialog(
//      title: const Text('Поиск устройства...'),
//      content: new Container(
//        child: new CircularProgressIndicator(),
//      ),
//      actions: <Widget>[
//        new FlatButton(
//          onPressed: () {
//            Navigator.of(context).pop();
//          },
//          child: const Text('Отмена'),
//          textColor: Colors.grey,
//        ),
//      ],
//    );
//  }
//}

//String getFingerprint(String certificate) {
//  final re = new RegExp(
//    r'-----BEGIN CERTIFICATE-----|-----END CERTIFICATE-----|\s*',
//    multiLine: true,
//  );
//  certificate = certificate.replaceAll(re, '');
//  final hash = hex.encode(sha256.convert(base64.decode(certificate)).bytes);
//  return hash.replaceAllMapped(new RegExp(r'.{2}'), (match) {
//    return '${match.group(0)}:';
//  }).replaceFirst(new RegExp(':\$'), '');
//}
