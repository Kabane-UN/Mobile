import 'dart:io';
import 'dart:convert' show utf8;

void main() async {
  var server = await HttpServer.bind(InternetAddress.anyIPv6, 8000);
  await server.forEach((HttpRequest request) async{
    if (request.method == 'GET') {
      File file = File("bd.txt");
      String a = await file.readAsString();
      request.response.write(a);
      print(a);
    } else {
      var b = await utf8.decodeStream(request);
      File file = File("bd.txt");
      await file.writeAsString(b);
    };
    request.response.close();
  });
}