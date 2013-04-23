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
 String url = connect.request.queryParameters['resturl'];
 Future<String>  result = getResponse(url);
 
 result.then( (json) {
      print(json);
 });
 
}

Future<String> getResponse(String url) {

  Completer<String> jsonContent = new Completer<String>();
  HttpClient client = new HttpClient();
  var requestUri = new Uri.fromString(url);
  
  var conn = client.getUrl(requestUri);

  conn.then ((HttpClientRequest request) {
  
    request.headers.add(HttpHeaders.CONTENT_TYPE, Constants.CONTENT_TYPE_JSON);
    request.headers.add("Authorization", Constants.CREDENTIAL_KERMIT);
    request.close(); 
        
    request.done.then( (HttpClientResponse response) {
            StringBuffer sb = new StringBuffer();

            sb.writeln("response code: ${response.statusCode.toString()}");
            IOUtil.readAsString(response, onError: null).then((body) {         
              sb.writeln("<br>response body is : $body");
              var jsonBody = new JsonObject.fromJsonString(body);
              file.writeAsString(sb.toString()).then((value) {
                jsonContent.complete(sb.toString());
              });
               client.close();
            });

            
     }); // HttpClient request    
  }); // HttpClient connection

   return jsonContent.future;
}

void show_result(HttpConnect connect) {
  String result = file.readAsStringSync();
  
  sendResponse(connect, result);
  
}

void sendResponse(HttpConnect connect, String response, {String type:"json"}) {
  connect.response
    ..write(response);
}

