/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ACCTFNDEntities {
    global ACCTFNDEntities() {

    }
global class ACCTFNDFundingInputParams {
    @InvocableVariable(label='Action' description='The intended action with the vendor. Can be either FUND or VERIFY' required=true)
    global String Action;
    @InvocableVariable(label='Input' description='List of Serialized key value pairs which will be converted downstream to Map<String,Object>, use "*NCINO* as the delimiter"' required=true)
    global List<String> Input;
    global ACCTFNDFundingInputParams() {

    }
}
global class ACCTFNDFundingOutputParams {
    @InvocableVariable(label='AmountFunded' description='Amount requested to be funded from target' required=false)
    global Double AmountFunded;
    @InvocableVariable(label='ErrorCode' description='This is the translated error code' required=false)
    global Double ErrorCode;
    @InvocableVariable(label='ErrorMessage' description='This is the translated error messaging' required=false)
    global String ErrorMessage;
    @InvocableVariable(label='IsSuccessful' description='Indicates successful interaction with vendor' required=false)
    global Boolean IsSuccessful;
    @InvocableVariable(label='VendorFundingCompleteTransId' description='Alphanumeric vendor target funding completion transaction unique id' required=false)
    global String VendorFundingCompleteTransId;
    @InvocableVariable(label='VendorFundingInitTransId' description='Alphanumeric vendor target funding initialization transaction unique id' required=false)
    global String VendorFundingInitTransId;
    @InvocableVariable(label='VendorFundingType' description='Vendor target funding type (ACH, Credit, Debit, etc)' required=false)
    global String VendorFundingType;
    @InvocableVariable(label='VendorMessage' description='This is the non-translated error messaging from the vendor' required=false)
    global String VendorMessage;
    @InvocableVariable(label='VendorStage' description='This is the nullable vendor specific stage the process is currently in (partner-approved, trial-deposit)' required=false)
    global String VendorStage;
    @InvocableVariable(label='VendorTargetId' description='Alphanumeric vendor target bank unique id' required=false)
    global String VendorTargetId;
    @InvocableVariable(label='VendorUserId' description='Alphanumeric vendor user unique id' required=false)
    global String VendorUserId;
    @InvocableVariable(label='VerificationAttemptsRemaining' description='Vendor verification attempts remaining' required=false)
    global Integer VerificationAttemptsRemaining;
    global ACCTFNDFundingOutputParams() {

    }
}
}
