import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class TodoItem {
  final String id;
  final String title;
  final bool completed;

  TodoItem({this.id, this.title, this.completed});
}

const TextStyle defaultTextStyle = TextStyle(
  fontFamily: "Helvetica Neue",
  fontWeight: FontWeight.w200,
  color: Color.fromARGB(255, 77, 77, 77),
);

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Todo MVC",
      home: TodoMvcHomePage(
        title: 'todos',
      ),
    );
  }
}

class TodoMvcHomePage extends StatefulWidget {
  TodoMvcHomePage({Key key, this.title}) : super(key: key);

  @override
  _TodoMvcHomePageState createState() => _TodoMvcHomePageState();

  final String title;
}

class _TodoMvcHomePageState extends State<TodoMvcHomePage> {
  var _todoItems = <TodoItem>[];
  var _activeTab = 0;
  var _selectedItem = "";
  final TextEditingController _controller = TextEditingController();

  void _addTodoItem(String title, bool completed) {
    if (title.isNotEmpty) {
      final workingList = List<TodoItem>.from(_todoItems);
      var item = TodoItem(id: Uuid().v4(), title: title, completed: completed);

      workingList.insert(0, item);
      persistData(workingList);
    }
  }

  void persistData(items) {
    setState(() {
      _todoItems = items;
    });
  }

  void _clearCompleted() {
    final workingList = List<TodoItem>.from(_todoItems.where((item) => item.completed == false));

    _setActiveTab(0);

    persistData(workingList);
  }

  void _toggleTodoItem(String id) {
    final workingList = List<TodoItem>.from(_todoItems);
    for (int i = 0; i < workingList.length; i++) {
      if (workingList[i].id == id) {
        workingList[i] = TodoItem(id: id, completed: !workingList[i].completed, title: workingList[i].title);
      }
    }
    persistData(workingList);
  }

  void _toggleTodoItems() {
    final workingList = List<TodoItem>.from(_todoItems);
    var activateAll = workingList.where((item) => item.completed == false).length != 0;

    for (int i = 0; i < workingList.length; i++) {
      workingList[i] = TodoItem(id: workingList[i].id, completed: activateAll, title: workingList[i].title);
    }

    persistData(workingList);
  }

  int _getActiveItemCount() {
    return _todoItems.where((item) => item.completed != true).length;
  }

  void _setActiveTab(int index) {
    setState(() {
      _activeTab = index;
    });
  }

  void _setSelectedItem(String id) {
    setState(() {
      _selectedItem = id;
    });
  }

  void _deleteSelectedItem() {
    final workingList = List<TodoItem>.from(_todoItems);
    workingList.removeWhere((item) => item.id == _selectedItem);
    persistData(workingList);
    setState(() {
      _selectedItem = null;
    });
  }

