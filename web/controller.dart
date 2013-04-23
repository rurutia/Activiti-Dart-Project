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
    ButtonElement testRestBodyBtn = document.query("#testRestBodyBtn");
    testRestBodyBtn.onClick.listen( (e) {
      TextAreaElement requestBodyElement = document.query("#rest-body");
      requestBodyElement.value = requestBodyElement.placeholder; 
    });
    
    
  }
  
  // initial data load from server
  void load_initial_data() {
    ButtonElement sendBtn = document.query("#send");
    sendBtn.onClick.listen((e) {
      SelectElement restURLElement = document.query("#rest-url");
      SelectElement requestMethodElement = document.query("#request-method");
      TextAreaElement requestBodyElement = document.query("#rest-body");
      String param = encodeUriComponent(restURLElement.value.trim());
      String requestMethod = requestMethodElement.value;
      String requestBody = encodeUriComponent(requestBodyElement.value);
      String url = "/getRestService?resturl=$param&method=$requestMethod&body=$requestBody";
      
      document.query("#loadAnimation").classes.toggle("isHidden");
      document.query("#loadAnimation").classes.toggle("isShown");
      
   
      var request = new HttpRequest();
      request.open('GET', url, async: false);
      request.setRequestHeader('Content-Type', 'application/json');
      request.setRequestHeader('Accept', 'application/json');
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

