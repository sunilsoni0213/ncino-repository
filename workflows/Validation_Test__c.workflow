<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>VT_Percentage_Complete_100</fullName>
        <description>Update the Percent Complete field to 100%</description>
        <field>Percent_Complete__c</field>
        <literalValue>100 %</literalValue>
        <name>VT - Percentage Complete = 100</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VT_Set_Date_Completed_to_Now</fullName>
        <description>Update the Validation Completed Date to Today</description>
        <field>Date_Completed__c</field>
        <formula>Now()</formula>
        <name>VT - Date Completed = Now</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VT_Status_Complete</fullName>
        <description>Update the Validation Status to Complete</description>
        <field>Validation_Status__c</field>
        <literalValue>Complete</literalValue>
        <name>VT - Status = Complete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Validation Test Complete</fullName>
        <actions>
            <name>VT_Percentage_Complete_100</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>VT_Set_Date_Completed_to_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>VT_Status_Complete</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule will automatically set the Date Completed field to today, the Completion Percentage to 100% and the Validation Status to Complete</description>
        <formula>Validation_Complete__c = True</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>