  Widget _getItemFooter() {
    return Visibility(
      visible: _todoItems.length > 0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              '${_getActiveItemCount()} items left',
              style: defaultTextStyle.merge(TextStyle(fontSize: 12)),
            ),
            ButtonTheme(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              child: ButtonBar(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  RawMaterialButton(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: _activeTab == 0 ? Color.fromARGB(51, 175, 47, 47) : Colors.transparent),
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                    ),
                    textStyle: defaultTextStyle.merge(TextStyle(fontSize: 12)),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    constraints: BoxConstraints(),
                    onPressed: () {
                      _setActiveTab(0);
                    },
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Text('All'),
                  ),
                  RawMaterialButton(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: _activeTab == 1 ? Color.fromARGB(51, 175, 47, 47) : Colors.transparent),
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                    ),
                    textStyle: defaultTextStyle.merge(TextStyle(fontSize: 12)),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    constraints: BoxConstraints(),
                    onPressed: () {
                      _setActiveTab(1);
                    },
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Text('Active'),
                  ),
                  RawMaterialButton(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: _activeTab == 2 ? Color.fromARGB(51, 175, 47, 47) : Colors.transparent),
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                    ),
                    textStyle: defaultTextStyle.merge(TextStyle(fontSize: 12)),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    constraints: BoxConstraints(),
                    onPressed: () {
                      _setActiveTab(2);
                    },
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Text('Completed'),
                  ),
                ],
              ),
            ),
            RawMaterialButton(
              textStyle: defaultTextStyle.merge(TextStyle(fontSize: 12)),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              constraints: BoxConstraints(),
              onPressed: () {
                _clearCompleted();
              },
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Text('Clear Completed'),
            )
          ],
        ),
      ),
    );
  }

  Widget _getItemTiles() {
    List<TodoItem> workingList;

    switch (_activeTab) {
      case 0:
        workingList = List<TodoItem>.from(_todoItems);
        break;
      case 1:
        workingList = List<TodoItem>.from(_todoItems.where((item) => item.completed == false));
        break;
      case 2:
        workingList = List<TodoItem>.from(_todoItems.where((item) => item.completed == true));
        break;
    }

    final textStyle = defaultTextStyle.merge(TextStyle(fontSize: 24));
    final textStyleComplete = textStyle.merge(
      TextStyle(
        color: Colors.grey[400].withAlpha(100),
        decoration: TextDecoration.lineThrough,
      ),
    );

    List<Widget> list = List<Widget>();

    for (var i = 0; i < workingList.length; i++) {
      list.add(
        ListTile(
          contentPadding: EdgeInsets.all(0),
          trailing: Visibility(
            visible: _selectedItem == workingList[i].id,
            child: IconButton(
              color: Colors.red,
              icon: Icon(CupertinoIcons.clear_circled),
              onPressed: () {
                _deleteSelectedItem();
              },
            ),
          ),
          onTap: () {
            _setSelectedItem(workingList[i].id);
          },
          title: Text(
            workingList[i].title,
            style: workingList[i].completed ? textStyleComplete : textStyle,
          ),
          leading: IconButton(
            iconSize: 36,
            padding: EdgeInsets.all(0),
            color: workingList[i].completed ? Colors.green[300] : Colors.grey[200],
            icon: Icon(workingList[i].completed ? CupertinoIcons.check_mark_circled : CupertinoIcons.circle),
            onPressed: () {
              _toggleTodoItem(workingList[i].id);
            },
          ),
        ),
      );
      list.add(Divider(color: Colors.grey, height: 1));
    }
    return Column(
      children: list,
    );
  }

  Widget _getItemHeader() {
    return Container(
      child: Row(
        children: <Widget>[
          IconButton(
            iconSize: 36,
            padding: EdgeInsets.all(0),
            color: Colors.grey[300],
            icon: Visibility(
                visible: _todoItems.length > 0,
                child: Icon(
                  IconData(0xf3d0, fontFamily: "CupertinoIcons", fontPackage: "cupertino_icons", matchTextDirection: true),
                )),
            onPressed: _toggleTodoItems,
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: new InputDecoration(
                  hintText: "What needs to be done?",
                  hintStyle: defaultTextStyle.merge(
                    TextStyle(fontSize: 24, fontStyle: FontStyle.italic, color: Color.fromARGB(77, 77, 77, 77)),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  border: InputBorder.none),
              keyboardType: TextInputType.text,
              style: defaultTextStyle.merge(
                TextStyle(fontSize: 24),
              ),
              onSubmitted: (input) {
                _addTodoItem(input, false);
                _controller.clear();
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: GestureDetector(
        onTap: () {
          _setSelectedItem(null);
        },
        child: ListView(
          children: <Widget>[
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 20, bottom: 10),
                child: Text(
                  widget.title,
                  style: defaultTextStyle.merge(TextStyle(color: Color.fromARGB(125, 175, 47, 47), fontSize: 70, fontWeight: FontWeight.w100)),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 10, right: 10),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  Positioned.fill(
                    bottom: 10,
                    child: Visibility(
                      visible: _todoItems.length > 0,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Material(
                          type: MaterialType.card,
                          color: Colors.white,
                          elevation: 5,
                          child: Container(
                            width: double.infinity,
                            child: SizedBox(
                              height: 10,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    bottom: 15,
                    child: Visibility(
                      visible: _todoItems.length > 0,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        child: Material(
                          type: MaterialType.card,
                          color: Colors.white,
                          elevation: 5,
                          child: Container(
                            width: double.infinity,
                            child: SizedBox(
                              height: 10,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Material(
                        type: MaterialType.card,
                        color: Colors.white,
                        elevation: 5,
                        child: Column(
                          children: <Widget>[
                            _getItemHeader(),
                            Visibility(
                              visible: _todoItems.length > 0,
                              child: Divider(color: Colors.grey[200], height: 1),
                            ),
                            Visibility(
                              visible: _todoItems.length > 0,
                              child: Divider(color: Colors.grey[4250], height: 1),
                            ),
                            Visibility(
                              visible: _todoItems.length > 0,
                              child: Divider(color: Colors.grey[500], height: 1),
                            ),
                            _getItemTiles(),
                            _getItemFooter(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
