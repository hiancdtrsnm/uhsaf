import 'package:flutter/material.dart';
// change `flutter_database` to whatever your project name is
import 'database_helper.dart';
import 'form.dart';
import 'saf_form.dart';
import 'saf_model.dart';
import 'package:share/share.dart';

void main() {
  final dbHelper = DatabaseHelper.instance;
  Future<void> onSave(SAFModel safdata) async {
    print("This work");
    await dbHelper.insert(safdata.toJson());
  }

  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => HomeRoute(),
      '/form': (context) => SAFForm(
            onSave: onSave,
          ),
      // '/third': (context) => MyHomePage(),
      // '/about': (context) => AboutPage(),
    },
  ));
}

class HomeRoute extends StatelessWidget {
  final dbHelper = DatabaseHelper.instance;

  void _dump() async {
    // Assuming that the number of rows is the id for the last row.
    String csvPath = await dbHelper.saveCSV();
    Share.shareFiles(['$csvPath'], text: 'Database CSV');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulario SAF'),
        // backgroundColor: Colors.green,
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          RaisedButton(
            child: Text(
              'Formulario 📜',
              style: TextStyle(fontSize: 20),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/form');
            },
          ),
          // RaisedButton(
          //   child: Text('Database Stuff'),
          //   onPressed: () {
          //     Navigator.pushNamed(context, '/third');
          //   },
          // ),
          RaisedButton(
            child: Text(
              'Exportar 💾',
              style: TextStyle(fontSize: 20),
            ),
            onPressed: () {
              _dump();
            },
          ),
        ],
      )),
      bottomNavigationBar: Container(
        color: Colors.blue,
        child: Text(
            'Desarrollado por la Facultad de Matemática y Computación de la Universidad de la Habana',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
            )),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  // reference to our single class that manages the database
  final dbHelper = DatabaseHelper.instance;

  // homepage layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('sqflite'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text(
                'insert',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                _insert();
              },
            ),
            RaisedButton(
              child: Text(
                'query',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                _query();
              },
            ),
            RaisedButton(
              child: Text(
                'update',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                _update();
              },
            ),
            RaisedButton(
              child: Text(
                'delete',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                _delete();
              },
            ),
          ],
        ),
      ),
    );
  }

  // Button onPressed methods

  void _insert() async {
    // row to insert
    Map<String, dynamic> row = {
      'asdf': 'Bob',
    };
    final id = await dbHelper.insert(row);
    print('inserted row id: $id');
  }

  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach((row) => print(row));
  }

  void _update() async {
    // row to update
    Map<String, dynamic> row = {
      'asdf': 1,
    };
    final rowsAffected = await dbHelper.update(row);
    print('updated $rowsAffected row(s)');
  }

  void _delete() async {
    // Assuming that the number of rows is the id for the last row.
    final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(id);
    print('deleted $rowsDeleted row(s): row $id');
  }
}
