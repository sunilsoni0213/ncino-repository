<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CT_Date_Completed_Today</fullName>
        <field>Date_Completed__c</field>
        <formula>Now()</formula>
        <name>CT - Date Completed = Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CT_Percentage_Complete_100</fullName>
        <field>Percent_Complete__c</field>
        <literalValue>100 %</literalValue>
        <name>CT - Percentage Complete = 100</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CT_Status_Complete</fullName>
        <description>Automatically update the Config Status to Complete</description>
        <field>Config_Status__c</field>
        <literalValue>Complete</literalValue>
        <name>CT - Status = Complete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Config Task Complete</fullName>
        <actions>
            <name>CT_Date_Completed_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CT_Percentage_Complete_100</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CT_Status_Complete</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Automatically updates the Date Completed field to today, sets the Percent Complete field to 100% and sets the Config Status to Complete</description>
        <formula>Task_Complete__c = True</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>