<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Loan_Document_Exception_Notification</fullName>
        <description>Loan Document Exception Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>Chief_Credit_Officer</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>peter.s@autorabitncinodemo.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LLC_BI__Bankr_Templates/Document_Exception_Template</template>
    </alerts>
    <fieldUpdates>
        <fullName>LLC_LoanDocument_Set_DocType_Name</fullName>
        <field>DocType_Name__c</field>
        <formula>LLC_BI__docType__r.Name</formula>
        <name>LLC_LoanDocument - Set DocType Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NDOC__Loan_Document_Set_Year</fullName>
        <description>Sets the year field from date field</description>
        <field>NDOC__year__c</field>
        <formula>TEXT(YEAR(LLC_BI__date__c))</formula>
        <name>Loan Document Set Year</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Notify_Closer</fullName>
        <field>LLC_BI__MailerTeamKey__c</field>
        <formula>&quot;CloserAlert&quot;</formula>
        <name>Notify Closer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>LLC_BI__Loan__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Portal_Enabled_Docs_Description</fullName>
        <field>LLC_BI__Portal_Doc_Description__c</field>
        <formula>&quot;I can use this description field to help my customer understand specific document characteristics.&quot;</formula>
        <name>Portal Enabled Docs - Description</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Portal_Enabled_Docs_Name</fullName>
        <field>LLC_BI__Portal_Doc_Name__c</field>
        <formula>Name</formula>
        <name>Portal Enabled Docs - Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Portal_Enabled_Docs_Name_Change</fullName>
        <field>LLC_BI__Portal_Doc_Name__c</field>
        <formula>Name &amp; &apos; - &apos; &amp;  NDOC__year__c</formula>
        <name>Portal Enabled Docs - Name Change</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Portal_Enabled_Docs_True</fullName>
        <field>LLC_BI__Portal_Enabled__c</field>
        <literalValue>1</literalValue>
        <name>Portal Enabled Docs - True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Testing_LLC</fullName>
        <field>Name</field>
        <formula>Name</formula>
        <name>Testing LLC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Document Exception Notification</fullName>
        <actions>
            <name>Loan_Document_Exception_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LLC_BI__LLC_LoanDocument__c.LLC_BI__reviewStatus__c</field>
            <operation>equals</operation>
            <value>Exception</value>
        </criteriaItems>
        <description>Notifies user when  document has a loan exception</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LLC_LoanDocument - Set DocType Name</fullName>
        <actions>
            <name>LLC_LoanDocument_Set_DocType_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets the custom DocType Name field to the name of the DocType selected via the packaged lookup field.</description>
        <formula>LLC_BI__docType__c != null</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>NDOC__Loan Document Set Blank Year From Date</fullName>
        <actions>
            <name>NDOC__Loan_Document_Set_Year</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets the year from the date field, if year is blank and the date field is set.</description>
        <formula>AND(ISBLANK(NDOC__year__c), NOT(ISBLANK(LLC_BI__date__c)))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>You_have_a_pending_document_exception</fullName>
        <assignedTo>peter.s@autorabitncinodemo.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>You have a pending document exception</subject>
    </tasks>
</Workflow>