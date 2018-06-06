import 'package:airy_connect/models/device.dart';
import 'package:airy_connect/plugin.dart';
import 'package:flutter/material.dart';

class MultimediaControlPlugin extends Plugin {
  ListTile buildListTile(BuildContext context, Device device) {
    return new ListTile(
      leading: new Icon(Icons.play_arrow),
      title: const Text("Управление мультимедиа"),
      onTap: () {
        final route = new MaterialPageRoute(
          builder: (BuildContext context) {
            return new _MultimediaControlPluginPage(
              device: device,
            );
          },
        );
        Navigator.of(context).push(route);
      },
    );
  }
}

class _MultimediaControlPluginPage extends StatefulWidget {
  _MultimediaControlPluginPage({
    @required this.device,
  });

  final Device device;

  @override
  _MultimediaControlPluginPageState createState() =>
      new _MultimediaControlPluginPageState();
}

class _MultimediaControlPluginPageState
    extends State<_MultimediaControlPluginPage> {
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextStyle headerStyle =
        themeData.textTheme.body2.copyWith(color: themeData.accentColor);
    return new Scaffold(
      appBar: new AppBar(
        title: const Text(
          'Управление мультимедиа',
          style: const TextStyle(fontSize: 18.0),
        ),
//        elevation: 0.0,
      ),
      body: new ListView(
        children: [
          new MergeSemantics(
            child: new Container(
              height: 48.0,
              padding: const EdgeInsetsDirectional.only(start: 16.0),
              alignment: AlignmentDirectional.centerStart,
              child: new SafeArea(
                top: false,
                bottom: false,
                child: new Semantics(
                  child: new Text('Медиа плеер', style: headerStyle),
                ),
              ),
            ),
          ),
          new ListTile(
            leading: new Icon(Icons.fast_rewind),
            title: new Text('Назад'),
            onTap: _prev,
          ),
          new ListTile(
            leading: new Icon(Icons.pause),
            title: new Text('Воспроизвести/пауза'),
            onTap: _playOrPause,
          ),
          new ListTile(
            leading: new Icon(Icons.fast_forward),
            title: new Text('Вперед'),
            onTap: _next,
          ),
          new MergeSemantics(
            child: new Container(
              height: 48.0,
              padding: const EdgeInsetsDirectional.only(start: 16.0),
              alignment: AlignmentDirectional.centerStart,
              child: new SafeArea(
                top: false,
                bottom: false,
                child: new Semantics(
                  child: new Text('Звук', style: headerStyle),
                ),
              ),
            ),
          ),
          new ListTile(
            leading: new Icon(Icons.volume_up),
            title: new Text('Прибавить'),
            onTap: _up,
          ),
          new ListTile(
            leading: new Icon(Icons.volume_down),
            title: new Text('Убавить'),
            onTap: _down,
          ),
          new ListTile(
            leading: new Icon(Icons.volume_off),
            title: new Text('Включить/отключить'),
            onTap: _muteOrUnmute,
          ),
        ],
      ),
    );
  }

  _prev() async {
    final device = widget.device;
    final host = device.host;
    final url = Uri.parse('https://$host:8420/multimediaControlPlugin/prev');
    final httpClient = widget.device.httpClient;
    final request = await httpClient.getUrl(url);
    await request.close();
  }

  _playOrPause() async {
    final device = widget.device;
    final host = device.host;
    final url =
        Uri.parse('https://$host:8420/multimediaControlPlugin/playOrPause');
    final httpClient = widget.device.httpClient;
    final request = await httpClient.getUrl(url);
    await request.close();
  }

  _next() async {
    final device = widget.device;
    final host = device.host;
    final url = Uri.parse('https://$host:8420/multimediaControlPlugin/next');
    final httpClient = widget.device.httpClient;
    final request = await httpClient.getUrl(url);
    await request.close();
  }

  _up() async {
    final device = widget.device;
    final host = device.host;
    final url = Uri.parse('https://$host:8420/multimediaControlPlugin/up');
    final httpClient = widget.device.httpClient;
    final request = await httpClient.getUrl(url);
    await request.close();
  }

  _down() async {
    final device = widget.device;
    final host = device.host;
    final url = Uri.parse('https://$host:8420/multimediaControlPlugin/down');
    final httpClient = widget.device.httpClient;
    final request = await httpClient.getUrl(url);
    await request.close();
  }

  _muteOrUnmute() async {
    final device = widget.device;
    final host = device.host;
    final url =
        Uri.parse('https://$host:8420/multimediaControlPlugin/muteOrUnmute');
    final httpClient = widget.device.httpClient;
    final request = await httpClient.getUrl(url);
    await request.close();
  }
}
