import 'package:airy_connect/plugin.dart';
import 'package:flutter/material.dart';

class PresentationControlPlugin extends Plugin {
  ListTile buildListTile(BuildContext context) {
    return new ListTile(
      leading: new Icon(Icons.slideshow),
      title: const Text("Управление презентациями"),
      onTap: () {
        final route = new MaterialPageRoute(
          builder: (BuildContext context) =>
              new _PresentationControlPluginPage(),
        );
        Navigator.of(context).push(route);
      },
    );
  }
}

class _PresentationControlPluginPage extends StatefulWidget {
  @override
  _PresentationControlPluginPageState createState() =>
      new _PresentationControlPluginPageState();
}

class _PresentationControlPluginPageState
    extends State<_PresentationControlPluginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          child: Text('Управление презентациями'),
        ),
      ),
      body: new ListView(
        children: [
          new ListTile(
            leading: new Icon(Icons.arrow_forward),
            title: new Text('Следующий слайд'),
            onTap: () {},
          ),
          new ListTile(
            leading: new Icon(Icons.arrow_back),
            title: new Text('Предыдущий слайд'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
