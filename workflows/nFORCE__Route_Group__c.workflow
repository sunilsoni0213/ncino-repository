<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>nFORCE__Set_Has_Visibility_Criteria_False</fullName>
        <field>nFORCE__Has_Visibility_Criteria__c</field>
        <literalValue>0</literalValue>
        <name>Set Has Visibility Criteria False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>true</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>nFORCE__Set_Has_Visibility_Criteria_True</fullName>
        <field>nFORCE__Has_Visibility_Criteria__c</field>
        <literalValue>1</literalValue>
        <name>Set Has Visibility Criteria True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>true</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>nFORCE__Has No Visibility Criteria</fullName>
        <actions>
            <name>nFORCE__Set_Has_Visibility_Criteria_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(  ISCHANGED( nFORCE__Visibility_Criteria__c ),  ISBLANK( nFORCE__Visibility_Criteria__c ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>nFORCE__Has Visibility Criteria</fullName>
        <actions>
            <name>nFORCE__Set_Has_Visibility_Criteria_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(  ISCHANGED( nFORCE__Visibility_Criteria__c ),  NOT( ISBLANK( nFORCE__Visibility_Criteria__c ) )  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>