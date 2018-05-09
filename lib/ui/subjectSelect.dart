import 'package:flutter/material.dart';
import 'package:gooberu/ui/subjectselect_screen.dart';

class SubjectSelect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Goober Subject"),
        backgroundColor: Colors.black54,
      ),
      body: new SubjectSelectScreen(),
    );
  }
}
