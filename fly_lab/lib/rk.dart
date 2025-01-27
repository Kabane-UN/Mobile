


import 'package:flutter/material.dart';



class MyForm1 extends StatefulWidget {
  const MyForm1({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() => MyFormState1();
}

class MyFormState1 extends State {
  String _vector1 = "1 1";
  String _vector2 = "0 0";
  double _res = 0.0;
  var colo = Colors.black;




  @override
  Widget build(BuildContext context) {

    return new Scaffold(
            appBar: new AppBar(title: Text('jfejsdfj')),
            body: Container(padding: EdgeInsets.all(10.0), child: new Column(children: <Widget>[
      new Text('Тестовое поле:', style: TextStyle(fontSize: 20.0),),
      new TextField(
              onChanged: (value) {
                _vector1 = value;
              },
            ),
      new TextField(
              onChanged: (value) {
                _vector2 = value;
              },
            ),

      new SizedBox(height: 20.0),

 //     new RaisedButton(onPressed: (){
 //       if(_formKey.currentState!.validate()) Scaffold.of(context).showSnackBar(SnackBar(content: Text('Форма заполнена!'+_body), backgroundColor: Colors.red,));
 //     }, child: Text('Отправить данные'), color: Colors.blue, textColor: Colors.white,),
      new Text("$_res", style: TextStyle(color: colo),),
ElevatedButton(
            child: Text('Button'),
            onPressed: () {
            setState(() {
              var _svect1 = _vector1.split(" ");
              var _svect2 = _vector2.split(" ");
              print(_svect1);
              _res = 0.0;
              for (int i = 0; i < _svect1.length; i++){
                _res += double.parse(_svect1[i])*double.parse(_svect2[i]);
              }
              print(_res);
              if (_res == 0.0) {
                colo = Colors.green;
              } else {
                colo = Colors.black;
              }

            });
		},
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                textStyle: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold)),
),

    ],)));
  }
}