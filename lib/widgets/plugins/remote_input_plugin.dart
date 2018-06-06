import 'package:airy_connect/models/device.dart';
import 'package:airy_connect/plugin.dart';
import 'package:flutter/material.dart';

class RemoteInputPlugin extends Plugin {
  ListTile buildListTile(BuildContext context, Device device) {
    return new ListTile(
      leading: new Icon(Icons.keyboard),
      title: const Text("Удаленный ввод"),
      onTap: () {
        final route = new MaterialPageRoute(
          builder: (BuildContext context) => new _RemoteInputPluginPage(),
        );
        Navigator.of(context).push(route);
      },
    );
  }
}

class _RemoteInputPluginPage extends StatefulWidget {
  @override
  _RemoteInputPluginPageState createState() =>
      new _RemoteInputPluginPageState();
}

class _RemoteInputPluginPageState extends State<_RemoteInputPluginPage> {
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
              if (_textFieldFocusNode.hasFocus) {
                FocusScope.of(context).requestFocus(new FocusNode());
              } else {
                FocusScope.of(context).requestFocus(_textFieldFocusNode);
              }
            },
          ),
        ],
      ),
      body: new Container(
        padding: const EdgeInsets.all(16.0),
        child: new Center(
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Text(text),
              new SizedBox(
                height: 0.0,
                width: 0.0,
                child: new TextField(
                  focusNode: _textFieldFocusNode,
                  controller: _textFieldController,
                  autocorrect: false,
                  onChanged: (value) {
                    _textFieldController.clear();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final _textFieldFocusNode = new FocusNode();
  final _textFieldController = new TextEditingController();
}
