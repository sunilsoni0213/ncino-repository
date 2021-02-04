/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class RuleEngine {
    global RuleEngine() {

    }
    @InvocableMethod(label='Rule Engine Rule' description='Run a Rule Engine Rule.')
    global static List<nFORCE.RuleEngine.OutPutParameters> runRuleInvocableAction(List<nFORCE.RuleEngine.InputParameters> requests) {
        return null;
    }
    webService static nFORCE.RuleEngine.OutPutParameters runRuleWebService(nFORCE.RuleEngine.InputParameters request) {
        return null;
    }
global class InputParameters {
    @InvocableVariable(label='Boolean Input 1 - Name' description='The name for boolean input 1.' required=false)
    global String boolean1Name;
    @InvocableVariable(label='Boolean Input 1 - Value' description='The value of boolean input 1.' required=false)
    global Boolean boolean1Value;
    @InvocableVariable(label='Boolean Input 2 - Name' description='The name of boolean input 2.' required=false)
    global String boolean2Name;
    @InvocableVariable(label='Boolean Input 2 - Value' description='The value of boolean input 2.' required=false)
    global Boolean boolean2Value;
    @InvocableVariable(label='Boolean Input 3 - Name' description='The name of boolean input 3.' required=false)
    global String boolean3Name;
    @InvocableVariable(label='Boolean Input 3 - Value' description='The value of boolean input 3.' required=false)
    global Boolean boolean3Value;
    @InvocableVariable(label='Boolean Input 4 - Name' description='The name of boolean input 4.' required=false)
    global String boolean4Name;
    @InvocableVariable(label='Boolean Input 4 - Value' description='The value of boolean input 4.' required=false)
    global Boolean boolean4Value;
    @InvocableVariable(label='Boolean Input 5 - Name' description='The name of boolean input 5.' required=false)
    global String boolean5Name;
    @InvocableVariable(label='Boolean Input 5 - Value' description='The value of boolean input 5.' required=false)
    global Boolean boolean5Value;
    @InvocableVariable(label='Number Input 1 - Name' description='The name for number input 1.' required=false)
    global String number1Name;
    @InvocableVariable(label='Number Input 1 - Value' description='The value of number input 1.' required=false)
    global Double number1Value;
    @InvocableVariable(label='Number Input 2 - Name' description='The name of number input 2.' required=false)
    global String number2Name;
    @InvocableVariable(label='Number Input 2 - Value' description='The value of number input 2.' required=false)
    global Double number2Value;
    @InvocableVariable(label='Number Input 3 - Name' description='The name of number input 3.' required=false)
    global String number3Name;
    @InvocableVariable(label='Number Input 3 - Value' description='The value of number input 3.' required=false)
    global Double number3Value;
    @InvocableVariable(label='Number Input 4 - Name' description='The name of number input 4.' required=false)
    global String number4Name;
    @InvocableVariable(label='Number Input 4 - Value' description='The value of number input 4.' required=false)
    global Double number4Value;
    @InvocableVariable(label='Number Input 5 - Name' description='The name of number input 5.' required=false)
    global String number5Name;
    @InvocableVariable(label='Number Input 5 - Value' description='The value of number input 5.' required=false)
    global Double number5Value;
    @InvocableVariable(label='Number Collection Input 1 - Name' description='The name for number collection input 1.' required=false)
    global String numberCollection1Name;
    @InvocableVariable(label='Number Collection Input 1 - Value' description='The value of number collection input 1.' required=false)
    global List<Double> numberCollection1Value;
    @InvocableVariable(label='Number Collection Input 2 - Name' description='The name of number collection input 2.' required=false)
    global String numberCollection2Name;
    @InvocableVariable(label='Number Collection Input 2 - Value' description='The value of number collection input 2.' required=false)
    global List<Double> numberCollection2Value;
    @InvocableVariable(label='Number Collection Input 3 - Name' description='The name of number collection input 3.' required=false)
    global String numberCollection3Name;
    @InvocableVariable(label='Number Collection Input 3 - Value' description='The value of number collection input 3.' required=false)
    global List<Double> numberCollection3Value;
    @InvocableVariable(label='Number Collection Input 4 - Name' description='The name of number collection input 4.' required=false)
    global String numberCollection4Name;
    @InvocableVariable(label='Number Collection Input 4 - Value' description='The value of number collection input 4.' required=false)
    global List<Double> numberCollection4Value;
    @InvocableVariable(label='Number Collection Input 5 - Name' description='The name of number collection input 5.' required=false)
    global String numberCollection5Name;
    @InvocableVariable(label='Number Collection Input 5 - Value' description='The value of number collection input 5.' required=false)
    global List<Double> numberCollection5Value;
    @InvocableVariable(label='Internal Rule Name' description='The internal name of the Rule to run.' required=true)
    global String ruleName;
    @InvocableVariable(label='Text Input 1 - Name' description='The name for text input 1.' required=false)
    global String text1Name;
    @InvocableVariable(label='Text Input 1 - Value' description='The value of text input 1.' required=false)
    global String text1Value;
    @InvocableVariable(label='Text Input 2 - Name' description='The name of text input 2.' required=false)
    global String text2Name;
    @InvocableVariable(label='Text Input 2 - Value' description='The value of text input 2.' required=false)
    global String text2Value;
    @InvocableVariable(label='Text Input 3 - Name' description='The name of text input 3.' required=false)
    global String text3Name;
    @InvocableVariable(label='Text Input 3 - Value' description='The value of text input 3.' required=false)
    global String text3Value;
    @InvocableVariable(label='Text Input 4 - Name' description='The name of text input 4.' required=false)
    global String text4Name;
    @InvocableVariable(label='Text Input 4 - Value' description='The value of text input 4.' required=false)
    global String text4Value;
    @InvocableVariable(label='Text Input 5 - Name' description='The name of text input 5.' required=false)
    global String text5Name;
    @InvocableVariable(label='Text Input 5 - Value' description='The value of text input 5.' required=false)
    global String text5Value;
    @InvocableVariable(label='Text Collection Input 1 - Name' description='The name for text collection input 1.' required=false)
    global String textCollection1Name;
    @InvocableVariable(label='Text Collection Input 1 - Value' description='The value of text collection input 1.' required=false)
    global List<String> textCollection1Value;
    @InvocableVariable(label='Text Collection Input 2 - Name' description='The name of text collection input 2.' required=false)
    global String textCollection2Name;
    @InvocableVariable(label='Text Collection Input 2 - Value' description='The value of text collection input 2.' required=false)
    global List<String> textCollection2Value;
    @InvocableVariable(label='Text Collection Input 3 - Name' description='The name of text collection input 3.' required=false)
    global String textCollection3Name;
    @InvocableVariable(label='Text Collection Input 3 - Value' description='The value of text collection input 3.' required=false)
    global List<String> textCollection3Value;
    @InvocableVariable(label='Text Collection Input 4 - Name' description='The name of text collection input 4.' required=false)
    global String textCollection4Name;
    @InvocableVariable(label='Text Collection Input 4 - Value' description='The value of text collection input 4.' required=false)
    global List<String> textCollection4Value;
    @InvocableVariable(label='Text Collection Input 5 - Name' description='The name of text collection input 5.' required=false)
    global String textCollection5Name;
    @InvocableVariable(label='Text Collection Input 5 - Value' description='The value of text collection input 5.' required=false)
    global List<String> textCollection5Value;
    global InputParameters() {

    }
}
global class OutPutParameters {
    @InvocableVariable(label='Boolean Input 1 - Name' description='The name for boolean input 1.' required=false)
    global String boolean1Name;
    @InvocableVariable(label='Boolean Input 1 - Value' description='The value of boolean input 1.' required=false)
    global Boolean boolean1Value;
    @InvocableVariable(label='Boolean Input 2 - Name' description='The name of boolean input 2.' required=false)
    global String boolean2Name;
    @InvocableVariable(label='Boolean Input 2 - Value' description='The value of boolean input 2.' required=false)
    global Boolean boolean2Value;
    @InvocableVariable(label='Boolean Input 3 - Name' description='The name of boolean input 3.' required=false)
    global String boolean3Name;
    @InvocableVariable(label='Boolean Input 3 - Value' description='The value of boolean input 3.' required=false)
    global Boolean boolean3Value;
    @InvocableVariable(label='Boolean Input 4 - Name' description='The name of boolean input 4.' required=false)
    global String boolean4Name;
    @InvocableVariable(label='Boolean Input 4 - Value' description='The value of boolean input 4.' required=false)
    global Boolean boolean4Value;
    @InvocableVariable(label='Boolean Input 5 - Name' description='The name of boolean input 5.' required=false)
    global String boolean5Name;
    @InvocableVariable(label='Boolean Input 5 - Value' description='The value of boolean input 5.' required=false)
    global Boolean boolean5Value;
    @InvocableVariable(label='Execution Error' description='The errors returned by the Rule' required=false)
    global List<String> errors;
    @InvocableVariable(label='Number Input 1 - Name' description='The name for number input 1.' required=false)
    global String number1Name;
    @InvocableVariable(label='Number Input 1 - Value' description='The value of number input 1.' required=false)
    global Double number1Value;
    @InvocableVariable(label='Number Input 2 - Name' description='The name of number input 2.' required=false)
    global String number2Name;
    @InvocableVariable(label='Number Input 2 - Value' description='The value of number input 2.' required=false)
    global Double number2Value;
    @InvocableVariable(label='Number Input 3 - Name' description='The name of number input 3.' required=false)
    global String number3Name;
    @InvocableVariable(label='Number Input 3 - Value' description='The value of number input 3.' required=false)
    global Double number3Value;
    @InvocableVariable(label='Number Input 4 - Name' description='The name of number input 4.' required=false)
    global String number4Name;
    @InvocableVariable(label='Number Input 4 - Value' description='The value of number input 4.' required=false)
    global Double number4Value;
    @InvocableVariable(label='Number Input 5 - Name' description='The name of number input 5.' required=false)
    global String number5Name;
    @InvocableVariable(label='Number Input 5 - Value' description='The value of number input 5.' required=false)
    global Double number5Value;
    @InvocableVariable(label='Number Collection Input 1 - Name' description='The name for number collection input 1.' required=false)
    global String numberCollection1Name;
    @InvocableVariable(label='Number Collection Input 1 - Value' description='The value of number collection input 1.' required=false)
    global List<Double> numberCollection1Value;
    @InvocableVariable(label='Number Collection Input 2 - Name' description='The name of number collection input 2.' required=false)
    global String numberCollection2Name;
    @InvocableVariable(label='Number Collection Input 2 - Value' description='The value of number collection input 2.' required=false)
    global List<Double> numberCollection2Value;
    @InvocableVariable(label='Number Collection Input 3 - Name' description='The name of number collection input 3.' required=false)
    global String numberCollection3Name;
    @InvocableVariable(label='Number Collection Input 3 - Value' description='The value of number collection input 3.' required=false)
    global List<Double> numberCollection3Value;
    @InvocableVariable(label='Number Collection Input 4 - Name' description='The name of number collection input 4.' required=false)
    global String numberCollection4Name;
    @InvocableVariable(label='Number Collection Input 4 - Value' description='The value of number collection input 4.' required=false)
    global List<Double> numberCollection4Value;
    @InvocableVariable(label='Number Collection Input 5 - Name' description='The name of number collection input 5.' required=false)
    global String numberCollection5Name;
    @InvocableVariable(label='Number Collection Input 5 - Value' description='The value of number collection input 5.' required=false)
    global List<Double> numberCollection5Value;
    @InvocableVariable(label='Execution Status' description='The status of the rule that was run.' required=false)
    global String status;
    @InvocableVariable(label='Text Input 1 - Name' description='The name for text input 1.' required=false)
    global String text1Name;
    @InvocableVariable(label='Text Input 1 - Value' description='The value of text input 1.' required=false)
    global String text1Value;
    @InvocableVariable(label='Text Input 2 - Name' description='The name of text input 2.' required=false)
    global String text2Name;
    @InvocableVariable(label='Text Input 2 - Value' description='The value of text input 2.' required=false)
    global String text2Value;
    @InvocableVariable(label='Text Input 3 - Name' description='The name of text input 3.' required=false)
    global String text3Name;
    @InvocableVariable(label='Text Input 3 - Value' description='The value of text input 3.' required=false)
    global String text3Value;
    @InvocableVariable(label='Text Input 4 - Name' description='The name of text input 4.' required=false)
    global String text4Name;
    @InvocableVariable(label='Text Input 4 - Value' description='The value of text input 4.' required=false)
    global String text4Value;
    @InvocableVariable(label='Text Input 5 - Name' description='The name of text input 5.' required=false)
    global String text5Name;
    @InvocableVariable(label='Text Input 5 - Value' description='The value of text input 5.' required=false)
    global String text5Value;
    @InvocableVariable(label='Text Collection Input 1 - Name' description='The name for text collection input 1.' required=false)
    global String textCollection1Name;
    @InvocableVariable(label='Text Collection Input 1 - Value' description='The value of text collection input 1.' required=false)
    global List<String> textCollection1Value;
    @InvocableVariable(label='Text Collection Input 2 - Name' description='The name of text collection input 2.' required=false)
    global String textCollection2Name;
    @InvocableVariable(label='Text Collection Input 2 - Value' description='The value of text collection input 2.' required=false)
    global List<String> textCollection2Value;
    @InvocableVariable(label='Text Collection Input 3 - Name' description='The name of text collection input 3.' required=false)
    global String textCollection3Name;
    @InvocableVariable(label='Text Collection Input 3 - Value' description='The value of text collection input 3.' required=false)
    global List<String> textCollection3Value;
    @InvocableVariable(label='Text Collection Input 4 - Name' description='The name of text collection input 4.' required=false)
    global String textCollection4Name;
    @InvocableVariable(label='Text Collection Input 4 - Value' description='The value of text collection input 4.' required=false)
    global List<String> textCollection4Value;
    @InvocableVariable(label='Text Collection Input 5 - Name' description='The name of text collection input 5.' required=false)
    global String textCollection5Name;
    @InvocableVariable(label='Text Collection Input 5 - Value' description='The value of text collection input 5.' required=false)
    global List<String> textCollection5Value;
    global OutPutParameters() {

    }
}
}
