<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Compunding_Frequency_Daily</fullName>
        <description>This can be determined based on the type of product. Some products may have different compounding frequencies based on the FI&apos;s criteria.</description>
        <field>LLC_BI__Compounding_Frequency__c</field>
        <literalValue>Daily</literalValue>
        <name>Compunding Frequency - Daily</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>New_Deposit_Open_Date_Today</fullName>
        <description>Sets a new deposits date opened to today</description>
        <field>LLC_BI__Open_Date__c</field>
        <formula>TODAY()</formula>
        <name>New Deposit Open Date Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Product_Type_Checking</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CheckingDDARecordType</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Product Type = Checking</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Record_Type_CD</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CD_Record_Type</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Record Type = CD</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Record_Type_Retirement</fullName>
        <field>RecordTypeId</field>
        <lookupValue>IRA_CD_Record_Type</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Record Type = Retirement</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Record_Type_Savings</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Savings_Record_Type</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Record Type = Savings</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Required_Signers_to_1</fullName>
        <field>LLC_BI__Number_of_Required_Signers__c</field>
        <literalValue>1 - One signature line</literalValue>
        <name>Required Signers to 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Stage_Set_to_Open</fullName>
        <field>LLC_BI__Stage__c</field>
        <literalValue>Pending</literalValue>
        <name>Stage Set to Active</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Stage_set_to_Pending</fullName>
        <field>LLC_BI__Stage__c</field>
        <literalValue>Pending</literalValue>
        <name>Stage set to Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_APY</fullName>
        <field>Initial_APY1__c</field>
        <formula>(((LLC_BI__Initial_Interest_Rate__c /365)+1) ^ 365)  - 1</formula>
        <name>Update APY</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Calculate APY</fullName>
        <actions>
            <name>Update_APY</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LLC_BI__Deposit__c.LLC_BI__Initial_Interest_Rate__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Deposit - Record Type CD</fullName>
        <actions>
            <name>Record_Type_CD</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LLC_BI__Deposit__c.LLC_BI__Product_Type__c</field>
            <operation>equals</operation>
            <value>Business CD,Personal CD</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Deposit - Record Type Checking</fullName>
        <actions>
            <name>Product_Type_Checking</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LLC_BI__Deposit__c.LLC_BI__Product_Type__c</field>
            <operation>equals</operation>
            <value>Business Checking,Personal Checking</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Deposit - Record Type Retirement</fullName>
        <actions>
            <name>Record_Type_Retirement</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LLC_BI__Deposit__c.LLC_BI__Product_Type__c</field>
            <operation>equals</operation>
            <value>Retirement</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Deposit - Record Type Savings</fullName>
        <actions>
            <name>Record_Type_Savings</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LLC_BI__Deposit__c.LLC_BI__Product_Type__c</field>
            <operation>equals</operation>
            <value>Business Savings,Personal Savings</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Deposit Stage %3D Active</fullName>
        <actions>
            <name>Stage_Set_to_Open</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When a deposit is created in branch, the stage is set to &quot;Active&quot;.</description>
        <formula>ISNULL(LLC_BI__Application__c)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Deposit Stage %3D Pending</fullName>
        <actions>
            <name>Stage_set_to_Pending</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When a deposit is created online the stage is set to &quot;Pending&quot;. This might enable the bank to perform any additional due diligence.</description>
        <formula>LLC_BI__Application__c != NULL</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>New Account Engagement Communications Plan</fullName>
        <actions>
            <name>Add_to_Marketing_Campaign_for_Product_Expansion</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Call_Customer_Ensuring_continued_Satisfaction</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Call_Customer_Thank_you_for_choosing_to_do_business_with_us</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Call_Customer_What_else_can_we_do_to_help_you_plan_for_your_financial_future</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>New_Account_Follow_Up_Email_on_additional_services</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>New_Account_Follow_Up_Ensure_receipt_of_deliverables</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LLC_BI__Deposit__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Representative workflow for new account engagement. Establishes follow-up activities for new account onboarding. Configurable by organization.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set New Deposit Open Date to Today</fullName>
        <actions>
            <name>Compunding_Frequency_Daily</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>New_Deposit_Open_Date_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Required_Signers_to_1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>LLC_BI__Deposit__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <tasks>
        <fullName>Add_to_Marketing_Campaign_for_Product_Expansion</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>30</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>LLC_BI__Deposit__c.CreatedDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Add to Marketing Campaign for Product Expansion</subject>
    </tasks>
    <tasks>
        <fullName>Call_Customer_Ensuring_continued_Satisfaction</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>60</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>LLC_BI__Deposit__c.LLC_BI__Open_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Call Customer - Ensuring continued Satisfaction</subject>
    </tasks>
    <tasks>
        <fullName>Call_Customer_Thank_you_for_choosing_to_do_business_with_us</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>LLC_BI__Deposit__c.CreatedDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Call Customer - Thank you for choosing to do business with us!</subject>
    </tasks>
    <tasks>
        <fullName>Call_Customer_What_else_can_we_do_to_help_you_plan_for_your_financial_future</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>75</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>LLC_BI__Deposit__c.CreatedDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Call Customer - What else can we do to help you plan for your financial future?</subject>
    </tasks>
    <tasks>
        <fullName>New_Account_Follow_Up_Email_on_additional_services</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>15</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>LLC_BI__Deposit__c.CreatedDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>New Account Follow-Up - Email on additional services</subject>
    </tasks>
    <tasks>
        <fullName>New_Account_Follow_Up_Ensure_receipt_of_deliverables</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>LLC_BI__Deposit__c.CreatedDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>New Account Follow-Up - Ensure receipt of deliverables</subject>
    </tasks>
</Workflow>