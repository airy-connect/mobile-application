import 'package:airy_connect/models/device.dart';
import 'package:flutter/material.dart';

abstract class Plugin {
  ListTile buildListTile(BuildContext context, Device device) {
    return ListTile(
      title: Text('Default Plugin Name'),
    );
  }
}
