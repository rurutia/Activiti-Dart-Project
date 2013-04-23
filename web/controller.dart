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
    ButtonElement clearBtn = document.query("#clearResultBtn");
    clearBtn.onClick.listen( (e) {
      _view.updateResult("", mode:"NEW");
    });
  }
  
  // initial data load from server
  void load_initial_data() {
    ButtonElement sendBtn = document.query("#send");
    sendBtn.onClick.listen((e) {
      SelectElement restURLElement = document.query("#rest-url");
      String param = encodeUriComponent(restURLElement.value.trim());
      String url = "/getRestService?resturl=$param";
      
      document.query("#loadAnimation").classes.toggle("isHidden");
      document.query("#loadAnimation").classes.toggle("isShown");
      
      SelectElement requestMethod = document.query("#request-method");

      var request = new HttpRequest();
      request.open(requestMethod.value, url, async: false);
      request.onLoadEnd.first.then((ProgressEvent e) {
        var duration = new Duration(seconds: 2);
        new Timer(duration, handleTimeout);
       
      });
      request.send();
      

    });    
    
  }
  
  void handleTimeout() {
    String url;
    
    var request = new HttpRequest();
    url = "/show-rest-result";
    request.open('GET', url, async: false);
    request.onLoadEnd.first.then((ProgressEvent e) { 
      var response = request.responseText;
      _view.updateResult(response);
      document.query("#loadAnimation").classes.toggle("isHidden");
      document.query("#loadAnimation").classes.toggle("isShown");
    
    }); 
    request.send();
  }

    	
} // class

