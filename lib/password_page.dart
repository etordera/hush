import 'package:flutter/material.dart';

class PasswordPage extends StatefulWidget {
  PasswordPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PasswordPageState createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Enter your main password:',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _textController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: 'Enter your main password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Can\'t be blank';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    debugPrint('password: ${_textController.text}');
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
    );
  }
}
