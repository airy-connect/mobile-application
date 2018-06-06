import 'package:airy_connect/models/device.dart';
import 'package:airy_connect/plugin.dart';
import 'package:flutter/material.dart';

class RemoteShutdownPlugin extends Plugin {
  ListTile buildListTile(BuildContext context, Device device) {
    return new ListTile(
      leading: new Icon(Icons.power_settings_new),
      title: const Text("Удаленное выключение"),
      onTap: () {},
    );
  }
}
