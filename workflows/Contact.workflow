<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Contact_Life_Event_Address_Today</fullName>
        <description>Updates the life event address field.</description>
        <field>life_Event_Address_Change__c</field>
        <formula>TODAY()</formula>
        <name>Contact - Life Event Address = Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contact_Live_Event_Date_Today</fullName>
        <description>Updates the employer life event field on the contact level.</description>
        <field>Life_Event_Employment_Change__c</field>
        <formula>TODAY()</formula>
        <name>Contact - Live Event Date = Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Country_of_Residence_United_States</fullName>
        <description>When are you a US Resident = Yes</description>
        <field>LLC_BI__Country_of_Citizenship__c</field>
        <literalValue>United States</literalValue>
        <name>Country of Residence= United States</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__Set_Contact_Business_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>LLC_BI__Business_Contact</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Contact Business Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__Set_Contact_Individual_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>LLC_BI__Individual_Contact</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Contact Individual Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Kathryn_s_Income</fullName>
        <field>LLC_BI__Monthly_Income__c</field>
        <formula>84000</formula>
        <name>Update Kathryn&apos;s Income</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Address Change</fullName>
        <actions>
            <name>Contact_Life_Event_Address_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates the life event address field on the contact level when the address is changed.</description>
        <formula>ISCHANGED( LLC_BI__Home_Address__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Employer Change</fullName>
        <actions>
            <name>Contact_Live_Event_Date_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Changes the employer date field on the contact level whenever the &quot;employer&quot; field is updated.</description>
        <formula>ISCHANGED(  Employer__c  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LLC_BI__Contact Set Business Record Type</fullName>
        <actions>
            <name>LLC_BI__Set_Contact_Business_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Contact.LLC_BI__Primary_Contact__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>sets Record Type to Business if Contact is not marked as primary</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LLC_BI__Contact Set Individual Record Type</fullName>
        <actions>
            <name>LLC_BI__Set_Contact_Individual_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Contact.LLC_BI__Primary_Contact__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>sets Record Type to Individual if Contact is marked as primary</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>US Citizen %3D True update Country of Citizenship</fullName>
        <actions>
            <name>Country_of_Residence_United_States</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.LLC_BI__US_Citizen__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Monthly Income</fullName>
        <actions>
            <name>Update_Kathryn_s_Income</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(LLC_BI__Monthly_Income__c  = 0.00, PRIORVALUE(LLC_BI__Monthly_Income__c) != 0.00)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>