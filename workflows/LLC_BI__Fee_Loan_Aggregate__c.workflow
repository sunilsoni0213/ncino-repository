<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Origination_Charges</fullName>
        <field>Origination_Charges__c</field>
        <formula>500.00</formula>
        <name>Origination Charges</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Services_you_can_shop_for</fullName>
        <field>Services_You_Can_Shop_For__c</field>
        <formula>&apos;Pest Inspection Fee - 135.00 Title - Insurance Binder - 500.00 Title - Lenders Title Policy - 75.00 Title - Title Search - 625.00 Title - Settlement Agent Fee - 475.00 Survey Fee - 65.00&apos;</formula>
        <name>Services you can shop for</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Services_you_cannot_shop_for</fullName>
        <field>Services_You_Cannot_Shop_For__c</field>
        <formula>&apos;Flood Determination Fee - 20.00 Flood Monitoring Fee - 32.00 Tax Monitoring Fee - 75.00 Tax Status Research Fee - 110.00 Consumer Appraisal - 350.00 Credit Report - 26.00&apos;</formula>
        <name>Services you cannot shop for</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>update fee summary</fullName>
        <actions>
            <name>Origination_Charges</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Services_you_can_shop_for</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Services_you_cannot_shop_for</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LLC_BI__Fee_Loan_Aggregate__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>