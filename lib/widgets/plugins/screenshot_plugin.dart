import 'package:airy_connect/models/device.dart';
import 'package:airy_connect/plugin.dart';
import 'package:flutter/material.dart';

class ScreenshotPlugin extends Plugin {
  ListTile buildListTile(BuildContext context, Device device) {
    return new ListTile(
      leading: new Icon(Icons.desktop_windows),
      title: const Text("Получение снимка экрана"),
      onTap: () {
        final route = new MaterialPageRoute(
          builder: (BuildContext context) {
            return new _ScreenshotPluginPage();
          },
        );
        Navigator.of(context).push(route);
      },
    );
  }
}

class _ScreenshotPluginPage extends StatefulWidget {
  @override
  _ScreenshotPluginPageState createState() => new _ScreenshotPluginPageState();
}

class _ScreenshotPluginPageState extends State<_ScreenshotPluginPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text(
          'Скриншот экрана',
          style: const TextStyle(fontSize: 18.0),
        ),
//        elevation: 0.0,
      ),
      body: new Center(
        child: new Image.network('https://i.imgur.com/YhQnG48.jpg'),
      ),
    );
  }
}
