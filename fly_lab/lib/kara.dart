import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:core';

class MyForm2000 extends StatefulWidget {
  const MyForm2000({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() => MyForm2000State();
}


class MyForm2000State extends State<MyForm2000> {
  var u = 0;
  var v = 0;
  Duration karatime = const Duration();
  Duration nurmtime = const Duration();
  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
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
  Widget build(BuildContext context){
    return new Scaffold(
      appBar:  new AppBar(title: Text(widget.title)),
      body: Container(padding: EdgeInsets.all(10.0), child: new Column(children: <Widget>[
        new TextField(
              onChanged: (value) {
                u = int.parse(value);
              },
            ),
        new TextField(
              onChanged: (value) {
                v = int.parse(value);
              },
            ),
        new Text(
            "u = " + u.toRadixString(2)
        ),
        new Text(
            "v = " + v.toRadixString(2)
        ),
        ElevatedButton(
          child: Text('Run'),
          onPressed: () {
            setState(() {
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
          }
        ),
        new Text(
            "kara time " + karatime.toString()
        ),
        new Text(
            "norm time " + nurmtime.toString()
        ),
      ]
      ),
      )
    );
  }
  
}