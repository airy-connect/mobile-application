import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:airy_connect/models/device.dart';
import 'package:airy_connect/plugin.dart';
import 'package:flutter/material.dart';

class ScreenshotPlugin extends Plugin {
  ListTile buildListTile(BuildContext context, Device device) {
    return new ListTile(
      leading: new Icon(Icons.desktop_windows),
      title: const Text("Получение снимка экрана"),
      onTap: () {
        final route = new MaterialPageRoute(
          builder: (BuildContext context) {
            return new _ScreenshotPluginPage(device);
          },
        );
        Navigator.of(context).push(route);
      },
    );
  }
}

class _ScreenshotPluginPage extends StatefulWidget {
  final Device device;

  _ScreenshotPluginPage(this.device);

  @override
  _ScreenshotPluginPageState createState() => new _ScreenshotPluginPageState();
}

class _ScreenshotPluginPageState extends State<_ScreenshotPluginPage> {
  String get _pluginPath {
    final host = widget.device.host;
    return 'https://$host:8420/screenshotPlugin/';
  }

  Future<Uint8List> _getScreenshot() async {
    final url = Uri.parse('$_pluginPath/get');
    final httpClient = widget.device.httpClient;
    final request = await httpClient.getUrl(url);
    final response = await request.close();
    final encodedBase64 = await response.transform(utf8.decoder).join();
    return base64.decode(encodedBase64);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text(
          'Скриншот экрана',
          style: const TextStyle(fontSize: 18.0),
        ),
//        elevation: 0.0,
      ),
      body: new Center(
        child: FutureBuilder(
          future: _getScreenshot(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final bytes = snapshot.data;
              return SizedBox.expand(
                child: ImageViewer(
                  image: Image.memory(
                    bytes,
//                    fit: BoxFit.cover,
                  ),
                ),
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}

class ImageViewer extends StatefulWidget {
  const ImageViewer({Key key, this.image}) : super(key: key);

  final Image image;

  @override
  _ImageViewerState createState() => new _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _flingAnimation;
  Offset _offset = Offset.zero;
  double _scale = 1.0;
  Offset _normalizedOffset;
  double _previousScale;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(vsync: this)
      ..addListener(_handleFlingAnimation);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // The maximum offset value is 0,0. If the size of this renderer's box is w,h
  // then the minimum offset value is w - _scale * w, h - _scale * h.
  Offset _clampOffset(Offset offset) {
    final Size size = context.size;
    final Offset minOffset =
        new Offset(size.width, size.height) * (1.0 - _scale);
    return new Offset(
        offset.dx.clamp(minOffset.dx, 0.0), offset.dy.clamp(minOffset.dy, 0.0));
  }

  void _handleFlingAnimation() {
    setState(() {
      _offset = _flingAnimation.value;
    });
  }

  void _handleOnScaleStart(ScaleStartDetails details) {
    setState(() {
      _previousScale = _scale;
      _normalizedOffset = (details.focalPoint - _offset) / _scale;
      // The fling animation stops if an input gesture starts.
      _controller.stop();
    });
  }

  void _handleOnScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _scale = (_previousScale * details.scale).clamp(1.0, 4.0);
      // Ensure that image location under the focal point stays in the same place despite scaling.
      _offset = _clampOffset(details.focalPoint - _normalizedOffset * _scale);
    });
  }

  void _handleOnScaleEnd(ScaleEndDetails details) {
    final double magnitude = details.velocity.pixelsPerSecond.distance;
    if (magnitude < 800) return;
    final Offset direction = details.velocity.pixelsPerSecond / magnitude;
    final double distance = (Offset.zero & context.size).shortestSide;
    _flingAnimation = new Tween<Offset>(
            begin: _offset, end: _clampOffset(_offset + direction * distance))
        .animate(_controller);
    _controller
      ..value = 0.0
      ..fling(velocity: magnitude / 1000.0);
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onScaleStart: _handleOnScaleStart,
      onScaleUpdate: _handleOnScaleUpdate,
      onScaleEnd: _handleOnScaleEnd,
      child: new ClipRect(
        child: new Transform(
          transform: new Matrix4.identity()
            ..translate(_offset.dx, _offset.dy)
            ..scale(_scale),
          child: widget.image,
        ),
      ),
    );
  }
}
