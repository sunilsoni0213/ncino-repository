<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>NDOC__Document_Placeholder_Set_Year</fullName>
        <description>Sets the year field from date field</description>
        <field>LLC_BI__Year__c</field>
        <formula>TEXT(YEAR(LLC_BI__Date__c))</formula>
        <name>Document Placeholder Set Year</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>NDOC__Document Placeholder Set Blank Year From Date</fullName>
        <actions>
            <name>NDOC__Document_Placeholder_Set_Year</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets the year from the date field, if year is blank and the date field is set.</description>
        <formula>AND(ISBLANK( LLC_BI__Year__c ), NOT(ISBLANK( LLC_BI__Date__c  )))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>