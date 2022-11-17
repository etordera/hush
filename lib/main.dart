import 'package:flutter/material.dart';
import 'package:hush/create_password_page.dart';
import 'package:hush/listing_page.dart';
import 'package:hush/password_page.dart';

void main() {
  runApp(HushApp());
}

class HushApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hush',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ListingPage(),
    );
  }
}
