<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>LLC_BI__HMDA_Record_Type_Update_2017</fullName>
        <field>RecordTypeId</field>
        <lookupValue>LLC_BI__HMDA_Effective_2017</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>HMDA Record Type Update 2017</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__HMDA_Record_Type_Update_2018</fullName>
        <field>RecordTypeId</field>
        <lookupValue>LLC_BI__HMDA_Effective_2018</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>HMDA Record Type Update 2018</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>LLC_BI__HMDA 2017 Record Type Check</fullName>
        <actions>
            <name>LLC_BI__HMDA_Record_Type_Update_2017</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL(LLC_BI__Loan__r.LLC_BI__HMDA_Record_Type__c, &apos;HMDA-Effective-2017&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LLC_BI__HMDA 2018 Record Type Check</fullName>
        <actions>
            <name>LLC_BI__HMDA_Record_Type_Update_2018</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL(LLC_BI__Loan__r.LLC_BI__HMDA_Record_Type__c , &apos;HMDA-Effective-2018&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>