import 'dart:math' as math;
import 'package:ditredi/ditredi.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:math_parser/math_parser.dart';


class Lovers extends StatefulWidget {
  const Lovers({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<Lovers> createState() => _LoversState();
}

class _LoversState extends State<Lovers> {

  
  List<Point3D> _points = [];
  double x = 4;
  double y = 10;
  double a = 0.0;
  double b = 0.0;
  MathNode func = MathNodeExpression.fromString("(x-3*y)^2+(y-2)^2", variableNames: {'x', 'y'});
  MathNode funcdx = MathNodeExpression.fromString("(x-3*y)*2", variableNames: {'x', 'y'});
  MathNode funcdy = MathNodeExpression.fromString("-3*2*(x-3*y)+2*(y-2)", variableNames: {'x', 'y'});
  List<vector.Vector3> _nag = [];
  List<Line3D>_lines = [];
  List<Point3D>_nag_points = [];
  final _controller = DiTreDiController(
    rotationX: 0,
    rotationY: 0,
    rotationZ: 0,
    maxUserScale: 50,
  );
  double index = 0;
  List<Model3D<Model3D<dynamic>>> res = [];
  

  @override
  Widget build(BuildContext context) {
    _points = _generatePoints(func).toList();
    _nag = _NAG(x, y, func, funcdx, funcdy);
    _lines = genLines(_nag);
    _nag_points = _genredpoints(_nag);
    res = [];
    for (int i = 0; i < _points.length; i++) {
      res.add(_points[i]);
    }
    for (int i = 0; i < index.toInt(); i++) {
      res.add(_lines[i]);
    }
    for (int i = 0; i < index.toInt()+1 && i < _nag_points.length; i++) {
      res.add(_nag_points[i]);
    }
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
        body: SafeArea(
          child: Flex(
            crossAxisAlignment: CrossAxisAlignment.start,
            direction: Axis.vertical,
            children: [
              Expanded(
                child: DiTreDiDraggable(
                  controller: _controller,
                  child: DiTreDi(
                    figures: res,
                    controller: _controller,
                    config: const DiTreDiConfig(
                      defaultPointWidth: 2,
                      supportZIndex: true,
                      perspective: true,
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Drag to rotate. Scroll to zoom"),
              ),
              Slider(
                value: index,
                min: 0,
                max: _nag.length.toDouble()>0 ? _nag.length.toDouble()-1 : 0,
                divisions: _nag.length > 1 ?_nag.length-1 : 1,
                onChanged: (value) {
                  setState(() {
                    index = value;
                    res = res.sublist(0, _points.length);
                    for (int i = 0; i < index.toInt(); i++) {
                      res.add(_lines[i]);
                    }
                    for (int i = 0; i < index.toInt(); i++) {
                      res.add(_nag_points[i]);
                    }
                    print('newwwwwwwwwwwwwwwwwwwwwwww');
                  });
                }
              ),
              new Text('X', style: TextStyle(fontSize: 20.0),),
              new TextField(
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    x = double.parse(value);
                  }
                  
                },
              ),
              new Text('Y', style: TextStyle(fontSize: 20.0),),
              new TextField(
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          y = double.parse(value);
                        }
                      },
                    ),
              new Text('a', style: TextStyle(fontSize: 20.0),),
              new TextField(
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          a = double.parse(value);
                        }
                        
                      },
                    ),
              new Text('b', style: TextStyle(fontSize: 20.0),),
              new TextField(
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          b = double.parse(value);
                        }
                      },
                    ),

              new SizedBox(height: 20.0),
              ElevatedButton(
                        child: Text('Send'),
                        onPressed: () {
                        setState(() {
                          func = MathNodeExpression.fromString("(x-$a)^2+(y-$b)^2", variableNames: {'x', 'y'});
                          funcdx = MathNodeExpression.fromString("2*(x-$a)", variableNames: {'x', 'y'});
                          funcdy = MathNodeExpression.fromString("2*(y-$b)", variableNames: {'x', 'y'});
                          index = 0;
                          _points = _generatePoints(func).toList();
                          _nag = _NAG(x, y, func, funcdx, funcdy);
                          _lines = genLines(_nag);
                          _nag_points = _genredpoints(_nag);
                          res = [];
                          for (int i = 0; i < _points.length; i++) {
                            res.add(_points[i]);
                          }
                          for (int i = 0; i < index.toInt(); i++) {
                            res.add(_lines[i]);
                          }
                          for (int i = 0; i < index.toInt()+1 && i < _nag_points.length; i++) {
                            res.add(_nag_points[i]);
                          }
                        });
                },
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                            textStyle: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold)),
            ),
            ],
          ),
        ),
      );
  }
}

