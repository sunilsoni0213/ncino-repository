<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Average_Ledger_Balance</fullName>
        <field>LLC_BI__Average_Ledger_Balance__c</field>
        <formula>1590000</formula>
        <name>Average Ledger Balance</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Earnings_Credit_Rate</fullName>
        <field>LLC_BI__Earnings_Credit_Allowance__c</field>
        <formula>0.0035</formula>
        <name>Earnings Credit Rate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Less_Unavailable</fullName>
        <field>LLC_BI__Average_Unavailable__c</field>
        <formula>2500</formula>
        <name>Less Unavailable</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reserve_Requirement</fullName>
        <field>LLC_BI__Reserve_Requirement_Rate__c</field>
        <formula>10</formula>
        <name>Reserve Requirement</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Approved_Update_Status</fullName>
        <field>LLC_BI__Status__c</field>
        <literalValue>Final</literalValue>
        <name>Status = Approved Update Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>status</fullName>
        <field>LLC_BI__Status__c</field>
        <literalValue>Final</literalValue>
        <name>status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Update Proforma Fields for Demo</fullName>
        <actions>
            <name>Average_Ledger_Balance</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Earnings_Credit_Rate</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Less_Unavailable</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Reserve_Requirement</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LLC_BI__Scenario__c.CreatedDate</field>
            <operation>equals</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>This updates the Avg Ledger Balance, Less Unavailable, Earnings Credit, and Reserve Amount in the Proforma</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>