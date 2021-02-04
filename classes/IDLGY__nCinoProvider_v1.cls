/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class nCinoProvider_v1 implements IDLGY.IVendorProvider_v1 {
    global nCinoProvider_v1() {

    }
    global virtual String DenormalizeDocumentType(String normalizedDocumentType) {
        return null;
    }
    global virtual IDLGY.VendorRequestObject_v1 MapToVendorRequest(Map<String,Object> params) {
        return null;
    }
    global virtual String MaskData(IDLGY.DataMaskingTypeEnum maskingType, String rawString) {
        return null;
    }
    global virtual Map<String,Object> NormalizeVendorResponse(String vendorResponse) {
        return null;
    }
    global virtual String PerformVendorRequest(IDLGY.VendorRequestObject_v1 normalizedVendorResponse, String verb, String endpoint, Integer timeout, String certificateName, String ucTest) {
        return null;
    }
    global virtual Map<String,Object> PostNormalizeVendorResponse(Map<String,Object> normalizedVendorResponse, Map<String,Object> params) {
        return null;
    }
    global virtual List<String> ValidateRequest(Map<String,Object> params) {
        return null;
    }
    global virtual Map<String,Object> handleVendorError(String vendorResponse) {
        return null;
    }
    global void setLoggingProvider(EFPIO.ILoggingProvider_v1 loggingProvider) {

    }
    global void setNamedCredential(String namedCredential) {

    }
}
