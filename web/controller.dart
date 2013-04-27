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
    
    // prefill request data for demonstration only, to be removed in production mode
    ButtonElement testRestBodyBtn = document.query("#testRestBodyBtn");
    testRestBodyBtn.onClick.listen( (e) {
      TextAreaElement requestBodyElement = document.query("#rest-body");
      requestBodyElement.value = requestBodyElement.placeholder; 
    });
    ButtonElement testAuthenticationBtn = document.query("#testAuthenticationBtn");
    testAuthenticationBtn.onClick.listen( (e)  {
      InputElement usernameElement = document.query("#username");
      InputElement passwordElement = document.query("#password");
      usernameElement.value = passwordElement.value = 'kermit';
    });
    
    
  }
  
  // initial data load from server
  void load_initial_data() {
    ButtonElement sendBtn = document.query("#send");
    sendBtn.onClick.listen((e) {
      SelectElement restURLElement = document.query("#rest-url");
      SelectElement requestMethodElement = document.query("#request-method");
      InputElement usernameElement = document.query("#username");
      InputElement passwordElement = document.query("#password");
      TextAreaElement requestBodyElement = document.query("#rest-body");
      
      String param = restURLElement.value.trim();           
      String requestMethod = requestMethodElement.value;      
      String requestBody = requestBodyElement.value;
      try {
        Json.parse(requestBody);
      } on FormatException catch(e) {
        requestBody = '{}';
      }
      
      String url = "/getRestService";
      document.query("#loadAnimation").classes.toggle("isHidden");
      document.query("#loadAnimation").classes.toggle("isShown");
      
      var request = new HttpRequest();
      
      request.open('POST', url);
      // request in json format
      String data = '''{
                      "resturl": "$param", 
                      "method": "$requestMethod",
                      "authentication": {"username":"${usernameElement.value}", "password":"${passwordElement.value}"},
                      "body":$requestBody }               
                    ''';
      
      request.setRequestHeader('Content-Type', 'application/json');
      request.setRequestHeader('Accept', 'application/json');
      
      request.onLoadEnd.first.then((ProgressEvent e) {
        var duration = new Duration(seconds: 2);
        new Timer(duration, handleTimeout);
       
      });
      
      request.send(data);
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

