import 'dart:math' as math;

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
      body: Center(
        child: Transform.rotate(
          angle: math.pi / 4,
          child: Transform.scale(
            scale: 2.0,
            child: Container(
              width: 128.0,
              height: 128.0,
              child: Stack(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(64.0),
                              ),
                              color: Colors.white,
                            ),
                            width: 64.0,
                            height: 64.0,
                          ),
                          GestureDetector(
                            onTap: _prevSlide,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(64.0),
                                ),
                                color: Colors.blue,
                              ),
                              width: 64.0,
                              height: 64.0,
                              child: Transform.rotate(
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                ),
                                angle: -math.pi / 4,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: _nextSlide,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(64.0),
                                ),
                                color: Colors.blue,
                              ),
                              width: 64.0,
                              height: 64.0,
                              child: Transform.rotate(
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                ),
                                angle: -math.pi / 4,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(64.0),
                              ),
                              color: Colors.white,
                            ),
                            width: 64.0,
                            height: 64.0,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.all(32.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(64.0),
                      ),
                      color: Colors.white,
                    ),
                    width: 64.0,
                    height: 64.0,
                  ),
                ],
              ),
            ),
          ),
        ),
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
