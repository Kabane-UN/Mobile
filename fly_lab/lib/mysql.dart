import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';



class MyForm3 extends StatefulWidget {
  const MyForm3({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() => MyFormState3();
}

class MyFormState3 extends State<MyForm3> {
  String _name = "";
  String _email = "";
  int _age = 0;
  String _res = "";

  Future conexionDB() async{
  var settings = new ConnectionSettings(
    host: 'students.yss.su',
    port: 3306,
    user: 'iu9mobile',
    password: 'bmstubmstu123',
    db: 'iu9mobile'
  );
  var conn = await MySqlConnection.connect(settings);
  return conn;
  }

  Future aaa(String name, String email, int age) async {
    var conn = await conexionDB();
    await conn.query(
          'insert into Kabanov (name, email, age) values (?, ?, ?)',
          [name, email, age]);
    
  }
  Future bbb() async{
    var conn = await conexionDB();
    var result = await conn.query(
          'select * from Kabanov');
    String res = "";
    for (var row in result){
      res += "Id: ${row[0]}, Name: ${row[1]}, Email: ${row[2]}, Age: ${row[3]}\n";
    }
    _res = res;
  }
  Future ddd() async{
    var conn = await conexionDB();
    await conn.query('delete from Kabanov');
  }


  @override
  Widget build(BuildContext context){

    return new Scaffold(
            appBar: new AppBar(title: Text(widget.title)),
            body: Container(padding: EdgeInsets.all(10.0), child: new Column(children: <Widget>[
      new Text('Тестовое поле:', style: TextStyle(fontSize: 20.0),),
      new TextField(
              onChanged: (value) {
                _name = value;
              },
            ),
      new TextField(
              onChanged: (value) {
                _email = value;
              },
            ),
      new TextField(
              onChanged: (value) {
                _age = int.parse(value);
              },
            ),

      new SizedBox(height: 20.0),
      ElevatedButton(
                  child: Text('PUSH'),
                  onPressed: () {
                  setState(() {
                    aaa(_name, _email, _age);
                  });
          },
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      textStyle: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold)),
      ),
      new SizedBox(height: 20.0),
      ElevatedButton(
                  child: Text('GET'),
                  onPressed: () {
                  setState(() {
                    bbb();
                  });
          },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      textStyle: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold)),
      ),
      new Text(_res),
      new SizedBox(height: 20.0),
      ElevatedButton(
                  child: Text('CLEAN'),
                  onPressed: () {
                  setState(() {
                    ddd();
                  });
          },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 0, 0),
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      textStyle: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold)),
      ),

    ],)));
  }
}