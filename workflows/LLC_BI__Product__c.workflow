<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Product_Type_Deposit</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Deposit_Product_Layout</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Product Type = Deposit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Product_Type_Loan</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Loan_Product_Layout</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Product Type = Loan</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Product_Type_Loan1</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Loan_Product_Layout</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Product Type = Loan</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Product_Type_Treasury</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Treasury_Layout</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Product Type = Treasury</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_RT_to_Treasury</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Treasury_Layout</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update RT to Treasury</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Product Type %3D Deposit</fullName>
        <actions>
            <name>Product_Type_Deposit</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LLC_BI__Product__c.Classificationproduct__c</field>
            <operation>equals</operation>
            <value>Online Banking,Checking,Savings,Retirement</value>
        </criteriaItems>
        <criteriaItems>
            <field>LLC_BI__Product__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>updates page layout</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Product Type %3D Loan</fullName>
        <actions>
            <name>Product_Type_Loan1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LLC_BI__Product__c.Classificationproduct__c</field>
            <operation>equals</operation>
            <value>Credit Card,HELOC,Term Loan,LOC,Mortgage</value>
        </criteriaItems>
        <criteriaItems>
            <field>LLC_BI__Product__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>updates page layout</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Product Type %3D Treasury</fullName>
        <actions>
            <name>Update_RT_to_Treasury</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LLC_BI__Product__c.Classificationproduct__c</field>
            <operation>equals</operation>
            <value>Treasury Service</value>
        </criteriaItems>
        <criteriaItems>
            <field>LLC_BI__Product__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>updates page layout</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>