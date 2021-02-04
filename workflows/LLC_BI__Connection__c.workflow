<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Ownership_Percentage</fullName>
        <field>LLC_BI__Ownership_Percent__c</field>
        <formula>1</formula>
        <name>Ownership Percentage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Household Ownership</fullName>
        <actions>
            <name>Ownership_Percentage</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If the connection role is household set ownership percentage to 100%.</description>
        <formula>LLC_BI__Connection_Role__r.Name = &quot;Household&quot;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>