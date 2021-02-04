<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>nSBA__Has_California_Property</fullName>
        <field>nSBA__Loan_Authorization_California_Collateral__c</field>
        <literalValue>1</literalValue>
        <name>Has California Property</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>nSBA__Application__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>nSBA__California Property</fullName>
        <actions>
            <name>nSBA__Has_California_Property</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>nSBA__Use_Of_Proceeds__c.nSBA__Location_State__c</field>
            <operation>equals</operation>
            <value>CA</value>
        </criteriaItems>
        <description>Checks if use of proceeds location is in california</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>