List<Line3D> genLines(List<vector.Vector3> _nag){
  List<Line3D> res = [];
  for (var i = 0; i < _nag.length-1; i++){
    res.add(Line3D(_nag[i], _nag[i+1], width: 1, color: const Color.fromARGB(255, 212, 4, 4)));
  }
  return res;
}
List<Point3D> _genredpoints(_nag) {
  List<Point3D> res = [];
  for (var i = 0; i < _nag.length; i++) {
    res.add(Point3D(_nag[i], color: const Color.fromARGB(255, 0, 26, 255), width: 5));
  }
  return res;
}
double norm(double x, double y) {
  return math.sqrt(math.pow(x, 2)+math.pow(y, 2));
}
double golden_section(f, a, b,eps){
    double Fi = (1+math.sqrt(5))/2;
    while (true){
        double x1 = b-(b-a)/Fi;
        double x2 = a+(b-a)/Fi;
        double y1 = f(x1);
        double y2 = f(x2);
        if (y1 >= y2) {
            a = x1;
        }
        else{
            b = x2;
        }
        if ((b-a).abs() < eps){
          return (a+b)/2;
        }
    }
}

List<vector.Vector3> _NAG(double x, double y, MathNode func, MathNode funcdx, MathNode funcdy) {
  f(double x, double y) => func.calc(MathVariableValues({'x': x, 'y': y})).toDouble();
  dfdx(double x, double y) => funcdx.calc(MathVariableValues({'x': x, 'y': y})).toDouble();
  dfdy(double x, double y) => funcdy.calc(MathVariableValues({'x': x,'y': y})).toDouble();
  List<vector.Vector3>gg = [];
  double eps1 = 0.25;
  double eps2 = 0.25;
  int k = 0;
  int M = 100;
  double prev_dx = 0;
  double prev_dy = 0;
  double mu = 0.5;
  double lr = 0.01;
  while (true) {
    prev_dx = dfdx(x, y)+mu*prev_dx;
    prev_dy = dfdy(x, y)+mu*prev_dy;
    double dx = mu*prev_dx;
    double dy = mu*prev_dy;
    print(dx);
    print(dy);
    if (norm(dx, dy) < eps1) {
      return gg;
    }
    else if (k > M){
      return gg;
    }
    double x_new = x-lr*dx;
    double y_new = y-lr*dy;
    print("-------------");
    print(x_new);
    print(y_new);
    print(f(x_new, y_new));
    if (f(x_new, y_new) < 30) {
      gg.add(vector.Vector3(x_new,f(x_new, y_new), y_new));
    }
    if (norm(x_new - x, y_new - y) < eps1 && (f(x_new, y_new) - f(x, y)).abs() < eps2){
      return gg;
    } else {
      k++;
      x = x_new;
      y = y_new;
    }
  }
}
Iterable<Point3D> _generatePoints(MathNode func) sync* {
  for (double x = -20; x < 20; x+=0.05) {
    for (double y = -20; y < 20; y+=0.05) {
      double z = func.calc(MathVariableValues({'x': x, 'y': y})).toDouble();
      if (z < 30){
        yield Point3D(
          vector.Vector3(
            x,
            z,
            y,
            
          ),
        );
      } else {
        continue;
      }
    }
  }
}