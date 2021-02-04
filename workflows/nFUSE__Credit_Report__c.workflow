<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>nFUSE__Update_Date</fullName>
        <description>Update the Credit Score Date to match the most recently run Credit Report</description>
        <field>LLC_BI__FICO_Date__c</field>
        <formula>CreatedDate</formula>
        <name>Update Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>true</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>nFUSE__Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>nFUSE__Update_Reference</fullName>
        <description>This updates the ID of the FICO score on Account</description>
        <field>LLC_BI__FICO_Credit_Report__c</field>
        <formula>Id</formula>
        <name>Update Reference</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>true</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>nFUSE__Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>nFUSE__Update_Score</fullName>
        <description>This updates the FICO score on Account</description>
        <field>LLC_BI__FICO_Score__c</field>
        <formula>nFUSE__Credit_Score__c</formula>
        <name>Update Score</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>true</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>nFUSE__Account__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>nFUSE__Credit_Score</fullName>
        <actions>
            <name>nFUSE__Update_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>nFUSE__Update_Reference</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>nFUSE__Update_Score</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>nFUSE__Credit_Report__c.nFUSE__Credit_Score__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Copy the Credit Score to the Account whenever a new Credit Report is created.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>