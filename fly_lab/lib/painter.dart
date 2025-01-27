import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnglePainter extends StatefulWidget {
  const AnglePainter({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _AnglePainterState createState() => _AnglePainterState();
}

class _AnglePainterState extends State<AnglePainter> with TickerProviderStateMixin{
  // TextEditingController _diagonalAController = TextEditingController();
  // TextEditingController _diagonalBController = TextEditingController();
  var _sides = 5;
  var __radius = 100.0;
  // var _angle = math.pi;
  late Animation<double> animation;
  late AnimationController controller_angle;
  @override
  void initState(){
    super.initState();
    controller_angle = AnimationController(vsync: this, duration: Duration(microseconds: 2));
    Tween<double> _angle = Tween(begin: 0.0, end: math.pi*2);
    animation = _angle.animate(controller_angle)
    ..addListener(() {
      setState(() {
        
      });
    })
    ..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller_angle.repeat();
      } else if (status == AnimationStatus.dismissed) {
        controller_angle.forward();
      }
    });
    controller_angle.forward();
  }
  @override
  void dispose() {
    controller_angle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body:Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 100),
            CustomPaint(
              size: Size(200, 200),
              painter: CustomCustomPainter(
                _sides,
                __radius,
                animation.value
              ),
            ),
          ],
      ),
    )
    );
    
  }
}

class CustomCustomPainter extends CustomPainter {
  final int sides;
  final double radius;
  final double angle;

  CustomCustomPainter(this.sides, this.radius, this.angle);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    var path = Path();
    var rot = math.pi * 2 / sides;
    Offset center = Offset(size.width / 2, size.height / 2);
    // diag A left corner point
    Offset start = Offset(radius*math.cos(angle), radius*math.sin(angle));


    path.moveTo(start.dx+center.dx, start.dy+center.dy);
    for (int i =0; i <= sides; i++){
      double x = radius * math.cos(rot*i+angle)+center.dx;
      double y = radius * math.sin(rot*i+angle)+center.dy;
      path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}