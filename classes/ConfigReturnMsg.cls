public class ConfigReturnMsg {
    @AuraEnabled
    public Boolean success;
    @AuraEnabled
    public String errorMessages;

    public ConfigReturnMsg(Boolean success, String errorMessages){
        this.success = success;
        this.errorMessages = errorMessages;
    }
}