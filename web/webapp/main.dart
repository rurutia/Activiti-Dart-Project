// Server side code
library activiti_dart;

import "dart:json" as Json;
import "dart:io";
import "dart:uri";
import "dart:async";
import 'package:stream/stream.dart';
import "package:xml/xml.dart";
import 'package:rikulo_commons/io.dart';

part "config.dart";

void main() {
  var host = '0.0.0.0';
  var port = 8081;
  new StreamServer(uriMapping: _mapping)
  ..host = host
  ..port = port
  ..start();
}

void process_engine(HttpConnect connect) {
  String jsonResponse = "";
  
  String url = "http://localhost:8080/activiti-rest/service/process-engine";
  HttpClient client = new HttpClient();
  var requestUri = new Uri.fromString(url);
  
  var conn = client.getUrl(requestUri);
  
  conn.then ((HttpClientRequest request) {
    request.headers.add(HttpHeaders.CONTENT_TYPE, "application/json");
    request.headers.add("Authorization", "Basic a2VybWl0Omtlcm1pdA==");
    request.close(); 
        
    request.response.then( (HttpClientResponse response) {
            StringBuffer sb = new StringBuffer();
            sb.writeln("response code: ${response.statusCode.toString()}");
            IOUtil.readAsString(response, onError: null).then((body) {         
              sb.writeln('response body is: ' + body);
              client.close();
              jsonResponse = sb.toString();
              sendResponse(connect, jsonResponse);
            });
     });     
  });

}

void sendResponse(HttpConnect connect, String response, {String type:"json"}) {
  connect.response
    ..headers.contentType = contentTypes[type]
    ..write(response);
  connect.close();
}

