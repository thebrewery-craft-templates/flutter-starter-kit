import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:flutterparseserver/application_constants.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Back4App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Back4App App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final myAnimalController = TextEditingController();
  List<Object> list = [];

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    Parse().initialize(keyParseApplicationId, keyParseServerUrl,
        liveQueryUrl: keyLiveQuery,
        clientKey: keyParseClientKey,
        debug: true,
        autoSendSessionId: false);

    final ParseResponse response = await Parse().healthCheck();

    if (response.success) {
      ListItems();
    } else {
      print('Server health check failed');
    }
  }

  Future<void> ListItems() async {
    QueryBuilder<ParseObject> query =
        QueryBuilder<ParseObject>(ParseObject('Animal'));

    var apiResponse = await query.query();

    if (apiResponse.success) {
      int index = 0;
      for (var object in apiResponse.result) {
        var name = object.get('Name');
        list.insert(index, name);
        index++;
      }
    } else {
      print(apiResponse.toString());
    }
  }

  Future<void> _addAnimal() async {
    var animal = ParseObject('Animal')..set('Name', myAnimalController.text);
    var response = await animal.save();
    if (response.success) {
      int listSize = list.length;
      list.insert(listSize++, myAnimalController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: myAnimalController,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: 'Add a new name here'),
            ),
            ListView.builder(
              itemCount: list.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Text(list[index]);
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addAnimal,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
