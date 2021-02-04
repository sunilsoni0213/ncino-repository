/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class GenerateDocument implements Database.AllowsCallouts, Database.Batchable<LLC_BI.GenerateDocument.DocumentRequestPhase>, Database.Stateful {
    @InvocableMethod(label='Generate Document' description='Generate PDF Document From RTF Document Template')
    global static void runRuleInvocableAction(List<LLC_BI.GenerateDocument.DocumentRequest> requests) {

    }
global class DocumentRequest {
    @InvocableVariable(label='Document Context ID' description='The ID of the object that will be used to generate the document.' required=true)
    global String contextObjectId;
    @InvocableVariable(label='Document Manager Object ID' description='The ID of the object which Document Manager should be place. If not specified the Document Manager associated with the Document Context ID will be used.' required=false)
    global String docmanContextId;
    @InvocableVariable(label='Document Manager Category' description='The name of the document category that must be associated with the Document Manager placeholder.' required=true)
    global String docType;
    @InvocableVariable(label='Document Manager Placeholder Name' description='The name of the document placeholder in Document Manager where the generated PDF will be stored.' required=true)
    global String documentPlaceholderName;
    @InvocableVariable(label='Template Document Name' description='The name of the document in the nCino Document Templates folder.' required=true)
    global String templateName;
}
}
