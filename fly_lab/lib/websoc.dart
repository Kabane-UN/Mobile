import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert' show json;

class MyWebs extends StatefulWidget {
  const MyWebs({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  MyWebsState createState() => MyWebsState();
}

class MyWebsState extends State<MyWebs> {
  WebSocketChannel channel = IOWebSocketChannel.connect('ws://192.168.141.1:8000');
  TextEditingController controller = TextEditingController();
  final List<String> list = [];


  @override
  void initState() {
    super.initState();
    //channel = IOWebSocketChannel.connect('ws://151.248.113.144:8765');
    //controller = TextEditingController();
    channel.stream.listen((data) => setState(() => controller.text=data));
  }

  void sendData() {
    if (controller.text.isNotEmpty) {
      channel.sink.add(json.encode({
                  'method': 'send',
                  'data': controller.text,
                }));
      controller.text = "";
    }
  }
  void getData() {
    channel.sink.add(json.encode({
                'method': 'get',
              }));
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
  void _incrementCounter() {
    setState(() {
      controller.text = "${int.parse(controller.text)+1}";
    });
  }
  void _decrementCounter() {
    setState(() {
      controller.text = "${int.parse(controller.text)-1}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Form(
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: "Send to WebSocket",
                ),
              ),
            ),
            Column(
              children: list.map((data) => Text(data)).toList(),
            ),
            IconButton(
              onPressed: () {
                sendData();
              },
              icon: const Icon(
                Icons.arrow_forward,
                color:  Color.fromARGB(255, 102, 102, 102),
                size: 100,
                
              ),
            ),
            IconButton(
              onPressed: () {
                getData();
              },
              icon: const Icon(
                Icons.arrow_back,
                color:  Color.fromARGB(255, 102, 102, 102),
                size: 100,
                
              ),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    onPressed: _decrementCounter,
                    // tooltip: 'Decrement',
                    icon: const Icon(Icons.remove),
                  ),
                  IconButton(
                    onPressed: _incrementCounter,
                    // tooltip: 'Increment',
                    icon: const Icon(Icons.add),
                  ), 
                ]
              )
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.send),
      //   onPressed: () {
      //     sendData();
      //   },
      // ),
    );
  }
}
  