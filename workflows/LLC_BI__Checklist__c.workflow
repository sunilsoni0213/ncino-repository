<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Checklist_Name</fullName>
        <field>Name</field>
        <formula>LLC_BI__Account__r.Name + &apos; Maintenance Request on &apos; + Text(CreatedDate)</formula>
        <name>Checklist Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Duration</fullName>
        <field>LLC_BI__Actual_Duration_Days__c</field>
        <formula>10</formula>
        <name>Update Duration</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Update Checklist Name</fullName>
        <actions>
            <name>Checklist_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Duration</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LLC_BI__Checklist__c.LLC_BI__Category__c</field>
            <operation>equals</operation>
            <value>Maintenance</value>
        </criteriaItems>
        <description>This will convert the SF ID to an actual name.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>