<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Reject_Inspection</fullName>
        <description>Sets inspection status to rejected</description>
        <field>LLC_BI__Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Reject Inspection</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Inspection_Status_to_Approved</fullName>
        <description>Sets inspection status to approved</description>
        <field>LLC_BI__Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Set Inspection Status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
</Workflow>