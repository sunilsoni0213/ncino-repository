<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>10 - Remove Managed Licenses</label>
    <protected>false</protected>
    <values>
        <field>Active__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>AutomationClass__c</field>
        <value xsi:type="xsd:string">ConfigRemoveLicenseStep</value>
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
        <value xsi:type="xsd:string">***MANUAL STEPS IF AUTO STEP DOESN&apos;T RUN***
1. Go to Setup &gt; Installed Packages 
2. Locate the &quot;nCino Platform&quot; package and click &quot;Manage Licenses&quot;
3. Click &quot;Remove&quot; for any SE users who are not a part of this demo org.</value>
    </values>
    <values>
        <field>StepHyperlink__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>StepNumber__c</field>
        <value xsi:type="xsd:double">10.0</value>
    </values>
    <values>
        <field>StepTitle__c</field>
        <value xsi:type="xsd:string">Remove Managed Licenses from SE Accounts</value>
    </values>
    <values>
        <field>StepType__c</field>
        <value xsi:type="xsd:string">Automatic</value>
    </values>
</CustomMetadata>
