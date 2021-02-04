<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>nRE__Referral_Accepted</fullName>
        <description>Referral Accepted</description>
        <protected>false</protected>
        <recipients>
            <field>nRE__Referred_By__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>nRE__Referral_Email_Templates/nRE__Referral_Accepted</template>
    </alerts>
    <alerts>
        <fullName>nRE__Referral_Closed_Lost</fullName>
        <description>Referral Closed Lost</description>
        <protected>false</protected>
        <recipients>
            <field>nRE__Referred_By__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>nRE__Referred_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>nRE__Referral_Email_Templates/nRE__Referral_Closed_Lost</template>
    </alerts>
    <alerts>
        <fullName>nRE__Referral_Closed_Won</fullName>
        <description>Referral Closed Won</description>
        <protected>false</protected>
        <recipients>
            <field>nRE__Referred_By__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>nRE__Referred_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>nRE__Referral_Email_Templates/nRE__Referral_Closed_Won</template>
    </alerts>
    <alerts>
        <fullName>nRE__Referral_Sent</fullName>
        <description>Referral Sent</description>
        <protected>false</protected>
        <recipients>
            <field>nRE__Referred_By__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>nRE__Referred_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>nRE__Referral_Email_Templates/nRE__Referral_Sent</template>
    </alerts>
    <fieldUpdates>
        <fullName>nRE__Referral_Closed_Date</fullName>
        <description>Updates the Referral Close Date to Today when Closed Won or Closed lost equals True</description>
        <field>nRE__Referral_Close_Date__c</field>
        <formula>Now()</formula>
        <name>Referral - Closed Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>nRE__Referral_Received_Date</fullName>
        <description>Update the Referral Received Date to Today when the Accept Referral Button is pressed</description>
        <field>nRE__Referral_Received_Date__c</field>
        <formula>Now()</formula>
        <name>Referral - Received Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>nRE__Referral_Sent_Date</fullName>
        <description>Update the Referral Sent Date to Today when the Send Referral Button is pressed</description>
        <field>nRE__Referral_Sent_Date__c</field>
        <formula>Now()</formula>
        <name>Referral - Sent Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>nRE__Referral_Update_Quality_to_Qualified</fullName>
        <field>nRE__Referral_Quality__c</field>
        <literalValue>Qualified</literalValue>
        <name>Referral - Update Quality to Qualified</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>nRE__Referral_Update_RT_to_Existing_Accept</fullName>
        <field>RecordTypeId</field>
        <lookupValue>nRE__Referral_Existing_Relationship_Accepted</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Referral - Update RT to Existing Accept</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>nRE__Referral_Update_RT_to_Existing_Sent</fullName>
        <field>RecordTypeId</field>
        <lookupValue>nRE__Referral_Existing_Relationship_Sent</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Referral - Update RT to Existing Sent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>nRE__Referral_Update_RT_to_New_Accepted</fullName>
        <field>RecordTypeId</field>
        <lookupValue>nRE__Referral_New_Relationship_Accepted</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Referral - Update RT to New Accepted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>nRE__Referral_Update_RT_to_New_Sent</fullName>
        <field>RecordTypeId</field>
        <lookupValue>nRE__Referral_New_Relationship_Sent</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Referral - Update RT to New Sent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>nRE__Referral_Update_Status_to_Active</fullName>
        <description>When a Referral is Accepted update the Referral Status to Active</description>
        <field>nRE__Referral_Status__c</field>
        <literalValue>Active</literalValue>
        <name>Referral - Update Status to Active</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>nRE__Referral_Update_Status_to_Closed_Lost</fullName>
        <description>When the Closed Lost Checkbox = True, update the Referral Status to Closed Lost</description>
        <field>nRE__Referral_Status__c</field>
        <literalValue>Closed Lost</literalValue>
        <name>Referral - Update Status to Closed Lost</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>nRE__Referral_Update_Status_to_Closed_Won</fullName>
        <description>When the Closed Won Checkbox = True, update the Referral Status to Closed Won</description>
        <field>nRE__Referral_Status__c</field>
        <literalValue>Closed Won</literalValue>
        <name>Referral - Update Status to Closed Won</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>nRE__Referral_Update_Status_to_Sent</fullName>
        <description>When the Send Referral button is pressed update the Referral Status to Sent</description>
        <field>nRE__Referral_Status__c</field>
        <literalValue>Sent</literalValue>
        <name>Referral - Update Status to Sent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>nRE__Referral Accepted - Existing</fullName>
        <actions>
            <name>nRE__Referral_Accepted</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>nRE__Referral_Received_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>nRE__Referral_Update_RT_to_Existing_Accept</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>nRE__Referral_Update_Status_to_Active</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>nRE__Referral__c.nRE__isReceived__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>nRE__Referral__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Referral - Existing Relationship Sent</value>
        </criteriaItems>
        <description>This workflow rule sets the status to Active, completes the Received Date and updates the Record Type to &apos;Referral - Existing Relationship Accepted&apos;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>nRE__Referral Accepted - New</fullName>
        <actions>
            <name>nRE__Referral_Accepted</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>nRE__Referral_Received_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>nRE__Referral_Update_RT_to_New_Accepted</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>nRE__Referral_Update_Status_to_Active</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>nRE__Referral__c.nRE__isReceived__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>nRE__Referral__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Referral - New Relationship Sent</value>
        </criteriaItems>
        <description>This workflow rule sets the status to Active, completes the Received Date and updates the Record Type to &apos;Referral - New Relationship Accepted&apos;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>nRE__Referral Closed Lost</fullName>
        <actions>
            <name>nRE__Referral_Closed_Lost</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>nRE__Referral_Closed_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>nRE__Referral_Update_Status_to_Closed_Lost</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>nRE__Referral__c.nRE__Closed_Lost__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>This workflow rule sets the status to Closed Lost and completes the Referral Closed Date</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>nRE__Referral Closed Won</fullName>
        <actions>
            <name>nRE__Referral_Closed_Won</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>nRE__Referral_Closed_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>nRE__Referral_Update_Quality_to_Qualified</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>nRE__Referral_Update_Status_to_Closed_Won</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>nRE__Referral__c.nRE__Closed_Won__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>This workflow rule sets the status to Closed Won and completes the Referral Closed Date</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>nRE__Referral Sent - Existing</fullName>
        <actions>
            <name>nRE__Referral_Sent</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>nRE__Referral_Sent_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>nRE__Referral_Update_RT_to_Existing_Sent</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>nRE__Referral_Update_Status_to_Sent</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>nRE__Referral__c.nRE__isSent__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>nRE__Referral__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Referral - Existing Relationship</value>
        </criteriaItems>
        <description>This workflow rule sets the status to Sent, completes the Sent Date and updates the Record Type to &apos;Referral - Existing Relationship Sent&apos;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>nRE__Referral Sent - New</fullName>
        <actions>
            <name>nRE__Referral_Sent</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>nRE__Referral_Sent_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>nRE__Referral_Update_RT_to_New_Sent</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>nRE__Referral_Update_Status_to_Sent</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>nRE__Referral__c.nRE__isSent__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>nRE__Referral__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Referral - New Relationship</value>
        </criteriaItems>
        <description>This workflow rule sets the status to Sent, completes the Sent Date and updates the Record Type to &apos;Referral - New Relationship Sent&apos;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>