<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>LLC_BI__Template_Record_Type_Update_Fee</fullName>
        <description>Update to Fee Record Type</description>
        <field>RecordTypeId</field>
        <lookupValue>LLC_BI__Fee_Management_Record_Type</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Template: Record Type Update, Fee</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>LLC_BI__Template%3A Fee Record Set</fullName>
        <actions>
            <name>LLC_BI__Template_Record_Type_Update_Fee</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LLC_BI__Template_Records__c.LLC_BI__Category__c</field>
            <operation>equals</operation>
            <value>Fees Management</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>