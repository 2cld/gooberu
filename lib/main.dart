import 'package:flutter/material.dart';
import 'package:gooberu/ui/subjectSelect.dart';
import 'package:gooberu/ui/subjectselect_screen.dart';
import 'package:gooberu/ui/requestProvider.dart';
import 'package:gooberu/ui/requestProvider_screen.dart';

void main() => runApp(new GooberUApp());

class GooberUApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var routes = <String, WidgetBuilder> {
      SubjectSelectScreen.routeName: (BuildContext context) => new SubjectSelectScreen(title: "SubjectSelectScreen"),
      RequestProviderScreen.routeName: (BuildContext context) => new RequestProviderScreen(title: "RequestProviderScreen"),
      RequestProvider.routeName: (BuildContext context) => new RequestProvider(title: "RequestProvider"),

    };
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GooberU',
      home: new SubjectSelect(),
      routes: routes,
    );
  }
}