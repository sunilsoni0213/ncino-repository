/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global interface IVendorProvider_v1 {
    String DenormalizeDocumentType(String param0);
    IDLGY.VendorRequestObject_v1 MapToVendorRequest(Map<String,Object> param0);
    String MaskData(IDLGY.DataMaskingTypeEnum param0, String param1);
    Map<String,Object> NormalizeVendorResponse(String param0);
    String PerformVendorRequest(IDLGY.VendorRequestObject_v1 param0, String param1, String param2, Integer param3, String param4, String param5);
    Map<String,Object> PostNormalizeVendorResponse(Map<String,Object> param0, Map<String,Object> param1);
    List<String> ValidateRequest(Map<String,Object> param0);
    void setLoggingProvider(EFPIO.ILoggingProvider_v1 param0);
    void setNamedCredential(String param0);
}
