import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:usblibforelisey/usblibforelisey.dart';
import "dart:math" as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _connectionStatus = 'Unknown';
  String _readData = 'No data received';
  final _usblibforeliseyPlugin = Usblibforelisey();
  var u = 0;
  var v = 0;
  Duration karatime = const Duration();
  Duration nurmtime = const Duration();
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String connectionStatus;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      connectionStatus = await status();
    } catch (e) {
      connectionStatus = 'Some error!';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _connectionStatus = connectionStatus;
    });

    if (connectionStatus == 'Connected!'){
      return;
    }

    await Future.delayed(Duration(seconds: 1));
    await initPlatformState();
  }

  Future<String> status() async {
    var hasAccessory = await _usblibforeliseyPlugin.hasAccessoryConnected();
    if (!hasAccessory) {
      return 'No devices';
    }

    var hasPermission = await _usblibforeliseyPlugin.hasPermission(0);
    if (!hasPermission) {
      await _usblibforeliseyPlugin.requestPermission(0);
      return 'No permission!';
    }

    await _usblibforeliseyPlugin.connect(0);
    return 'Connected!';
  }

  Future<void> read() async {
    var data = await _usblibforeliseyPlugin.read();
    setState(() {
      _readData = String.fromCharCodes(data);
      RegExp regex = RegExp(r'\d+');
      String match = regex.firstMatch(_readData)![0]!;
      u = int.parse(match);
      v = u;
      var uv = int2vec(u);
      var vv = int2vec(v);
      Stopwatch stopwatch = Stopwatch()..start();
      var resk = karatsuba(u, v);
      karatime = stopwatch.elapsed;

      stopwatch = Stopwatch()..start();
      var resnv = standard_multiplication(uv, vv);
      var resn = vec2int(resnv);
      nurmtime = stopwatch.elapsed;

    });

    await Future.delayed(const Duration(milliseconds: 500));
    await read();
  }
  int karatsuba(int a, int b){
    if (a < 10 || b < 10){
      return a*b;
    }
    int n = math.max((math.log(a)/math.ln10+1).floor(), (math.log(a)/math.ln10+1).floor());
    int m = n ~/ 2;
    int high1 = (a ~/ math.pow(10, m));
    int low1 = a % math.pow(10, m).toInt();
    int high2 = (b ~/ math.pow(10, m));
    int low2 = b % math.pow(10, m).toInt();
    int z0 = karatsuba(low1, low2);
    int z1 = karatsuba(low1 + high1, low2 + high2);
    int z2 = karatsuba(high1, high2);
    return z2 * math.pow(10, 2*m).toInt() + (z1 - z2 - z0) * math.pow(10, m).toInt() + z0;
  }
  List<int> standard_multiplication(List<int> x, List<int> y){
    int n = x.length;
    List<int> result = [];
    for (int i = 0; i < 2*n; i++){
      result.add(0);
    }
    for (int i = n-1; i >= 0; i--){
      int carry = 0;
      for (int j = n-1; j >= 0; j--){
            result[i + j+1] += x[i] * y[j] + carry;
            carry = (result[i + j+1] ~/ 10);
            result[i + j+1] = (result[i + j+1] % 10);
      }
      result[i] += carry;
    }
    return result;
  }
  int vec2int(List<int> v){
    int res = 0;
    for (int i = 0; i < v.length; i++){
        res += v[i]*math.pow(10, (v.length-i-1)).toInt();
    }
    return res;
  }
  List<int> int2vec(int n){
    return n.abs().toString().split('').map(int.parse).toList();
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Метод А.А. Караццубы (Dart)"),
        ),
        body: Center(
          child: Column(
            children: [
              Text('Connection status: $_connectionStatus\n'),
              // TextField(
              //   controller: _textEditingController,
              //   decoration: const InputDecoration(
              //     hintText: 'Enter your message',
              //     border: OutlineInputBorder(),
              //   ),
              // ),
              // const SizedBox(height: 10),
              // ElevatedButton(
              //   onPressed: () async {
              //     if (_textEditingController.text.isEmpty) {
              //       return;
              //     }

              //     await _usblibforeliseyPlugin.write(Uint8List.fromList(
              //         _textEditingController.text.codeUnits));
              //     return;
              //   },
              //   child: const Text('Send'),
              // ),
              
              ElevatedButton(
                onPressed: () async {
                  await read();
                },
                child: const Text('Listen'),
              ),

              const SizedBox(height: 20),
              new Text(
            "u = " + u.toRadixString(2)
        ),
          new Text(
              "v = " + v.toRadixString(2)
          ),
          new Text(
              "kara time " + karatime.toString()
          ),
          new Text(
              "norm time " + nurmtime.toString()
          ),

              // Large label at the bottom
              Text(
                'Reader: $_readData',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
