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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final route = new MaterialPageRoute(
            builder: (BuildContext context) {
              return new AddDevicePage();
            },
          );
          Navigator.of(context).push(route);
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
          return Center(
            child: Text(
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
        onTap: () async {
          try {
            final authorizationStatus = await device.getAuthorizationStatus();
            if (authorizationStatus != 'AUTHORIZED') {
              await device.delete();
              setState(() {});
              return showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Ошибка подключения'),
                    content: Text(
                      'Удаленное устройство не разрешило подключение.',
                    ),
                  );
                },
              );
            }
          } catch (_) {
            return showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Ошибка подключения'),
                  content: Text('Невозможно подключиться к устройству.'),
                );
              },
            );
          }
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
}
