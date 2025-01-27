import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'dart:io'; 

class Hohoho extends StatefulWidget {
  const Hohoho({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  HohohoState createState() => HohohoState();
}

class HohohoState extends State<Hohoho> {
  static String username = 'brim.bom.bom@yandex.ru';
  static String password = 'ztnrtgyvxvzkgnyj';
  final smtpServer = yandex(username, password);
  String massage = '';
  String title = '';
  String to = '';
  void mailSend(String to,String title,String massage) async{
    final toSend = Message()
    ..from = Address(username, 'Андрей Кабанов')
    ..recipients.add(to)
    // ..ccRecipients.addAll(['posevin@mail.ru', 'posevin@gmail.com'])
    ..bccRecipients.add(Address('andryushka.kaban.z@xmail.ru'))
    ..subject = '$title :: 😀 :: ${DateTime.now()}'
    ..text = massage
    ..html = '<h1>Test</h1>\nImage from attachment<br><img src="cid:myimg@3.141" width="200"/>'
    ..attachments = [
      FileAttachment(File('icons/placeholder.png'))
        ..location = Location.inline
        ..cid = '<myimg@3.141>'
    ];
    try {
      final sendReport = await send(toSend, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      print(e);
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
    // ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar:  AppBar(title: Text(widget.title)),
      body: Container(padding: EdgeInsets.all(10.0), child: new Column(children: <Widget>[
        new Text('Тестовое поле:', style: TextStyle(fontSize: 20.0),),
        new TextField(
                onChanged: (value) {
                  to = value;
                },
              ),
        new TextField(
                onChanged: (value) {
                  title = value;
                },
              ),
        new TextField(
                onChanged: (value) {
                  massage = value;
                },
              ),

        new SizedBox(height: 20.0),
        ElevatedButton(
                  child: Text('Send'),
                  onPressed: () {
                  setState(() {
                    mailSend(to, title, massage);
                  });
          },
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      textStyle: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold)),
      ),
      ]))
    );
  }

}