import 'package:fly_lab/lovers.dart';
import 'mqtt.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'painter.dart';
import 'rk.dart';
import 'mysql.dart';
import 'websoc.dart';
import 'kaka.dart';
import 'hohoho.dart';
import 'tride.dart';
import 'kara.dart';
import 'chto.dart';


void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MaterialApp(
      home: ExampleStaggeredAnimations(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  String str = "fdhfhdhfhdf";
  // final _formKey = GlobalKey<FormState>();

  void _getRequest(str) {
    setState(() {
      http.get(Uri.parse('http://iocontrol.ru/api/sendData/kakhochu/b/$str')).then((response) {
        print("Response status: ${response.statusCode}");
        print("Response body: ${response.body}");
      }).catchError((error){
        print("Error: $error");
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              onChanged: (value) => str = value,
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  print(str);
                  _getRequest(str);
                });
              },
              icon: const Icon(
                Icons.arrow_forward,
                color:  Color.fromARGB(255, 102, 102, 102),
                size: 300,
                
              ),
            )
          ],
        ),
      ),
    );
  }
}
class MyHomePage2 extends StatefulWidget {
  const MyHomePage2({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage2> createState() => _MyHomePageState2();
}

class _MyHomePageState2 extends State<MyHomePage2> {
  int _counter = 0;
  void _getRequest() {
    setState(() {
      http.get(Uri.parse('http://192.168.54.171:8000')).then((response) {
        print("Response status: ${response.statusCode}");
        print("Response body: ${response.body}");
        _counter = int.parse( response.body);
      }).catchError((error){
        print("Error: $error");
      });
    });
  }
  void _postRequest() {
    setState(() {
      http.post(Uri.parse('http://192.168.54.171:8000 '), body: _counter.toString()).then((response) {
        print("Response status: ${response.statusCode}");
        print("Response body: ${response.body}");
      }).catchError((error){
        print("Error: $error");
      });
    });
  }
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }
  void _decrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter--;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            TextField(
              onChanged: (value) {
                _counter = int.parse(value);
              },
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _postRequest();
                });
              },
              icon: const Icon(
                Icons.arrow_forward,
                color:  Color.fromARGB(255, 102, 102, 102),
                size: 100,
                
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _getRequest();
                  _decrementCounter;
                  _incrementCounter;
                });
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
              ),
          ],
        ),
      ),
    );
  }
}







class ExampleStaggeredAnimations extends StatefulWidget {
  const ExampleStaggeredAnimations({
    super.key,
  });

  @override
  State<ExampleStaggeredAnimations> createState() =>
      _ExampleStaggeredAnimationsState();
}

