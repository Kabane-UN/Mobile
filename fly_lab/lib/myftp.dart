import 'package:flutter/material.dart';

class MyFtp extends StatefulWidget {
  const MyFtp({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  MyFtpState createState() => MyFtpState();
}

class MyFtpState extends State<MyFtp> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar:  AppBar(title: Text(widget.title)),
    );
  }
}