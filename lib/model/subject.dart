import 'package:flutter/material.dart';

class SubjectItem extends StatelessWidget {
  String _subjectName;
  //String _subjectDepartment;
  //String _subjectSchool;
  String _dateCreated;
  int _id;


  SubjectItem(this._subjectName, this._dateCreated);

  SubjectItem.map(dynamic obj) {
    this._subjectName = obj["subjectName"];
    this._dateCreated = obj["dateCreated"];
    this._id = obj["id"];
  }

  String get subjectName => _subjectName;
  String get dateCreated => _dateCreated;
  int get id => _id;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["subjectName"] = _subjectName;
    map["dateCreated"] = _dateCreated;

    if (_id != null) {
      map["id"] = _id;
    }

    return map;
  }

  SubjectItem.fromMap(Map<String, dynamic> map) {
    this._subjectName = map["subjectName"];
    this._dateCreated = map["dateCreated"];
    this._id = map["id"];

  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.all(8.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(_subjectName,
                style: new TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.9
                ),),

              new Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: new Text("Created on: $_dateCreated",
                  style: new TextStyle(
                      color:  Colors.white70,
                      fontSize: 12.5,
                      fontStyle:  FontStyle.italic
                  ),),
              )
            ],
          ),
        ],
      ),
    );
  }
}
