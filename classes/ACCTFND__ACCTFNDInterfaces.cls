/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ACCTFNDInterfaces {
    global ACCTFNDInterfaces() {

    }
global interface IACCTFNDConfiguration {
    Map<String,String> GetAllProperties(Boolean param0);
    String GetPropertyByKey(String param0);
    String GetTranslatedKey(String param0);
    void LoadPluginConfigurations();
    void TogglePluginConfigurations(Boolean param0);
}
global interface IACCTFNDLoggingProvider_v1 {
    void Add(Object param0);
    Object GetLatest();
    void Init(String param0, Id param1);
    void Save();
    void SetLogLevelsToCapture(String param0);
}
global interface IACCTFNDProvider_v1 {
    String GenerateFundingRequest(Map<String,Object> param0);
    String GenerateMicroDepositVerificationRequest(Map<String,Object> param0);
    Map<String,String> GenerateRequestHeaders();
    List<String> NormalizeVendorFundingType(Map<String,Object> param0);
    Map<String,Object> ParseFundingResponse(String param0);
    Map<String,Object> ParseMicroDepositVerificationResponse(String param0);
    Map<String,Object> PostFundingProcessing(Map<String,Object> param0);
    Map<String,Object> PostMicroDepositVerificationProcessing(Map<String,Object> param0);
    List<String> ValidateDepositVerificationRequest(Map<String,Object> param0);
    List<String> ValidateDepositVerificationResponse(Map<String,Object> param0);
    List<String> ValidateFundingRequest(Map<String,Object> param0);
    List<String> ValidateFundingResponse(Map<String,Object> param0);
    String getNamedCredential();
    void setNamedCredential(String param0);
}
global interface IACCTFNDProvider_v2 {
    List<String> NormalizeVendorFundingType(Map<String,Object> param0);
    Map<String,Object> ParseFundingResponse(String param0);
    Map<String,Object> ParseMicroDepositVerificationResponse(String param0);
    String PerformFundingRequest(Map<String,Object> param0, String param1, String param2, Integer param3, String param4);
    String PerformVerificationRequest(Map<String,Object> param0, String param1, String param2, Integer param3, String param4);
    Map<String,Object> PostFundingProcessing(Map<String,Object> param0);
    Map<String,Object> PostMicroDepositVerificationProcessing(Map<String,Object> param0);
    List<String> ValidateDepositVerificationRequest(Map<String,Object> param0);
    List<String> ValidateDepositVerificationResponse(Map<String,Object> param0);
    List<String> ValidateFundingRequest(Map<String,Object> param0);
    List<String> ValidateFundingResponse(Map<String,Object> param0);
    String getNamedCredential();
    void setNamedCredential(String param0);
}
}
