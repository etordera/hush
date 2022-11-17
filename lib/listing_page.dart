import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hush/secret_page.dart';
import 'package:hush/secrets_list.dart';
import 'package:path_provider/path_provider.dart';

class ListingPage extends StatefulWidget {
  @override
  _ListingPageState createState() => _ListingPageState();
}

class _ListingPageState extends State<ListingPage> {
  Future<SecretsList> _secretsList;

  Future<String> _secretsPath() async {
    Directory docsDir = await getApplicationDocumentsDirectory();
    return '${docsDir.path}/secrets.hush';
  }

  Future<SecretsList> loadSecretsList() async {
    SecretsList list = SecretsList(path: await _secretsPath(), password: 'a password');
    list.load();
    return list;
  }

  @override
  void initState() {
    _secretsList = loadSecretsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _secretsList,
      builder: (context, snapshot) {
        Widget body;
        if (snapshot.hasData) {
          SecretsList data = snapshot.data;
          body = ListView.builder(
            itemCount: data.secrets.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () async {
                  final secretData = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SecretPage(secret: data.secrets[index]),
                      )
                  );
                  if (secretData != null) {
                    if (secretData.containsKey('save')) {
                      data.secrets[index] = secretData['secret'];
                    } else if (secretData.containsKey('delete')) {
                      data.secrets.removeAt(index);
                    }
                    data.save();
                    setState(() {
                      _secretsList = Future.value(data);
                    });
                  }
                },
                child: Container(
                  height: 50,
                  child: Center(
                    child: Text('${data.secrets[index].name}'),
                  ),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          body = Text('Error: ${snapshot.error}');
        } else {
          body = Text('Loading...');
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Hush'),
          ),
          body: body,
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: Colors.blue,
            onPressed: () async {
              final secretData = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SecretPage(),
                )
              );

              if (secretData != null && secretData.containsKey('save')) {
                SecretsList secretsList = await loadSecretsList();
                secretsList.secrets.add(secretData['secret']);
                secretsList.save();
                setState(() {
                  _secretsList = Future.value(secretsList);
                });
              }
            },
          ),
        );
      },
    );
  }
}
