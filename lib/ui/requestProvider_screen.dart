import 'package:flutter/material.dart';
import 'package:gooberu/model/provider.dart';
import 'package:gooberu/util/database_client.dart';
import 'package:gooberu/util/date_formatter.dart';

class RequestProviderScreen extends StatefulWidget {
  RequestProviderScreen({Key key, this.title}) : super(key: key);
  static const String routeName = "/RequestProviderScreen";
  final String title;

  @override
  _RequestProviderScreenState createState() => new _RequestProviderScreenState();
}

class _RequestProviderScreenState extends State<RequestProviderScreen> {
  final TextEditingController _textEditingController = new TextEditingController();
  var db = new DatabaseHelper();
  final List<ProviderItem> _itemList = <ProviderItem>[];

  @override
  void initState() {
    super.initState();
    _readProviderList();
  }

  void _handleSubmitted(String text) async {
    _textEditingController.clear();
    ProviderItem sProviderItem = new ProviderItem(text, dateFormatted());
    int savedItemId = await db.saveProviderItem(sProviderItem);
    ProviderItem addedItem = await db.getProviderItem(savedItemId);
    setState(() {
      _itemList.insert(0, addedItem);
    });
    print("Provider saved id: $savedItemId");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black87,
      body: new Column(
        children: <Widget>[
          new Image.asset("assets/map-losaltos.png"),
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
                      onTap: _showFormDialog,
                      onLongPress: () => _updateItem(_itemList[index], index),
                      trailing: new Listener(
                        key: new Key(_itemList[index].providerName),
                        child:  new Icon(Icons.remove_circle,
                          color: Colors.redAccent,),
                        onPointerDown: (pointerEvent) =>
                            _deleteItem(_itemList[index].id, index),
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
                    labelText: "Provider",
                    hintText: "You Name",
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

  _readProviderList() async {
    List items = await db.getProviderItems();
    items.forEach((item) {
      // NoDoItem noDoItem = NoDoItem.fromMap(item);
      setState(() {
        _itemList.add(ProviderItem.map(item));
      });
      // print("Db items: ${noDoItem.itemName}");
    });
  }

  _deleteItem(int id, int index) async {
    debugPrint("Deleted Provider!");
    await db.deleteProviderItem(id);
    setState(() {
      _itemList.removeAt(index);
    });
  }

  _updateItem(ProviderItem item, int index) {
    var alert = new AlertDialog(
      title: new Text("Update Provider"),
      content: new Row(
        children: <Widget>[
          new Expanded(
              child: new TextField(
                controller: _textEditingController,
                autofocus: true,
                decoration: new InputDecoration(
                    labelText:  "Provider",
                    hintText: "eg Ralph Aceves",
                    icon: new Icon(Icons.update)),
              ))
        ],
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () async {
              ProviderItem newItemUpdated = ProviderItem.fromMap(
                  {"providerName": _textEditingController.text,
                    "dateCreated" : dateFormatted(),
                    "id" : item.id
                  });
              _handleSubmittedUpdate(index, item);//redrawing the screen
              await db.updateProviderItem(newItemUpdated); //updating the item
              setState(() {
                _readProviderList(); // redrawing the screen with all items saved in the db
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

  void _handleSubmittedUpdate(int index, ProviderItem item) {
    setState(() {
      _itemList.removeWhere((element) {
        _itemList[index].providerName == item.providerName;
      });
    });
  }

}
