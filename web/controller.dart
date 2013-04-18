// register client events and dispatch server response to view renderer
part of activiti_dart_client;

// application controller
class AppController {
    
  // ui renderer
  AppViewRenderer _view;
   
  AppController() {
  	_view = new AppViewRenderer(this);
  }
    
  // setup initial ui
  void setup_ui() {
         
  }
  
  // initial data load from server
  void load_initial_data() {
    ButtonElement test1Btn = document.query("#add");
    test1Btn.onClick.listen((e) {
        String url = "/restapi1-process-engine";

        var request = new HttpRequest();
        request.open('GET', url);
        request.onLoadEnd.first.then((ProgressEvent e) => window.alert(request.responseText)); 
        request.send();

    });
  }

    	
} // class

