public class zaustralialocalisationController {
    public String errorMsg {get;set;}
    
    public void executeFlow1() {
        try{
            Map<String, Object> params = new Map<String, Object>();
            Flow.Interview.ZAustralia australianUpdate = new Flow.Interview.ZAustralia(params);
            australianUpdate.start();
        } catch(Exception ex) {
            errorMsg = ex.getMessage();
        }
    }

}