// Server side code
library activiti_dart;

import "dart:json" as Json;
import "dart:io";
import "dart:uri";
import "dart:async";
import "package:stream/stream.dart";
import "package:rikulo_commons/io.dart";
import "package:json_object/json_object.dart";

part "config.dart";
part "constants.dart";
part "base64String.dart";

File file;

void main() {
  var port = 8081;
//  var port = Platform.environment.containsKey('PORT') ? int.parse(Platform.environment['PORT']) : 8080;
  var host = '0.0.0.0';


  new StreamServer(uriMapping: _mapping)
  ..host = host
  ..port = port
  ..start();
  
  file = new File("web/webapp/data.txt");
}

void getRestService(HttpConnect connect) {
  var request = connect.request;
  var stream = request.transform(new StringDecoder());
  
  stream.listen((value){
    Map data = Json.parse(value);
    String method = data['method'];
    String url = data['resturl'];
    Map authentication = data['authentication'];
    Map body = data['body'];

    Future<String>  result = getResponse(method, url, authentication, body.toString());
    
//    result.then( (json) {
//      print(json);
//    });
    
  });

 
}

Future<String> getResponse(String method, String url, Map authentication, String body) {
  Completer<String> jsonContent = new Completer<String>();
  HttpClient client = new HttpClient();
  var requestUri = new Uri.fromString(url);
  
  var conn = client.openUrl(method, requestUri);

  conn.then ((HttpClientRequest request) {
    request.headers.add(HttpHeaders.CONTENT_TYPE, Constants.CONTENT_TYPE_JSON);
    // Add base64 authentication header
    String base64 = Base64String.encode('${authentication["username"]}:${authentication["password"]}');
    base64 = 'Basic $base64';
    print(base64);
    request.headers.add("Authorization",  base64);
    
    switch( method ) {
      case Constants.METHOD_GET: break;
      case Constants.METHOD_POST: 
        body = body.replaceAllMapped(new RegExp(r'\b\w+\b'), replaceWordwithQuotes);
        request.write(body);
        break;
    }
    
    request.close(); 
        
    request.done.then( (HttpClientResponse response) {
            StringBuffer sb = new StringBuffer();

            sb.writeln("response code: ${response.statusCode.toString()}");
            IOUtil.readAsString(response, onError: null).then((body) {         
              sb.writeln('response body is        : ' + body);
              try {
                  var jsonBody = new JsonObject.fromJsonString(body);
              } on Exception catch(e) {
                sb.clear();
                sb.writeln(body);
              }
              file.writeAsString(sb.toString()).then((value) {
                jsonContent.complete(sb.toString());
              });
              // debug only, print response to console command line
              print(sb.toString());
               client.close();
            });

            
     }); // HttpClient request    
  }); // HttpClient connection

   return jsonContent.future;
}

String replaceWordwithQuotes(Match match) {
  String result = '"${match.group(0)}"';
  return result; 
}

void show_result(HttpConnect connect) {
  String result = file.readAsStringSync();  
  sendResponse(connect, result);  
}

void sendResponse(HttpConnect connect, String response, {String type:"json"}) {
  connect.response
    ..headers.contentType = contentTypes[type]
    ..write(response);
}

