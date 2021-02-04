<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Lead_New_Web_to_Lead</fullName>
        <description>Lead - New Web to Lead</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Leads/Lead_New_Web_to_Lead</template>
    </alerts>
    <fieldUpdates>
        <fullName>Lead_Lead_Source_Web</fullName>
        <field>LeadSource</field>
        <literalValue>Web</literalValue>
        <name>Lead - Lead Source = Web</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>New Web to Lead Record</fullName>
        <actions>
            <name>Lead_New_Web_to_Lead</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Lead_Lead_Source_Web</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>A_new_Web_to_Lead_record_has_been_created_Please_follow_up_and_take_necessary_ac</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Web_Lead__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <tasks>
        <fullName>A_new_Web_to_Lead_record_has_been_created_Please_follow_up_and_take_necessary_ac</fullName>
        <assignedTo>peter.s@autorabitncinodemo.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>A new Web to Lead record has been created. Please follow-up and take necessary action.</subject>
    </tasks>
</Workflow>