import 'package:airy_connect/models/device.dart';
import 'package:airy_connect/plugin.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RemoteInputPlugin extends Plugin {
  ListTile buildListTile(BuildContext context, Device device) {
    return new ListTile(
      leading: new Icon(Icons.keyboard),
      title: const Text("Удаленный ввод"),
      onTap: () {
        final route = new MaterialPageRoute(
          builder: (BuildContext context) => new _RemoteInputPluginPage(device),
        );
        Navigator.of(context).push(route);
      },
    );
  }
}

class _RemoteInputPluginPage extends StatefulWidget {
  final Device device;

  _RemoteInputPluginPage(this.device);

  @override
  _RemoteInputPluginPageState createState() =>
      new _RemoteInputPluginPageState();
}

class _RemoteInputPluginPageState extends State<_RemoteInputPluginPage> {
  final _textFieldFocusNode = new FocusNode();
  final _textFieldController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final text = '- Передвигайте палец по экрану для передвижения курсора.\n\n'
        '- Нажмите на экран одним/двумя/тремя пальцами '
        'для клика левой/правой/средней кнопкной мыши соответственно.\n\n'
        '- Используйте долгое нажатия для drag-and-drop.';
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Удаленный ввод'),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.keyboard),
            onPressed: () {
              print(_textFieldFocusNode.hasFocus);
              if (_textFieldFocusNode.hasFocus) {
                FocusScope.of(context).requestFocus(new FocusNode());
              } else {
                FocusScope.of(context).requestFocus(_textFieldFocusNode);
              }
            },
          ),
        ],
      ),
      body: RawGestureDetector(
        gestures: <Type, GestureRecognizerFactory>{
          TapGestureRecognizer:
              GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
            () => TapGestureRecognizer(),
            (TapGestureRecognizer instance) {
              instance.onTap = _onTap;
            },
          ),
          DoubleTapGestureRecognizer:
              GestureRecognizerFactoryWithHandlers<DoubleTapGestureRecognizer>(
            () => DoubleTapGestureRecognizer(),
            (DoubleTapGestureRecognizer instance) {
              instance.onDoubleTap = _onDoubleTap;
            },
          ),
          PanGestureRecognizer:
              GestureRecognizerFactoryWithHandlers<PanGestureRecognizer>(
            () => PanGestureRecognizer(),
            (PanGestureRecognizer instance) {
              instance
                ..onStart = _onDragStart
                ..onUpdate = _onDragUpdate
                ..onEnd = _onDragEnd;
            },
          ),
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(text),
                SizedBox(
                  height: 0.0,
                  width: 0.0,
                  child: TextField(
                    focusNode: _textFieldFocusNode,
                    controller: _textFieldController,
                    autocorrect: false,
                    onChanged: (value) {
                      _typeString(value);
                      _textFieldController.clear();
                    },
                  ),
                ),
                Hi
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTap() async {
    final device = widget.device;
    final host = device.host;
    final url = Uri.parse('https://$host:8420/'
        'remoteInputPlugin/'
        'click?'
        'button=left');
    final httpClient = widget.device.httpClient;
    final request = await httpClient.getUrl(url);
    await request.close();
  }

  void _onDoubleTap() async {
    final device = widget.device;
    final host = device.host;
    final url = Uri.parse('https://$host:8420/'
        'remoteInputPlugin/'
        'click?'
        'button=right');
    final httpClient = widget.device.httpClient;
    final request = await httpClient.getUrl(url);
    await request.close();
  }

  DateTime lastRequestAt = DateTime.now();
  Offset _offset = new Offset(0.0, 0.0);

  void _onDragStart(DragStartDetails details) {
    _offset = new Offset(0.0, 0.0);
  }

  void _onDragUpdate(DragUpdateDetails details) async {
    _offset += details.delta;
    final now = DateTime.now();
    if (now.difference(lastRequestAt).inMilliseconds < 100) return;
    lastRequestAt = now;
    final device = widget.device;
    final host = device.host;
    final deltaX = _offset.dx.toString();
    final deltaY = _offset.dy.toString();
    _offset = new Offset(0.0, 0.0);
    final url = Uri.parse('https://$host:8420/'
        'remoteInputPlugin/'
        'cursorMove?'
        'deltaX=$deltaX&'
        'deltaY=$deltaY');

    final httpClient = widget.device.httpClient;
    final request = await httpClient.getUrl(url);
    await request.close();
  }

  void _onDragEnd(DragEndDetails details) {
    _offset = new Offset(0.0, 0.0);
  }

  void _typeString(String string) async {
    final device = widget.device;
    final host = device.host;
    final url = Uri.parse('https://$host:8420/'
        'remoteInputPlugin/'
        'typeString?'
        'string=$string');
    final httpClient = widget.device.httpClient;
    final request = await httpClient.getUrl(url);
    await request.close();
  }
}
