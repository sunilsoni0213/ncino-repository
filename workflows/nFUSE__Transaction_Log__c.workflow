<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Docs_Downloaded</fullName>
        <description>Docs Downloaded</description>
        <protected>false</protected>
        <recipients>
            <recipient>peter.s@autorabitncinodemo.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LLC_BI__Bankr_Templates/Expere_Docs_Returned</template>
    </alerts>
    <alerts>
        <fullName>Expere_Docs_Generated</fullName>
        <description>Expere - Docs Generated</description>
        <protected>false</protected>
        <recipients>
            <recipient>peter.s@autorabitncinodemo.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LLC_BI__Bankr_Templates/Expere_Docs_Generated</template>
    </alerts>
    <fieldUpdates>
        <fullName>nFUSE__Change_TransLog_Status</fullName>
        <description>Change the status when timeout occured</description>
        <field>nFUSE__Transaction_Status__c</field>
        <formula>&quot;Timeout Occurred&quot;</formula>
        <name>Change TransLog Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Docs Returned</fullName>
        <actions>
            <name>Docs_Downloaded</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Expere_generated_documents_have_been_returned</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>nFUSE__Transaction_Log__c.nFUSE__Vendor_Status__c</field>
            <operation>equals</operation>
            <value>Complete</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>nFUSE__DocPrepTimeoutRule</fullName>
        <active>false</active>
        <criteriaItems>
            <field>nFUSE__Transaction_Log__c.nFUSE__Transaction_Status__c</field>
            <operation>notEqual</operation>
            <value>Transaction Complete</value>
        </criteriaItems>
        <description>Update the transaction log status when a request is not returned for the transaction</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Expere_generated_documents_have_been_returned</fullName>
        <assignedTo>peter.s@autorabitncinodemo.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>Your generated documents have now been filed in the document manager, please review and approve them.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Generated documents have been returned</subject>
    </tasks>
</Workflow>