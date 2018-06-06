import 'package:airy_connect/models/device.dart';
import 'package:airy_connect/plugin.dart';
import 'package:flutter/material.dart';

class PresentationControlPlugin extends Plugin {
  ListTile buildListTile(BuildContext context, Device device) {
    return new ListTile(
      leading: new Icon(Icons.slideshow),
      title: const Text("Управление презентациями"),
      onTap: () {
        final route = new MaterialPageRoute(builder: (context) {
          return new _PresentationControlPluginPage(
            device: device,
          );
        });
        Navigator.of(context).push(route);
      },
    );
  }
}

class _PresentationControlPluginPage extends StatefulWidget {
  _PresentationControlPluginPage({
    @required this.device,
  });

  final Device device;

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
            onTap: _nextSlide,
          ),
          new ListTile(
            leading: new Icon(Icons.arrow_back),
            title: new Text('Предыдущий слайд'),
            onTap: _prevSlide,
          ),
        ],
      ),
    );
  }

  void _nextSlide() async {
    final device = widget.device;
    final host = device.host;
    final url = Uri.parse('https://$host:8420/presentationPlugin/nextSlide');
    final httpClient = widget.device.httpClient;
    final request = await httpClient.getUrl(url);
    await request.close();
  }

  void _prevSlide() async {
    final device = widget.device;
    final host = device.host;
    final url = Uri.parse('https://$host:8420/presentationPlugin/prevSlide');
    final httpClient = widget.device.httpClient;
    final request = await httpClient.getUrl(url);
    await request.close();
  }
}
