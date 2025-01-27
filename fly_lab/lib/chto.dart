import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';

class Chto extends StatefulWidget {
  const Chto({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<Chto> createState() => _ChtoState();
}

class _ChtoState extends State<Chto> {
  late Scene _scene;
  late Object _skull;
  late Object _neskull;
  double _skullPos = 0.0;

  void _onSceneCreated(Scene scene) {
    _scene = scene;
    scene.camera.position.y = 0;
    scene.camera.position.z = 7;
    scene.light.position.setFrom(Vector3(0, 0, 10));
    scene.light.setColor(Colors.red, 0.1, 0.8, 0.5);
    // eye 1
    

    // skull
    _skull = Object(
        position: Vector3(0.0, 0.0, 0.0),
        scale: Vector3(5, 5, 5),
        rotation: Vector3(-90.0, 0.0, 0.0),
        backfaceCulling: false,
        lighting: true,
        fileName: 'assets/Sub/Submarine.obj'
    );
    // _neskull = Object(
    //     position: Vector3(0.0, 0.0, 0.0),
    //     scale: Vector3(5, 5, 5),
    //     rotation: Vector3(-90.0, 0.0, 0.0),
    //     backfaceCulling: false,
    //     lighting: true,
    //     fileName: 'assets/Skull/untitled1.obj'
    // );

    scene.world.add(_skull);
    // scene.world.add(_neskull);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Stack(
        children: <Widget>[
          Cube(onSceneCreated: _onSceneCreated),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  const Flexible(flex: 2, child: Text('Ne Skull pos')),
                  // Flexible(
                  //   flex: 8,
                  //   child: Slider(
                  //     value: _skullPos,
                  //     min: 0.0,
                  //     max: 10.0,
                  //     divisions: 100,
                  //     onChanged: (value) {
                  //       setState(() {
                  //         _skullPos = value;
                  //         _neskull.position.y = value;
                  //         //_scene.light.setColor(Colors.red, _ambient, _diffuse, _specular);
                  //         _neskull.updateTransform();
                  //         _scene.update();
                  //       });
                  //     },
                  //   ),
                  // ),
                ],
              ),
            ]
          )
        ]
      )
    );
  }
}