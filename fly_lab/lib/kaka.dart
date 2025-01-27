import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:dio/dio.dart';

class PHPData {
  final String name;
  final String gps;
  final String address;
  final String tel;
  double latitude = 0.0;
  double longitude = 0.0;

  PHPData({required this.name, required this.gps, required this.address, required this.tel});

  factory PHPData.fromJson(Map<String, dynamic> json) {
    PHPData phpData = PHPData(name: json['name'] ?? '',
      gps: json['gps'] ?? '',
      address: json['address'] ?? '',
      tel: json['tel'] ?? '',
    );
    phpData.setCoords();
    return phpData;
  }
  void setCoords() {
    var latitudeAndLongitude = (gps.split(',').map((s) => s.trim()).toList()).map((s) =>
    double.parse(s)).toList();
    latitude = latitudeAndLongitude[0];
    longitude = latitudeAndLongitude[1];
  }
}
class SmokeWiget extends StatelessWidget {
  const SmokeWiget({required this.data});

  final PHPData data;
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
        Text(data.name, style: const TextStyle(fontSize: 30)),
        Text(data.gps,style: const TextStyle(fontSize: 30)),
        Text(data.address, style: const TextStyle(fontSize: 30)),
        Text(data.tel, style: const TextStyle(fontSize: 30))
      ]);
  }
}

class MyKak extends StatefulWidget {
  const MyKak({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  MyKakState createState() => MyKakState();
}

class MyKakState extends State<MyKak> {
  final Dio dio = Dio();
  late final YandexMapController _yandexMapController;

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    _yandexMapController.dispose();
    super.dispose();
  }
  List<PlacemarkMapObject> genPlacemarkMapObject(BuildContext context, List<PHPData> data) {
    List<PlacemarkMapObject> objects = [];
    int i = 0;
    for (var d in data) {
      var newObj = PlacemarkMapObject(mapId: MapObjectId(i.toString()),
          point: Point(latitude: d.latitude, longitude: d.longitude),
          opacity: 1,
          icon: PlacemarkIcon.single(
           PlacemarkIconStyle(
             image: BitmapDescriptor.fromAssetImage(
               'icons/placeholder.png',
             ),
             scale: 0.1,
           ),
         ),
          onTap: (_, __) => showModalBottomSheet(context: context, builder: (context) => SmokeWiget(data: d))
      );
      objects.add(newObj);
      i += 1;
    }
    return objects;
  }
  Future<List<PHPData>> fetchData() async {
    final response = await dio.get('http://pstgu.yss.su/iu9/mobiledev/lab4_yandex_map/2023.php?x=var23');
    if (response.statusCode == 200) {
      final List<dynamic> dataList = response.data;
      final List<PHPData> userList = dataList.map((json) => PHPData.fromJson(json)).toList();
      return userList;
    }
    return [];
  }
  
  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar:  new AppBar(title: Text(widget.title)),
      body: FutureBuilder<List<PHPData>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return YandexMap(
              onMapCreated: (controller) async {
                _yandexMapController = controller;
                await _yandexMapController.moveCamera(CameraUpdate.newCameraPosition(
                    const CameraPosition(target: Point(latitude: 50, longitude: 20), zoom: 3)
                ));
              },
              mapObjects: genPlacemarkMapObject(context, snapshot.data!),
            );
          }
        },
      ),
    );
  }
  
}
