<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>IC_Issue_Resolved_Closed</fullName>
        <field>Issue_Status__c</field>
        <literalValue>Closed - Resolved</literalValue>
        <name>IC - Issue Resolved Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>Issue__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IC_Ready_for_Retest</fullName>
        <field>Issue_Status__c</field>
        <literalValue>Ready for Retest</literalValue>
        <name>IC - Ready for Retest</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>Issue__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Issue Comment%3A Issue Resolved</fullName>
        <actions>
            <name>IC_Issue_Resolved_Closed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Issue_Comment__c.Issue_Resolved__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>This workflow rule sets the Issue Status to Resolved</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Issue Comment%3A Ready for Retest</fullName>
        <actions>
            <name>IC_Ready_for_Retest</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Issue_Comment__c.Ready_for_Retest__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>This workflow rule sets the Issue Status to &apos;Ready for Retest&apos;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>