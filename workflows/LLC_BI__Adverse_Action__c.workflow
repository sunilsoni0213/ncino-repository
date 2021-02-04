<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>AA_Loan_Flag_1</fullName>
        <field>LLC_BI__Loan_Flag__c</field>
        <formula>1</formula>
        <name>AA - Loan Flag = 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AA_Status_Loan_Declined</fullName>
        <field>AA_Status__c</field>
        <literalValue>Loan Declined</literalValue>
        <name>AA - Status = Loan Declined</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AA_Status_Rejected</fullName>
        <field>AA_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>AA - Status = Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AA_Status_Under_Review</fullName>
        <field>AA_Status__c</field>
        <literalValue>Under Review</literalValue>
        <name>AA - Status = Under Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
</Workflow>