import 'package:flutter/material.dart';
import 'package:gooberu/model/subject.dart';
import 'package:gooberu/util/database_client.dart';
import 'package:gooberu/util/date_formatter.dart';
import 'package:gooberu/ui/requestProvider.dart';

class SubjectSelectScreen extends StatefulWidget {
  SubjectSelectScreen({Key key, this.title}) : super(key: key);
  static const String routeName = "/SubjectSelectScreen";
  final String title;

  @override
  _SubjectSelectScreenState createState() => new _SubjectSelectScreenState();
}

class _SubjectSelectScreenState extends State<SubjectSelectScreen> {
  final TextEditingController _textEditingController = new TextEditingController();
  var db = new DatabaseHelper();
  final List<SubjectItem> _itemList = <SubjectItem>[];

  @override
  void initState() {
    super.initState();
    _readSubjectList();
  }

  void _handleSubmitted(String text) async {
    _textEditingController.clear();
    SubjectItem subjectItem = new SubjectItem(text, dateFormatted());
    int savedItemId = await db.saveSubjectItem(subjectItem);
    SubjectItem addedItem = await db.getSubjectItem(savedItemId);
    setState(() {
      _itemList.insert(0, addedItem);
    });
    print("Subject saved id: $savedItemId");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black87,
      body: new Column(
        children: <Widget>[
          new Flexible(
            child: new ListView.builder(
                padding: new EdgeInsets.all(8.0),
                reverse: false,
                itemCount: _itemList.length,
                itemBuilder: (_, int index) {
                  return new Card(
                    color: Colors.white10,
                    child: new ListTile(
                      title: _itemList[index],
                      onTap: _onSubjectPress,
                      onLongPress: () => _updateItem(_itemList[index], index),
                      trailing: new Listener(
                        key: new Key(_itemList[index].subjectName),
                        child:  new Icon(Icons.remove_circle,
                          color: Colors.redAccent,),
                        onPointerDown: (pointerEvent) =>
                            _deleteSubject(_itemList[index].id, index),
                      ),
                    ),
                  );
                }),
          ),

          new Divider(
            height: 1.0,
          )
        ],
      ),
      floatingActionButton: new FloatingActionButton(
          tooltip: "Add Item",
          backgroundColor: Colors.redAccent,
          child: new ListTile(
            title: new Icon(Icons.add),
          ),
          onPressed: _showFormDialog
      ),
    );
  }

  void _showFormDialog() {
    var alert = new AlertDialog(
      content: new Row(
        children: <Widget>[
          new Expanded(
              child: new TextField(
                controller: _textEditingController,
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: "Subject",
                    hintText: "Bohr Model",
                    icon: new Icon(Icons.note_add)
                ),
              ))
        ],
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              _handleSubmitted(_textEditingController.text);
              _textEditingController.clear();
              Navigator.pop(context);
            },
            child: Text("Save")),
        new FlatButton(onPressed: () => Navigator.pop(context),
            child: Text("Cancel"))
      ],
    );
    showDialog(context: context,
        builder:(_) {
          return alert;
        });
  }

  _readSubjectList() async {
    List items = await db.getSubjectItems();
    items.forEach((item) {
      // NoDoItem noDoItem = NoDoItem.fromMap(item);
      setState(() {
        _itemList.add(SubjectItem.map(item));
      });
      // print("Db items: ${noDoItem.itemName}");
    });
  }

  _deleteSubject(int id, int index) async {
    debugPrint("Deleted Subject!");
    await db.deleteSubjectItem(id);
    setState(() {
      _itemList.removeAt(index);
    });
  }

  _updateItem(SubjectItem item, int index) {
    var alert = new AlertDialog(
      title: new Text("Update Subject"),
      content: new Row(
        children: <Widget>[
          new Expanded(
              child: new TextField(
                controller: _textEditingController,
                autofocus: true,
                decoration: new InputDecoration(
                    labelText:  "Subject",
                    hintText: "eg.Basic Model of the Atom",
                    icon: new Icon(Icons.update)),
              ))
        ],
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () async {
              SubjectItem newItemUpdated = SubjectItem.fromMap(
                  {"subjectName": _textEditingController.text,
                    "dateCreated" : dateFormatted(),
                    "id" : item.id
                  });
              _handleSubmittedUpdate(index, item);//redrawing the screen
              await db.updateSubjectItem(newItemUpdated); //updating the item
              setState(() {
                _readSubjectList(); // redrawing the screen with all items saved in the db
              });
              Navigator.pop(context);
            },
            child: new Text("Update")),
        new FlatButton(onPressed: () => Navigator.pop(context),
            child: new Text("Cancel"))
      ],
    );
    showDialog(context:
    context ,builder: (_) {
      return alert;
    });
  }

  void _handleSubmittedUpdate(int index, SubjectItem item) {
    setState(() {
      _itemList.removeWhere((element) {
        _itemList[index].subjectName == item.subjectName;
      });
    });
  }

  void _onSubjectPress() {
    Navigator.pushNamed(context, RequestProvider.routeName);
  }
}
