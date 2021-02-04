<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>On_Off_to_True</fullName>
        <field>On_Off__c</field>
        <literalValue>1</literalValue>
        <name>On/Off to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Create FLOW Schedule Job</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Scheduled_Jobs__c.On_Off__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>On_Off_to_True</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Scheduled_Jobs__c.Scheduled_Time__c</offsetFromField>
            <timeLength>10</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>