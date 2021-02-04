<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>45 - Set External Sharing</label>
    <protected>false</protected>
    <values>
        <field>Active__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>AutomationClass__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>ModalPath__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>StepDependsOn__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>StepDescription__c</field>
        <value xsi:type="xsd:string">1. Click the Hyperlink in the right corner.
2. Navigate to new tab
3. Click Edit
4. Click Chrome Extension (link below if you don&apos;t have it)
5. Click Save
6. Navigate back to Demo Setup tab.


https://chrome.google.com/webstore/detail/nsharingsettings/ghbiokfhaljlpakanmfmfefabbbolkam



***MANUAL STEPS IF YOU DON&apos;T HAVE THE CHROME EXTENSION***
1. Go to Setup &gt; Security &gt; Sharing Settings
2. Click Edit in the Organization-Wide Defaults section
3. Under &quot;Default External Access&quot; set these objects to &quot;Public Read Only&quot;:
--- Answer
--- Brand
--- Closing Checklist
--- Collateral Type
--- Connection Role
--- DocManager
--- DocTab
--- DocType
--- Field Configuration
--- Field Map
--- Funding Method Type
--- ID Document Type
--- Institution
--- Language 
--- Layout 
--- Options
--- Option Rule
--- Ownership Structure Type
--- Product Collateral Type
--- Product Connection
--- Product Line
--- Questions
--- Route (Both ROUTE selections)
--- Route Terms (nCinoForce.com Framework) 
--- Route Tile(nCinoForce.com Framework) 
--- Screen (nCinoForce.com Framework) 
--- Tile(nCinoForce.com Framework)
--- Translations
4.  Click Save</value>
    </values>
    <values>
        <field>StepHyperlink__c</field>
        <value xsi:type="xsd:string">/p/own/OrgSharingDetail</value>
    </values>
    <values>
        <field>StepNumber__c</field>
        <value xsi:type="xsd:double">45.0</value>
    </values>
    <values>
        <field>StepTitle__c</field>
        <value xsi:type="xsd:string">Set External Sharing</value>
    </values>
    <values>
        <field>StepType__c</field>
        <value xsi:type="xsd:string">Manual-Confirm</value>
    </values>
</CustomMetadata>
