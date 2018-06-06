import 'package:airy_connect/models/device.dart';
import 'package:airy_connect/plugin.dart';
import 'package:airy_connect/widgets/plugins/multimedia_control_plugin.dart';
import 'package:airy_connect/widgets/plugins/presentation_control_plugin.dart';
import 'package:airy_connect/widgets/plugins/remote_input_plugin.dart';
import 'package:airy_connect/widgets/plugins/remote_restart_plugin.dart';
import 'package:airy_connect/widgets/plugins/remote_shutdown_plugin.dart';
import 'package:airy_connect/widgets/plugins/screenshot_plugin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DevicePage extends StatefulWidget {
  DevicePage(this.device, {Key key}) : super(key: key);

  final Device device;

  @override
  _DevicePageState createState() => new _DevicePageState();
}

final plugins = [];

class _DevicePageState extends State<DevicePage> {
  final List<Plugin> _plugins = [];

  @override
  void initState() {
    super.initState();
    _plugins.addAll([
      new RemoteInputPlugin(),
      new MultimediaControlPlugin(),
      new PresentationControlPlugin(),
      new ScreenshotPlugin(),
      new RemoteShutdownPlugin(),
      new RemoteRestartPlugin(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.device.name),
      ),
      body: new ListView(
        children: _plugins.map((plugin) {
          return plugin.buildListTile(context);
        }).toList(),
      ),
    );
  }
}
