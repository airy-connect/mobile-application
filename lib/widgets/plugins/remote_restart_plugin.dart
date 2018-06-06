import 'package:flutter/material.dart';
import 'package:airy_connect/plugin.dart';

class RemoteRestartPlugin extends Plugin {
  ListTile buildListTile(BuildContext context) {
    return new ListTile(
      leading: new Icon(Icons.refresh),
      title: const Text("Удаленная перезагрузка"),
      onTap: () {},
    );
  }
}
