import 'package:flutter/material.dart';
import 'package:airy_connect/plugin.dart';

class RemoteShutdownPlugin extends Plugin {
  ListTile buildListTile(BuildContext context) {
    return new ListTile(
      leading: new Icon(Icons.power_settings_new),
      title: const Text("Удаленное выключение"),
      onTap: () {},
    );
  }
}
