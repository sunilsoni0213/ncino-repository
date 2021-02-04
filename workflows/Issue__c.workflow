<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Issue_Comment_Notification</fullName>
        <description>Issue - New Comment Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>nCino_Project_Managememt/Issue_New_Project_Issue_Comment</template>
    </alerts>
    <alerts>
        <fullName>Issue_New_Issue_Notification</fullName>
        <description>Issue - New Issue Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>nCino_Project_Managememt/Issue_New_Project_Issue</template>
    </alerts>
    <rules>
        <fullName>Issue  - New Issue Assigned to You</fullName>
        <actions>
            <name>Issue_New_Issue_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Issue__c.Description__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This workflow notifies the owner of an internal project issue that an issue has been assigned to them.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>New Comment Notification</fullName>
        <actions>
            <name>Issue_Comment_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This workflow rule sends an Email Alert to the Issue Owner and Record Creator when a new comment is added</description>
        <formula>AND(  ISCHANGED( Comment_Count__c ),  Comment_Count__c &gt; 0  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>