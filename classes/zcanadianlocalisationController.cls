public class zcanadianlocalisationController {
    public String errorMsg {get;set;}
    
    public void executeFlow1() {
        try{
            Map<String, Object> params = new Map<String, Object>();
            Flow.Interview.ZCanada canadianUpdate = new Flow.Interview.ZCanada(params);
            canadianUpdate.start();
        } catch(Exception ex) {
            errorMsg = ex.getMessage();
        }
    }

}