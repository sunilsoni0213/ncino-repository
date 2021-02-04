<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Relationship_Text_Field</fullName>
        <description>Takes value your from Relationship Type Formula field and copies here.</description>
        <field>Relationship_Type_Text__c</field>
        <formula>Individual_Formula__c</formula>
        <name>Update Relationship Text Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Set Relationship Type</fullName>
        <actions>
            <name>Update_Relationship_Text_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LLC_BI__Legal_Entities__c.Relationship_Type_Text__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Relationship Type Formula field doesn&apos;t work in flow because of an SF error. We will now reference this field in flow until issue is resolved.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>