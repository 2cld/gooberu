import 'package:flutter/material.dart';
import 'package:gooberu/ui/requestProvider_screen.dart';

class RequestProvider extends StatelessWidget {
  RequestProvider({Key key, this.title}) : super(key: key);
  static const String routeName = "/RequestProvider";
  final String title;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Goober Alert Status"),
        backgroundColor: Colors.black54,
      ),
      body: new RequestProviderScreen(),
    );
  }
}
