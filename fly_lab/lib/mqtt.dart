

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';


class MyForm extends StatefulWidget {
  const MyForm({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() => MyFormState();
}

class MyFormState extends State {
  String _body1 = "1";
  String _body2 = "2";
  String _body3 = "3";

final client = MqttServerClient('test.mosquitto.org', '');

var pongCount = 0; // Pong counter

Future AAA(String message1, String message2, String message3) async {

  client.logging(on: true);
  client.setProtocolV311();
  client.keepAlivePeriod = 20;
  client.onDisconnected = onDisconnected;
  client.onConnected = onConnected;
  client.onSubscribed = onSubscribed;
  client.pongCallback = pong;

  print('Mosquitto client connecting....');


  try {
    await client.connect();
  } on NoConnectionException catch (e) {
    print('client exception - $e');
    client.disconnect();
  } on SocketException catch (e) {
    print('socket exception - $e');
    client.disconnect();
  }

  if (client.connectionStatus!.state == MqttConnectionState.connected) {
    print('Mosquitto client connected');
  } else {
    print('ERROR Mosquitto client connection failed - disconnecting, status is ${client.connectionStatus}');
    client.disconnect();
    exit(-1);
  }

  client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
    final recMess = c![0].payload as MqttPublishMessage;
    final pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    print('Change notification:: ---------------> topic is <${c[0].topic}>, payload is <-- $pt -->');
    if (c[0].topic == 'IU9/test1Kab') {
      setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _body1 = "--> ${pt}";
    });
    } else if (c[0].topic == 'IU9/test2Kab') {
      setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _body2 = "--> ${pt}";
    });
    } else {
      setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _body3 = "--> ${pt}";
    });
    }
    print('');
  });
  client.published!.listen((MqttPublishMessage message) {
    print('Published notification:: topic is ${message.variableHeader!.topicName}, with Qos ${message.header!.qos}');
  });

  const pubTopic1 = 'IU9/test1Kab';
  const pubTopic2 = 'IU9/test2Kab';
  const pubTopic3 = 'IU9/test3Kab';
  final builder1 = MqttClientPayloadBuilder();
  builder1.addString('Dart say ${message1}');
  final builder2 = MqttClientPayloadBuilder();
  builder2.addString('Dart say ${message2}');
  final builder3 = MqttClientPayloadBuilder();
  builder3.addString('Dart say ${message3}');
  // _body = "--> ${message}";

  print('Subscribing to the UI/9 topic');
  client.subscribe(pubTopic1, MqttQos.exactlyOnce);
  client.subscribe(pubTopic2, MqttQos.exactlyOnce);
  client.subscribe(pubTopic3, MqttQos.exactlyOnce);

  print('Publishing our topic');
  client.publishMessage(pubTopic1, MqttQos.exactlyOnce, builder1.payload!);
  client.publishMessage(pubTopic2, MqttQos.exactlyOnce, builder2.payload!);
  client.publishMessage(pubTopic3, MqttQos.exactlyOnce, builder3.payload!);

  print('Sleeping.... 60 sec');   /// Ok, we will now sleep a while, in this gap you will see ping request/response messages being exchanged by the keep alive mechanism.
  await MqttUtilities.asyncSleep(60);
  print('Awaked');
  print('Unsubscribing....'); 
  client.unsubscribe(pubTopic1);
  client.unsubscribe(pubTopic2);
  client.unsubscribe(pubTopic3);

  
  await MqttUtilities.asyncSleep(2); /// Wait for the unsubscribe message from the broker if you wish.
  print('Disconnecting ...');
  client.disconnect();
  print('Stopped! Bye!....');

}

void onSubscribed(String topic) {
  print('Subscription confirmed for topic $topic');
}

void onDisconnected() {
  print('OnDisconnected client callback - Client disconnection');
  if (client.connectionStatus!.disconnectionOrigin ==
      MqttDisconnectionOrigin.solicited) {
    print('OnDisconnected callback is solicited, this is correct');
  } else {
    print('OnDisconnected callback is unsolicited or none, this is incorrect - exiting');
    exit(-1);
  }
  if (pongCount == 3) {
    print('Pong count is correct');
  } else {
    print('Pong count is incorrect, expected 3. actual $pongCount');
  }
}

void onConnected() {
  print('OnConnected client callback - Client connection was successful');
}

void pong() {
  print('Ping response client callback invoked');
  // _body = 'Ping response client callback invoked';
  pongCount++;
}




  @override
  Widget build(BuildContext context) {

    return new Scaffold(
            appBar: new AppBar(title: Text('jfejsdfj')),
            body: Container(padding: EdgeInsets.all(10.0), child: new Column(children: <Widget>[
      new Text('Тестовое поле:', style: TextStyle(fontSize: 20.0),),
      new TextField(
              onChanged: (value) {
                _body1 = value;
              },
            ),
      new TextField(
              onChanged: (value) {
                _body2 = value;
              },
            ),
      new TextField(
              onChanged: (value) {
                _body3 = value;
              },
            ),

      new SizedBox(height: 20.0),

 //     new RaisedButton(onPressed: (){
 //       if(_formKey.currentState!.validate()) Scaffold.of(context).showSnackBar(SnackBar(content: Text('Форма заполнена!'+_body), backgroundColor: Colors.red,));
 //     }, child: Text('Отправить данные'), color: Colors.blue, textColor: Colors.white,),
      new Text(_body1),
      new Text(_body2),
      new Text(_body3),
ElevatedButton(
            child: Text('Button'),
            onPressed: () {
            print(_body1);
            print(_body2);
            print(_body3);
            AAA(_body1, _body2, _body3);

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
