// render view by processing jason response from server
part of activiti_dart_client;

class AppViewRenderer {

  // contains client side variables
  AppController _controller;
  
  AppController get controller => _controller;
  set controller(controller) => this._controller = controller;
  
  AppViewRenderer(this._controller) {
  }


} // class