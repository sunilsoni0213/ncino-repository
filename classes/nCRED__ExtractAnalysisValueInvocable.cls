/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ExtractAnalysisValueInvocable {
    global ExtractAnalysisValueInvocable() {

    }
    @InvocableMethod(label='Extract Analysis Value' description='Used in a flow or process to extract a value from spreads')
    global static List<nCRED.ExtractAnalysisValueInvocable.ExtractAnalysisValueResult> getValueByPeriodKey(List<nCRED.ExtractAnalysisValueInvocable.ExtractAnalysisValueParameters> extractedParametersList) {
        return null;
    }
global class ExtractAnalysisValueParameters {
    @InvocableVariable(label='Classification Lookup Keys' description='Name of the classification keys to extract values from.' required=true)
    global String classificationLookupKeys;
    @InvocableVariable(label='Context Id' description='Context Id of the Account or Collateral.' required=true)
    global Id contextId;
    @InvocableVariable(label='Period Key' description='Period Key of the Spreads Period.' required=true)
    global String periodKey;
    global ExtractAnalysisValueParameters() {

    }
}
global class ExtractAnalysisValueResult {
    @InvocableVariable( required=false)
    global String classificationLookupKey;
    @InvocableVariable( required=false)
    global Id contextId;
    @InvocableVariable( required=false)
    global String periodKey;
    @InvocableVariable( required=false)
    global Double sum;
    global ExtractAnalysisValueResult() {

    }
}
}
