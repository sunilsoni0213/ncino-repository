<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Comm_Officer_Update</fullName>
        <field>LLC_BI__Commercial_Officer__c</field>
        <lookupValue>pilar.daniels.pgjtctwwmzrn@autorabitncinodemo.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Comm Officer Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Effective_Date</fullName>
        <field>LLC_BI__Effective_Date__c</field>
        <formula>TODAY()</formula>
        <name>Effective Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Stage_Order_Entry</fullName>
        <field>LLC_BI__Stage__c</field>
        <literalValue>Order Entry</literalValue>
        <name>Stage = Order Entry</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Pending</fullName>
        <field>LLC_BI__Status__c</field>
        <literalValue>Pending</literalValue>
        <name>Status = Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TM_Officer_Update</fullName>
        <field>LLC_BI__TM_Officer__c</field>
        <lookupValue>peter.s@autorabitncinodemo.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>TM Officer Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TS_Set_Default_App</fullName>
        <description>Set Default App based on Treasury Service Product</description>
        <field>LLC_BI__Default_App__c</field>
        <formula>case ( LLC_BI__Product_Reference__r.Name ,
&quot;Remote Deposit&quot;,&quot;Remote-Deposit.oe-remote-deposit&quot;,
&quot;Debit Card&quot;,&quot;Remote-Deposit.oe-remote-deposit&quot;,
&quot;Retail Lockbox&quot;,&quot;Retail-Lockbox.oe-retail-lockbox&quot;,
&quot;Wire Outgoing Manual&quot;,&quot;Wire-Transfer.oe-wire-transfer&quot;,
&quot;Wire Notification&quot;,&quot;Wire-Transfer.oe-wire-transfer&quot;,
&quot;Wire Incoming&quot;,&quot;Wire-Transfer.oe-wire-transfer&quot;,
&quot;Forced Wire Transfer Wd&quot;,&quot;Wire-Transfer.oe-wire-transfer&quot;,
&quot;Account Analysis Statement&quot;,&quot;Wire-Transfer.oe-wire-transfer&quot;,
&quot;Account Reconciliation Services&quot;,&quot;Wire-Transfer.oe-wire-transfer&quot;,
&quot;ARP Deposit Recon&quot;,&quot;Wire-Transfer.oe-wire-transfer&quot;,
&quot;ARP Full&quot;,&quot;Wire-Transfer.oe-wire-transfer&quot;,
&quot;ARP Partial&quot;,&quot;Wire-Transfer.oe-wire-transfer&quot;,
&quot;ARP Setup&quot;,&quot;Wire-Transfer.oe-wire-transfer&quot;,
&quot;ARP Transmission&quot;,&quot;Wire-Transfer.oe-wire-transfer&quot;,
&quot;CD-Rom&quot;,&quot;Wire-Transfer.oe-wire-transfer&quot;,
&quot;Account Receivables Conversion&quot;,&quot;Wire-Transfer.oe-wire-transfer&quot;,
&quot;ACH Block and Filter&quot;,&quot;Wire-Transfer.oe-wire-transfer&quot;,
&quot;ACH Credit&quot;,&quot;Wire-Transfer.oe-wire-transfer&quot;,
&quot;ACH Debit&quot;,&quot;Wire-Transfer.oe-wire-transfer&quot;,
&quot;ACH Direct Send&quot;,&quot;Wire-Transfer.oe-wire-transfer&quot;,
&quot;Direct Deposit&quot;,&quot;Wire-Transfer.oe-wire-transfer&quot;,
&quot;Serv ACH&quot;,&quot;Wire-Transfer.oe-wire-transfer&quot;,
&quot;Coin and Currency&quot;,&quot;Wire-Transfer.oe-wire-transfer&quot;,
&quot;Controlled Disbursement&quot;,&quot;Wire-Transfer.oe-wire-transfer&quot;,
&quot;Check Printing&quot;,&quot;Wire-Transfer.oe-wire-transfer&quot;,
&quot;Checks Deposited&quot;,&quot;Wire-Transfer.oe-wire-transfer&quot;,
&quot;Deposit Adjustment&quot;,&quot;Wire-Transfer.oe-wire-transfer&quot;,
&quot;FDIC Insurance&quot;,&quot;Wire-Transfer.oe-wire-transfer&quot;,
&quot;Inclearing Checks&quot;,&quot;Wire-Transfer.oe-wire-transfer&quot;,
&quot;Overdraft&quot;,&quot;Wire-Transfer.oe-wire-transfer&quot;,
&quot;Pre-Encoded Checks&quot;,&quot;Wire-Transfer.oe-wire-transfer&quot;,
&quot;Pre-Encoded Rejects&quot;,&quot;Wire-Transfer.oe-wire-transfer&quot;,
&quot;Research&quot;,&quot;Wire-Transfer.oe-wire-transfer&quot;,
&quot;Return Deposited Item&quot;,&quot;Wire-Transfer.oe-wire-transfer&quot;,
&quot;Returned Deposited Item&quot;,&quot;Wire-Transfer.oe-wire-transfer&quot;,
&quot;Stop Payment Manual&quot;,&quot;Wire-Transfer.oe-wire-transfer&quot;,
&quot;Sweep&quot;,&quot;Wire-Transfer.oe-wire-transfer&quot;,
&quot;Zero Balance Account&quot;,&quot;Wire-Transfer.oe-wire-transfer&quot;,
&quot;Wholesale Lockbox&quot;,&quot;Wire-Transfer.oe-wire-transfer&quot;,
&quot;Bill Pay&quot;,&quot;Wire-Transfer.oe-wire-transfer&quot;,
&quot;Direct File Transfer&quot;,&quot;Wire-Transfer.oe-wire-transfer&quot;,
&quot;OB Account Analysis&quot;,&quot;Wire-Transfer.oe-wire-transfer&quot;,
&quot;OB Book Transfer&quot;,&quot;Wire-Transfer.oe-wire-transfer&quot;,
&quot;OB Bundle&quot;,&quot;Wire-Transfer.oe-wire-transfer&quot;,
&quot;OB Information Reporting&quot;,&quot;Wire-Transfer.oe-wire-transfer&quot;,
&quot;OB Loan Module&quot;,&quot;Wire-Transfer.oe-wire-transfer&quot;,
&quot;OB Security Services&quot;,&quot;Wire-Transfer.oe-wire-transfer&quot;,
&quot;OB Security Tokens&quot;,&quot;Wire-Transfer.oe-wire-transfer&quot;,
&quot;OB Stop Payment&quot;,&quot;Wire-Transfer.oe-wire-transfer&quot;,
&quot;Overdraft Protection&quot;, &quot;Wire-Transfer.oe-wire-transfer&quot;,
&quot;&quot;)</formula>
        <name>TS - Set Default App</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Begin Implementation Task</fullName>
        <actions>
            <name>Assign_Commercial_DDA_Account_to_Service</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Begin_Product_Fufillment</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Verify_Signed_Agreements_are_Complete</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Your_Client_is_Now_in_Implementation</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LLC_BI__Treasury_Service__c.LLC_BI__Stage__c</field>
            <operation>equals</operation>
            <value>Implementation</value>
        </criteriaItems>
        <description>Set up task for Treasury Service</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Begin Order Entry</fullName>
        <actions>
            <name>Complete_Order_Entry_for_New_Treasury_Product</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LLC_BI__Treasury_Service__c.LLC_BI__Stage__c</field>
            <operation>equals</operation>
            <value>Order Entry</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Effective Date</fullName>
        <actions>
            <name>Effective_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LLC_BI__Treasury_Service__c.LLC_BI__Effective_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Status %3D Pending</fullName>
        <actions>
            <name>Stage_Order_Entry</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Status_Pending</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LLC_BI__Treasury_Service__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>When new Treasury Service is created, Status is set to &quot;Pending&quot;.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>TM Order Scanner Workflow</fullName>
        <actions>
            <name>Order_New_Scanner_for_Client</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <formula>LLC_BI__Remote_Deposit_Capture_Service__r.Scanner_Required__c  = true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Treasury Service - Set Default App</fullName>
        <actions>
            <name>TS_Set_Default_App</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>True</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Commericial Officer</fullName>
        <actions>
            <name>Comm_Officer_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LLC_BI__Treasury_Service__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update TM Officer</fullName>
        <actions>
            <name>TM_Officer_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LLC_BI__Treasury_Service__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <tasks>
        <fullName>Assign_Commercial_DDA_Account_to_Service</fullName>
        <assignedTo>peter.s@autorabitncinodemo.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Assign Commercial DDA Account to Service</subject>
    </tasks>
    <tasks>
        <fullName>Begin_Customer_Setup_For_New_Treasury_Service</fullName>
        <assignedTo>peter.s@autorabitncinodemo.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Begin Customer Setup For New Treasury Service</subject>
    </tasks>
    <tasks>
        <fullName>Begin_Product_Fufillment</fullName>
        <assignedTo>katie.wahl.w6eiuhmipu8b@autorabitncinodemo.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Begin Product Fufillment</subject>
    </tasks>
    <tasks>
        <fullName>Complete_Order_Entry_for_New_Treasury_Product</fullName>
        <assignedTo>peter.s@autorabitncinodemo.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>Complete the Order Entry Fields and Generate the Setup Forms for this Treasury Service</description>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>In Progress</status>
        <subject>Complete Order Entry for New Treasury Product</subject>
    </tasks>
    <tasks>
        <fullName>Contact_Customer_to_Implement_New_Service</fullName>
        <assignedTo>peter.s@autorabitncinodemo.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Contact Customer to Implement New Service</subject>
    </tasks>
    <tasks>
        <fullName>Order_Customer_Equipment</fullName>
        <assignedTo>peter.s@autorabitncinodemo.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>LLC_BI__Treasury_Service__c.CreatedDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Order Customer Equipment</subject>
    </tasks>
    <tasks>
        <fullName>Order_New_Scanner_for_Client</fullName>
        <assignedTo>peter.s@autorabitncinodemo.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>Please order a new scanner for this client. A new Treasury Service is being implemented.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Order New Scanner for Client</subject>
    </tasks>
    <tasks>
        <fullName>Verify_Signed_Agreements_are_Complete</fullName>
        <assignedTo>peter.s@autorabitncinodemo.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Verify Signed Agreements are Complete</subject>
    </tasks>
    <tasks>
        <fullName>Your_Client_is_Now_in_Implementation</fullName>
        <assignedTo>pilar.daniels.pgjtctwwmzrn@autorabitncinodemo.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>This may be a great time to reach out to your client and let them know we are processing the their request and see if they have any additional needs.</description>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Your Client is Now in Implementation</subject>
    </tasks>
</Workflow>