<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Risk_Grade_Factor_Name</fullName>
        <description>Updates the risk grade factor name from the risk grade factor</description>
        <field>Name</field>
        <formula>LLC_BI__Risk_Grade_Factor__r.Name</formula>
        <name>Update Risk Grade Factor Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Rename Risk Grade Factor Value</fullName>
        <actions>
            <name>Update_Risk_Grade_Factor_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Renamed the name of the record from the risk grade factor</description>
        <formula>TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>