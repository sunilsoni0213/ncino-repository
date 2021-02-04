<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>In_File</fullName>
        <field>LLC_BI__reviewStatus__c</field>
        <literalValue>In-File</literalValue>
        <name>In-File</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NDOC__Account_Document_Set_Year</fullName>
        <description>Sets the year field from date field</description>
        <field>NDOC__Year__c</field>
        <formula>TEXT(YEAR( LLC_BI__date__c ))</formula>
        <name>Account Document Set Year</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>NDOC__Account Document Set Blank Year From Date</fullName>
        <actions>
            <name>NDOC__Account_Document_Set_Year</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets the year from the date field, if year is blank and the date field is set.</description>
        <formula>AND(ISBLANK(NDOC__Year__c), NOT(ISBLANK( LLC_BI__date__c )))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>