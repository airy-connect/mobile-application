import 'package:flutter/material.dart';
import 'package:airy_connect/plugin.dart';

class ScreenshotPlugin extends Plugin {
  ListTile buildListTile(BuildContext context) {
    return new ListTile(
      leading: new Icon(Icons.desktop_windows),
      title: const Text("Получение снимка экрана"),
      onTap: () {},
    );
  }
}
