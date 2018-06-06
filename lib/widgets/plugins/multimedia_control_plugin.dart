import 'package:flutter/material.dart';
import 'package:airy_connect/plugin.dart';

class MultimediaControlPlugin extends Plugin {
  ListTile buildListTile(BuildContext context) {
    return new ListTile(
      leading: new Icon(Icons.play_arrow),
      title: const Text("Управление мультимедиа"),
      onTap: () {
        final route = new MaterialPageRoute(
          builder: (BuildContext context) => new _MultimediaControlPluginPage(),
        );
        Navigator.of(context).push(route);
      },
    );
  }
}

class _MultimediaControlPluginPage extends StatefulWidget {
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
            onTap: () {},
          ),
          new ListTile(
            leading: new Icon(Icons.pause),
            title: new Text('Воспроизвести/пауза'),
            onTap: () {},
          ),
          new ListTile(
            leading: new Icon(Icons.fast_forward),
            title: new Text('Вперед'),
            onTap: () {},
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
            onTap: () {},
          ),
          new ListTile(
            leading: new Icon(Icons.volume_down),
            title: new Text('Убавить'),
            onTap: () {},
          ),
          new ListTile(
            leading: new Icon(Icons.volume_off),
            title: new Text('Включить/отключить'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
