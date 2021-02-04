<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Branch_EMEA_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>EMEA_Branches</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Branch - EMEA Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Branch_US_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>US_Branches</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Branch - US Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Branch - EMEA</fullName>
        <actions>
            <name>Branch_EMEA_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LLC_BI__Branch__c.Country__c</field>
            <operation>notEqual</operation>
            <value>United States</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Branch - US</fullName>
        <actions>
            <name>Branch_US_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LLC_BI__Branch__c.Country__c</field>
            <operation>equals</operation>
            <value>United States</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>