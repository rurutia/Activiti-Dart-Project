//client side code
library activiti_dart_client;

import "dart:html";
import "dart:json" as Json;
import "dart:uri";
import "dart:async";
import "package:json_object/json_object.dart";

part "controller.dart";
part "view.dart";

AppController _app;
AppController get app => _app;

void main() {
  _app = new AppController();
  app.setup_ui();
  app.load_initial_data();  
}