class _ExampleStaggeredAnimationsState extends State<ExampleStaggeredAnimations>
    with SingleTickerProviderStateMixin {
  late AnimationController _drawerSlideController;

  @override
  void initState() {
    super.initState();

    _drawerSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  @override
  void dispose() {
    _drawerSlideController.dispose();
    super.dispose();
  }

  bool _isDrawerOpen() {
    return _drawerSlideController.value == 1.0;
  }

  bool _isDrawerOpening() {
    return _drawerSlideController.status == AnimationStatus.forward;
  }

  bool _isDrawerClosed() {
    return _drawerSlideController.value == 0.0;
  }

  void _toggleDrawer() {
    if (_isDrawerOpen() || _isDrawerOpening()) {
      _drawerSlideController.reverse();
    } else {
      _drawerSlideController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          _buildContent(),
          _buildDrawer(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Flutter Menu',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      actions: [
        AnimatedBuilder(
          animation: _drawerSlideController,
          builder: (context, child) {
            return IconButton(
              onPressed: _toggleDrawer,
              icon: _isDrawerOpen() || _isDrawerOpening()
                  ? const Icon(
                      Icons.clear,
                      color: Colors.black,
                    )
                  : const Icon(
                      Icons.menu,
                      color: Colors.black,
                    ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildContent() {
    // Put page content here.
    return const SizedBox();
  }

  Widget _buildDrawer() {
    return AnimatedBuilder(
      animation: _drawerSlideController,
      builder: (context, child) {
        return FractionalTranslation(
          translation: Offset(1.0 - _drawerSlideController.value, 0.0),
          child: _isDrawerClosed() ? const SizedBox() : const Menu(),
        );
      },
    );
  }
}

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> with SingleTickerProviderStateMixin {
  static const _menuTitles = [
    'Lab 2',
    'Lab 3',
    'Animation',
    'MQTT',
    'RK1',
    'FLYMYSQL',
    'WebSockets',
    'Kaka',
    'Mail',
    'Lovers',
    'Tride',
    'Kara',
    "Метод А.А. Караццубы (Dart)"
  ];

  static const _initialDelayTime = Duration(milliseconds: 50);
  static const _itemSlideTime = Duration(milliseconds: 250);
  static const _staggerTime = Duration(milliseconds: 50);
  static const _buttonDelayTime = Duration(milliseconds: 150);
  static const _buttonTime = Duration(milliseconds: 500);
  final _animationDuration = _initialDelayTime +
      (_staggerTime * _menuTitles.length) +
      _buttonDelayTime +
      _buttonTime;

  late AnimationController _staggeredController;
  final List<Interval> _itemSlideIntervals = [];
  // late Interval _buttonInterval;

  @override
  void initState() {
    super.initState();

    _createAnimationIntervals();

    _staggeredController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    )..forward();
  }

  void _createAnimationIntervals() {
    for (var i = 0; i < _menuTitles.length; ++i) {
      final startTime = _initialDelayTime + (_staggerTime * i);
      final endTime = startTime + _itemSlideTime;
      _itemSlideIntervals.add(
        Interval(
          startTime.inMilliseconds / _animationDuration.inMilliseconds,
          endTime.inMilliseconds / _animationDuration.inMilliseconds,
        ),
      );
    }

    // final buttonStartTime =
    //     Duration(milliseconds: (_menuTitles.length * 50)) + _buttonDelayTime;
    // final buttonEndTime = buttonStartTime + _buttonTime;
    // _buttonInterval = Interval(
    //   buttonStartTime.inMilliseconds / _animationDuration.inMilliseconds,
    //   buttonEndTime.inMilliseconds / _animationDuration.inMilliseconds,
    // );
  }

  @override
  void dispose() {
    _staggeredController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildFlutterLogo(),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildFlutterLogo() {
    return const Positioned(
      right: -100,
      bottom: -30,
      child: Opacity(
        opacity: 0.2,
        child: FlutterLogo(
          size: 400,
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            ..._buildListItems(),
          ],
        )
      )
    );
  }

  List<Widget> _buildListItems() {
    final listItems = <Widget>[];
    for (var i = 0; i < _menuTitles.length; ++i) {
      listItems.add(
        AnimatedBuilder(
          animation: _staggeredController,
          builder: (context, child) {
            final animationPercent = Curves.easeOut.transform(
              _itemSlideIntervals[i].transform(_staggeredController.value),
            );
            final opacity = animationPercent;
            final slideDistance = (1.0 - animationPercent) * 150;

            return Opacity(
              opacity: opacity,
              child: Transform.translate(
                offset: Offset(slideDistance, 0),
                child: child,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
            child: GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => 
                      i == 0 ? const MyHomePage(title: 'lab2') : 
                      i == 1 ? const MyHomePage2(title: 'lab3'): 
                      i == 2 ? const AnglePainter(title: 'anime') :
                      i == 3 ? MyForm(title: 'mqtt',) :
                      i == 4 ? MyForm1(title: 'rk') :
                      i == 5 ? const MyForm3(title: 'FLY MYSQL') : 
                      i == 6 ? const MyWebs(title: 'Websoc') :
                      i == 7 ? const MyKak(title: 'YSS.SU') :
                      i == 8 ? const Hohoho(title: 'NE.YSS.SU') : 
                      i == 9 ? const Lovers(title: 'Lovers') :
                      i == 10 ? const Tride(title: 'Tride') :
                      i == 11 ? const MyForm2000(title: "Метод А.А. Караццубы (Dart)"):
                      const Chto(title: "Метод А.А. Караццубы (Dart)")
                    // i == 0 ? const MyHomePage(title: 'lab2') : i == 1 ? const MyHomePage2(title: 'lab3'): i == 2 ? const AnglePainter(title: 'anime') : i == 3 ? MyForm(title: 'mqtt',) : MyForm1(title: 'rk')
                  )
                );
              },
              child: Text(
              _menuTitles[i],
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            )
            
          ),
        ),
      );
    }
    return listItems;
  }
}