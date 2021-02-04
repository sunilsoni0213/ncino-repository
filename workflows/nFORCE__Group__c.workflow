<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_Questionnaire_Group_Record_Type</fullName>
        <description>Sets the record type to Questionnaire Group</description>
        <field>RecordTypeId</field>
        <lookupValue>Question_Group</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Questionnaire Group Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Questionnaire Group</fullName>
        <actions>
            <name>Set_Questionnaire_Group_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>nFORCE__Group__c.nFORCE__Is_Questionnaire__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Workflow rule to run when questionnaire groups are created or edited</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>