import 'dart:io' show HttpServer, HttpRequest, WebSocket, WebSocketTransformer, File;
import 'dart:convert' show json;
import 'dart:async' show Timer;

main() {
   HttpServer.bind('192.168.141.1', 8000).then((HttpServer server) {
    print('[+]WebSocket listening at -- ws://192.168.141.1:8000/');
     server.listen((HttpRequest request) {
       WebSocketTransformer.upgrade(request).then((WebSocket ws) {
        ws.listen(
          (data) async{
            print(data);
            if (json.decode(data)["method"] == "send") {
              print(
                  '\t\t${request.connectionInfo?.remoteAddress} -- ${Map<String, String>.from(json.decode(data))}');
              File file = File("bd.txt");
              file.writeAsString(json.decode(data)["data"]);
            } else if (json.decode(data)["method"] == "get"){
              File file = File("bd.txt");
              String a = await file.readAsString();
              print(a);
              Timer(Duration(seconds: 1), () {
                if (ws.readyState == WebSocket.open)
                  ws.add(a);
              });
            }
          },
          onDone: () => print('[+]Done :)'),
          onError: (err) => print('[!]Error -- ${err.toString()}'),
          cancelOnError: true,
        );
      }, onError: (err) => print('[!]Error -- ${err.toString()}'));
    }, onError: (err) => print('[!]Error -- ${err.toString()}'));
  }, onError: (err) => print('[!]Error -- ${err.toString()}'));
}