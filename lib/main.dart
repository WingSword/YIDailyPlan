import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Welcome to Flutter',
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('YIDailyPlan'),
        ),
        body: new Center(
          child: new Text(
              '1\n'
              '2'
              '3\n'
              '4'),
        ),
      ),
    );
  }
}