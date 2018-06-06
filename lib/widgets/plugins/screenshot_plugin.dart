import 'package:airy_connect/models/device.dart';
import 'package:airy_connect/plugin.dart';
import 'package:flutter/material.dart';

class ScreenshotPlugin extends Plugin {
  ListTile buildListTile(BuildContext context, Device device) {
    return new ListTile(
      leading: new Icon(Icons.desktop_windows),
      title: const Text("Получение снимка экрана"),
      onTap: () {},
    );
  }
}
