import 'package:flutter/material.dart';
import 'package:hush/secret.dart';

class SecretPage extends StatefulWidget {
  final Secret secret;

  const SecretPage({ Key key, this.secret }): super(key: key);

  @override
  _SecretPageState createState() => _SecretPageState();
}

class _SecretPageState extends State<SecretPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameTextController = TextEditingController();
  final _usernameTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _notesTextController = TextEditingController();

  @override
  void initState() {
    if (widget.secret != null) {
      _nameTextController.text = widget.secret.name ?? '';
      _usernameTextController.text = widget.secret.properties['username'] ?? '';
      _passwordTextController.text = widget.secret.properties['password'] ?? '';
      _notesTextController.text = widget.secret.properties['notes'] ?? '';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hush Secret'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context, { 'delete': true } );
            },
            icon: Icon(Icons.delete),
          )
        ],
      ),
      body: ListView(
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextFormField(
                    controller: _nameTextController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name',
                      hintText: 'Enter name of secret',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Can\'t be blank';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _usernameTextController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Username',
                      hintText: 'Enter username',
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _passwordTextController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Enter password',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Can\'t be blank';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _notesTextController,
                    maxLines: 8,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Notes',
                      hintText: 'Additional notes',
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        Secret secret = Secret(name: _nameTextController.text);
                        secret.properties['username'] = _usernameTextController.text;
                        secret.properties['password'] = _passwordTextController.text;
                        secret.properties['notes'] = _notesTextController.text;
                        Navigator.pop(context, { 'secret': secret, 'save': true } );
                      }
                    },
                    child: Text(
                        'Ok'
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
