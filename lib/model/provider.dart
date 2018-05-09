import 'package:flutter/material.dart';

class ProviderItem extends StatelessWidget {
  String _providerName;
  //String _subjectDepartment;
  //String _subjectSchool;
  String _dateCreated;
  int _id;


  ProviderItem(this._providerName, this._dateCreated);

  ProviderItem.map(dynamic obj) {
    this._providerName = obj["providerName"];
    this._dateCreated = obj["dateCreated"];
    this._id = obj["id"];
  }

  String get providerName => _providerName;
  String get dateCreated => _dateCreated;
  int get id => _id;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["providerName"] = _providerName;
    map["dateCreated"] = _dateCreated;

    if (_id != null) {
      map["id"] = _id;
    }

    return map;
  }

  ProviderItem.fromMap(Map<String, dynamic> map) {
    this._providerName = map["providerName"];
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
              new Text(_providerName,
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
