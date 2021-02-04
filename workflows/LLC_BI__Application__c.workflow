<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Online_Application_Record_type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Online_Application</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Online Application Record type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Online_Application_True</fullName>
        <field>Online_Application__c</field>
        <literalValue>1</literalValue>
        <name>Online Application = True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Record_Type_Online_Application</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Online_Application</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Record Type = Online Application</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_App_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Online_Application</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update App Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Application_Completion_Date</fullName>
        <field>LLC_BI__Application_Completion_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update Application Completion Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Online_Application_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Online_Application</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Online Application Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>New Online Application</fullName>
        <actions>
            <name>New_Online_Application_Waiting</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LLC_BI__Application__c.nPortal__Applicant__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Creates a task or puts the application into a queue to notify someone at the bank that the online application has been started.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Online Application Checked</fullName>
        <actions>
            <name>Online_Application_True</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Record_Type_Online_Application</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LLC_BI__Application__c.nPortal__Applicant__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Application Completion Date</fullName>
        <actions>
            <name>Update_Application_Completion_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>An_online_application_has_been_completed_by_all_applicants_Please_review</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LLC_BI__Application__c.nPortal__Status__c</field>
            <operation>equals</operation>
            <value>Complete</value>
        </criteriaItems>
        <description>When the Application status changes to complete, the completion date is updated.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>An_online_application_has_been_completed_by_all_applicants_Please_review</fullName>
        <assignedTo>peter.s@autorabitncinodemo.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>This online application has been completed by all related parties.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>An online product application has been completed by all applicants. Please review</subject>
    </tasks>
    <tasks>
        <fullName>New_Online_Application_Waiting</fullName>
        <assignedTo>peter.s@autorabitncinodemo.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>There&apos;s a new online application being started.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>New Online Application has been started</subject>
    </tasks>
</Workflow>