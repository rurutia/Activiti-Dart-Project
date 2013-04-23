// render view by processing jason response from server
part of activiti_dart_client;

class AppViewRenderer {

  // contains client side variables
  AppController _controller;
  
  AppController get controller => _controller;
  set controller(controller) => this._controller = controller;
  
  AppViewRenderer(this._controller) {}

  void updateResult(String message, {mode: "APPEND"}) {
    switch(mode) {
      case "APPEND":
        document.query("#result-content").appendHtml("$message<br><br>");
        break;
        
      case "NEW":
        document.query("#result-content").innerHtml = message;
        break;
    }
    
  }
  
}