<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>LLC_BI__Alert_Loan_Withdrawn_Declined</fullName>
        <description>Alert Loan Withdrawn / Declined</description>
        <protected>false</protected>
        <recipients>
            <recipient>peter.s@autorabitncinodemo.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LLC_BI__Bankr_Templates/LLC_BI__Loan_Withdrawn_DeclinedAlert</template>
    </alerts>
    <alerts>
        <fullName>LLC_BI__Alert_Loan_in_Closing_Stage_too_Long</fullName>
        <ccEmails>demo@bankr.com</ccEmails>
        <description>Alert Loan in Closing Stage too Long</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>LLC_BI__Bankr_Templates/LLC_BI__Loan_in_Closing_XDay_Alert</template>
    </alerts>
    <alerts>
        <fullName>LLC_BI__Loan_Closing_E_mail_Alert</fullName>
        <ccEmails>demo@bankr.com</ccEmails>
        <description>Loan Closing E-mail Alert</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>LLC_BI__Bankr_Templates/LLC_BI__Loan_Closing_Termplate</template>
    </alerts>
    <alerts>
        <fullName>LLC_BI__Loan_Lost_Alert</fullName>
        <ccEmails>trialforce@bankr.com</ccEmails>
        <description>Loan Lost Alert</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>LLC_BI__Bankr_Templates/LLC_BI__Loan_Closing_Termplate</template>
    </alerts>
    <alerts>
        <fullName>LLC_BI__Notify_Loan_Reviewed_by_Quality_Compliance</fullName>
        <ccEmails>trialforce@bankr.com</ccEmails>
        <description>Notify Loan Reviewed by Quality (Compliance)</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>LLC_BI__Bankr_Templates/LLC_BI__Loan_Reviewed_by_Compliance</template>
    </alerts>
    <alerts>
        <fullName>LLC_BI__Notify_Roles_of_Lead_Conversion_into_Loan</fullName>
        <ccEmails>demo@bankr.com</ccEmails>
        <description>Notify Roles of Lead Conversion into Loan</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>LLC_BI__Bankr_Templates/LLC_BI__LeadConverted</template>
    </alerts>
    <alerts>
        <fullName>Loan_Approval_Email_Notification</fullName>
        <description>Loan - Approval Email Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>peter.s@autorabitncinodemo.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>LLC_BI__Loan_Officer__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LLC_BI__Bankr_Templates/Loan_Approved</template>
    </alerts>
    <alerts>
        <fullName>Loan_Approved_by_Credit</fullName>
        <description>Loan - Approved by Credit</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>peter.s@autorabitncinodemo.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LLC_BI__Bankr_Templates/LLC_BI__Loan_to_Credit_Review_Approved</template>
    </alerts>
    <alerts>
        <fullName>Loan_Rejection_Email_Notification</fullName>
        <description>Loan - Rejection Email Notification</description>
        <protected>false</protected>
        <recipients>
            <field>LLC_BI__Loan_Officer__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LLC_BI__Bankr_Templates/Loan_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Loan_Stage_Change</fullName>
        <description>Loan - Stage Change</description>
        <protected>false</protected>
        <recipients>
            <recipient>peter.s@autorabitncinodemo.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LLC_BI__Bankr_Templates/LLC_BI__Stage_Change_Alert</template>
    </alerts>
    <alerts>
        <fullName>Online_Application_Low_Touch_Approval_Email_to_Customers</fullName>
        <description>Online Application Low Touch Approval Email to Customers</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Customer_Portal_Notifications/Online_Application_Approved</template>
    </alerts>
    <alerts>
        <fullName>Oraion_Low_Touch_Approval</fullName>
        <description>Oraion Low Touch Approval</description>
        <protected>false</protected>
        <recipients>
            <recipient>peter.s@autorabitncinodemo.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>LLC_BI__Loan_Officer__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LLC_BI__Bankr_Templates/Oraion_Approval</template>
    </alerts>
    <alerts>
        <fullName>UFCU_demo</fullName>
        <description>UFCU demo</description>
        <protected>false</protected>
        <recipients>
            <field>LLC_BI__Loan_Officer__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LLC_BI__Bankr_Templates/LLC_BI__Loan_Closing_Termplate</template>
    </alerts>
    <fieldUpdates>
        <fullName>Interest_Rate_Could_be_fed_from_Pricing</fullName>
        <field>LLC_BI__InterestRate__c</field>
        <formula>0.06</formula>
        <name>Interest Rate (Could be fed from Pricing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__IsApproved</fullName>
        <field>LLC_BI__Is_Approved__c</field>
        <literalValue>1</literalValue>
        <name>IsApproved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__IsOriginalDeclinedLoan</fullName>
        <field>LLC_BI__Is_Original_Inactive_Loan__c</field>
        <literalValue>1</literalValue>
        <name>IsOriginalDeclinedLoan</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__Loan_Balloon_Indicator_Unset</fullName>
        <description>Unset the Loan Balloon Indicator</description>
        <field>LLC_BI__Balloon__c</field>
        <literalValue>0</literalValue>
        <name>Loan Balloon Indicator Unset</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__Loan_Balloon_Indicator_Update</fullName>
        <description>Update the Loan Balloon Indicator</description>
        <field>LLC_BI__Balloon__c</field>
        <literalValue>1</literalValue>
        <name>Loan Balloon Indicator Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__Loan_Lost_MTK</fullName>
        <description>Trigger mailerteamkey for Loan Lost Alert</description>
        <field>LLC_BI__MailerTeamKey__c</field>
        <formula>&quot;LoanLost&quot;</formula>
        <name>Loan Lost - MTK</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__Set_Payoff_Date_on_Paid_Out</fullName>
        <field>LLC_BI__Payoff_Date__c</field>
        <formula>Today()</formula>
        <name>Set Payoff Date on Paid Out</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__UCC_Update_State</fullName>
        <field>LLC_BI__UCC_State__c</field>
        <formula>LLC_BI__CloseDate__c + 1826</formula>
        <name>UCC Update State</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__UpdateLoanStage</fullName>
        <field>LLC_BI__Stage__c</field>
        <literalValue>Processing</literalValue>
        <name>Update Loan Stage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__Update_HMDA_Record_Type</fullName>
        <description>Updates the HMDA Record Type field based on the date.</description>
        <field>LLC_BI__HMDA_Record_Type__c</field>
        <literalValue>HMDA-Effective-2018</literalValue>
        <name>Update HMDA Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__Update_UCC_County</fullName>
        <field>LLC_BI__UCC_County__c</field>
        <formula>LLC_BI__CloseDate__c + 1826</formula>
        <name>Update UCC County</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__Update_isClosed</fullName>
        <field>LLC_BI__isClosed__c</field>
        <literalValue>1</literalValue>
        <name>Update isClosed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__Update_isClosed_to_True</fullName>
        <description>The loan has closed, so update the isClosed stage to true</description>
        <field>LLC_BI__isClosed__c</field>
        <literalValue>1</literalValue>
        <name>Update isClosed to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loan_Class_Renewal</fullName>
        <field>LLC_BI__Loan_Class__c</field>
        <literalValue>Secured Renewal</literalValue>
        <name>Loan Class = Renewal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loan_Credit_Approval_Date_Today</fullName>
        <field>LLC_BI__Credit_Approval_Date__c</field>
        <formula>Today()</formula>
        <name>Loan - Credit Approval Date = Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loan_Default_App_Card</fullName>
        <field>LLC_BI__Default_App__c</field>
        <formula>&quot;card.dashboard-loan&quot;</formula>
        <name>Loan-Default App-Card</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loan_Default_App_Commercial</fullName>
        <field>LLC_BI__Default_App__c</field>
        <formula>&quot;loan1.dashboard-loan&quot;</formula>
        <name>Loan-Default App-Commercial</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loan_Default_App_Construction</fullName>
        <field>LLC_BI__Default_App__c</field>
        <formula>&quot;construction.dashboard-loan&quot;</formula>
        <name>Loan-Default App-Construction</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loan_Default_App_Consumer</fullName>
        <field>LLC_BI__Default_App__c</field>
        <formula>&quot;consumer.dashboard-loan&quot;</formula>
        <name>Loan-Default App-Consumer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loan_Default_App_Lease</fullName>
        <field>LLC_BI__Default_App__c</field>
        <formula>&quot;loan-leasing1.dashboard-loan&quot;</formula>
        <name>Loan-Default App-Lease</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loan_Default_App_SBA</fullName>
        <field>LLC_BI__Default_App__c</field>
        <formula>&quot;sba.dashboard-sba-loan&quot;</formula>
        <name>Loan-Default App-SBA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loan_Feed_Amount_Outstanding</fullName>
        <description>Feeds Principal Balance to Amount Outstanding</description>
        <field>LLC_BI__AmountOutstanding__c</field>
        <formula>LLC_BI__Principal_Balance__c</formula>
        <name>Loan - Feed Amount Outstanding</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loan_Feed_Amount_Unused</fullName>
        <description>Feeds the Amount Unused with the formula Loan Amount - Principal Balance</description>
        <field>LLC_BI__Amount_Unused__c</field>
        <formula>LLC_BI__Amount__c - LLC_BI__Principal_Balance__c</formula>
        <name>Loan - Feed Amount Unused</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loan_Last_Approval_Status_Approved</fullName>
        <field>Last_Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Loan - Last Approval Status = Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loan_Last_Approval_Status_Rejected</fullName>
        <field>Last_Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Loan - Last Approval Status = Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loan_Last_Approval_Status_Removed</fullName>
        <field>Last_Approval_Status__c</field>
        <literalValue>Removed</literalValue>
        <name>Loan - Last Approval Status = Removed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loan_New_Loan_Class_Update</fullName>
        <field>LLC_BI__Loan_Class__c</field>
        <literalValue>New Loan</literalValue>
        <name>Loan - New Loan Class Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loan_RecordType_Leasing</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Loan_Leasing</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Loan-RecordType-Leasing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loan_Record_Type_Card</fullName>
        <description>Updates the record type to Loan - Card.</description>
        <field>RecordTypeId</field>
        <lookupValue>Loan_Card</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Loan - Record Type = Card</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loan_Record_Type_Commercial</fullName>
        <description>Updates the record type to Loan - Commercial.</description>
        <field>RecordTypeId</field>
        <lookupValue>Loan_Commercial</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Loan - Record Type = Commercial</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loan_Record_Type_Construction</fullName>
        <description>Updates the record type to Loan - Construction.</description>
        <field>RecordTypeId</field>
        <lookupValue>Loan_Construction</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Loan - Record Type = Construction</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loan_Record_Type_Consumer</fullName>
        <description>Updates the record type to Loan - Consumer.</description>
        <field>RecordTypeId</field>
        <lookupValue>Loan_Consumer</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Loan - Record Type = Consumer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loan_Record_Type_Mortgage</fullName>
        <description>Updates the record type to Loan - Mortgage.</description>
        <field>RecordTypeId</field>
        <lookupValue>Loan_Mortgage</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Loan - Record Type = Mortgage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loan_Record_Type_New</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Loan_New</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Loan - Record Type = New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loan_Record_Type_Renewal</fullName>
        <description>Updates the record type to Loan - Renewal.</description>
        <field>RecordTypeId</field>
        <lookupValue>Loan_Renewal</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Loan - Record Type = Renewal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loan_Record_Type_SBA</fullName>
        <description>Updates the record type to Loan - SBA.</description>
        <field>RecordTypeId</field>
        <lookupValue>Loan_SBA</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Loan - Record Type = SBA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loan_Stage_Approval_Loan_Committee</fullName>
        <field>LLC_BI__Stage__c</field>
        <literalValue>Approval / Loan Committee</literalValue>
        <name>Loan - Stage = Approval / Loan Committee</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loan_Stage_Booked</fullName>
        <field>LLC_BI__Stage__c</field>
        <literalValue>Booked</literalValue>
        <name>Loan - Stage = Booked</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loan_Stage_Closing</fullName>
        <field>LLC_BI__Stage__c</field>
        <literalValue>Closing</literalValue>
        <name>Loan - Stage = Closing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loan_Stage_Complete</fullName>
        <description>When a Loan is Lost, Withdrawn, Charged-Off or Paid-Out, update the Loan Stage to Complete</description>
        <field>LLC_BI__Stage__c</field>
        <literalValue>Complete</literalValue>
        <name>Loan - Stage = Complete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loan_Stage_Doc_Prep</fullName>
        <field>LLC_BI__Stage__c</field>
        <literalValue>Doc Prep</literalValue>
        <name>Loan - Stage = Doc Prep</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loan_Stage_Doc_Review</fullName>
        <field>LLC_BI__Stage__c</field>
        <literalValue>Doc Review</literalValue>
        <name>Loan - Stage = Doc Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loan_Stage_Processing</fullName>
        <field>LLC_BI__Stage__c</field>
        <literalValue>Processing</literalValue>
        <name>Loan - Stage = Processing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loan_Stage_Proposal</fullName>
        <field>LLC_BI__Stage__c</field>
        <literalValue>Proposal</literalValue>
        <name>Loan - Stage = Proposal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loan_Stage_Qualification_Application</fullName>
        <field>LLC_BI__Stage__c</field>
        <literalValue>Qualification / Application</literalValue>
        <name>Loan - Stage = Qualification/Application</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loan_Stage_Settlement</fullName>
        <field>LLC_BI__Stage__c</field>
        <literalValue>Settlement</literalValue>
        <name>Loan - Stage = Settlement</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loan_Stage_Unconditional_Approval</fullName>
        <field>LLC_BI__Stage__c</field>
        <literalValue>Unconditional Approval/Assessment</literalValue>
        <name>Loan - Stage = Unconditional Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loan_Stage_Underwriting</fullName>
        <field>LLC_BI__Stage__c</field>
        <literalValue>Underwriting</literalValue>
        <name>Loan - Stage = Underwriting</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loan_Stage_Verification_Valuation</fullName>
        <field>LLC_BI__Stage__c</field>
        <literalValue>Verification/Valuation</literalValue>
        <name>Loan - Stage = Verification/Valuation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loan_Unsecured_Amount_Remove</fullName>
        <description>When the Product Type is not Unsecured or Consumer Unsecured, set the Unsecured Amount field to blank</description>
        <field>Unsecured_Amount__c</field>
        <name>Loan - Unsecured Amount - Remove</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loan_Unsecured_Amount_Set</fullName>
        <field>Unsecured_Amount__c</field>
        <formula>LLC_BI__Amount__c</formula>
        <name>Loan - Unsecured Amount - Set</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loan_Update_Loan_Name</fullName>
        <description>Updates the loan name to

Relationship Name - Product Type - Product</description>
        <field>Name</field>
        <formula>LLC_BI__Account__r.Name&amp;&quot; - &quot;&amp;TEXT(LLC_BI__Product_Type__c)&amp;&quot; - &quot;&amp;TEXT(LLC_BI__Product__c)</formula>
        <name>Loan - Update Loan Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loan_Update_Mortgage_Default_App</fullName>
        <field>LLC_BI__Default_App__c</field>
        <formula>&quot;apac-res-mtg-defaultui.loan-detail&quot;</formula>
        <name>Loan - Update Mortgage Default App</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loan_Update_Mortgage_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Loan_Mortgage_APAC</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Loan - Update Mortgage Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loan_Update_RT_for_Sub_Loans</fullName>
        <description>This field update will update the record type on the loan for Limits, Sub Limits, and Takedowns.</description>
        <field>RecordTypeId</field>
        <lookupValue>Loan_Sub_Loan</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Loan - Update RT for Sub Loans</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loan_application_date_today</fullName>
        <field>Application_Date__c</field>
        <formula>Today()</formula>
        <name>Loan application date today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rate_Ceiling_Update</fullName>
        <field>LLC_BI__Rate_Ceiling__c</field>
        <formula>16</formula>
        <name>Rate Ceiling Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rate_Floor_Update</fullName>
        <field>LLC_BI__Rate_Floor__c</field>
        <formula>1.0</formula>
        <name>Rate Floor Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Default_App</fullName>
        <description>Change the Default App to &quot;sba.dashboard-sba-loan&quot;</description>
        <field>LLC_BI__Default_App__c</field>
        <formula>&quot;sba.dashboard-sba-loan&quot;</formula>
        <name>Set Default App</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Stage_Conditional_Approval</fullName>
        <field>LLC_BI__Stage__c</field>
        <literalValue>Conditional Approval/Pre-Approval</literalValue>
        <name>Stage = Conditional Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Stage_Underwriting</fullName>
        <description>Move Loan Stage to Underwriting.</description>
        <field>LLC_BI__Stage__c</field>
        <literalValue>Underwriting</literalValue>
        <name>Stage = Underwriting</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Structure_Update</fullName>
        <field>LLC_BI__Structure__c</field>
        <literalValue>Term Loan/Current</literalValue>
        <name>Structure Hiearchy Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Structure_Update1</fullName>
        <field>LLC_BI__Structure_Hierarchy__c</field>
        <literalValue>Main</literalValue>
        <name>Structure Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Amortized_Term</fullName>
        <field>LLC_BI__Amortized_Term_Months__c</field>
        <formula>240</formula>
        <name>Update Amortized Term</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Amount_Outstanding</fullName>
        <field>LLC_BI__AmountOutstanding__c</field>
        <formula>LLC_BI__Principal_Balance__c</formula>
        <name>Update Amount Outstanding</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Booked_Date</fullName>
        <description>Time stamp date</description>
        <field>LLC_BI__Booked_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update Booked Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Closed_Date</fullName>
        <description>Time stamp</description>
        <field>LLC_BI__Closed_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update Closed Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_First_Payment_Date</fullName>
        <field>LLC_BI__First_Payment_Date__c</field>
        <formula>LLC_BI__CloseDate__c + 30</formula>
        <name>Update First Payment Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_HMDA_record_type_2017</fullName>
        <description>Updates HMDA record type to 2017 if loan is made reportable.</description>
        <field>LLC_BI__HMDA_Record_Type__c</field>
        <literalValue>HMDA-Effective-2018</literalValue>
        <name>Update HMDA record type 2017</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_IsClosed</fullName>
        <description>Simply updates the isClosed checkbox that is a custom field. Now you wouldn&apos;t normally use this because product state config should update the formula checkbox automatically....</description>
        <field>LLC_BI__isClosed__c</field>
        <literalValue>1</literalValue>
        <name>Update IsClosed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Queue_Underwriting</fullName>
        <field>CSA_Queue__c</field>
        <literalValue>Underwriting</literalValue>
        <name>Update Queue Underwriting</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type_Card</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Loan_Card</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type Card</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type_to_EMEA_Mortgage</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Loan_AIP</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type to EMEA Mortgage(AIP)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Term_in_Months</fullName>
        <field>LLC_BI__Term_Months__c</field>
        <formula>60</formula>
        <name>Update Term in Months</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_default_Mortgage</fullName>
        <field>LLC_BI__Default_App__c</field>
        <formula>&quot;res-mtg-app.res-mtg-app-borrower-info&quot;</formula>
        <name>Update default app to Mortgage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_default_app</fullName>
        <field>LLC_BI__Default_App__c</field>
        <formula>&quot;branch.dashboard-loan&quot;</formula>
        <name>Update default app</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_default_app_to_Mortgage</fullName>
        <field>LLC_BI__Default_App__c</field>
        <formula>&apos;loanaip.dashboard-loan&apos;</formula>
        <name>Update default app to Mortgage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_is_Review_Ready_upon_approval</fullName>
        <description>update is Review Ready post loan approval</description>
        <field>LLC_BI__Is_Review_Ready__c</field>
        <literalValue>1</literalValue>
        <name>Update is Review Ready upon approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>**Loan - Update fields for demonstration purposes</fullName>
        <actions>
            <name>Interest_Rate_Could_be_fed_from_Pricing</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Loan_application_date_today</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Structure_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Structure_Update1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Amortized_Term</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Term_in_Months</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>LLC_BI__Loan__c.Name</field>
            <operation>notEqual</operation>
            <value>null</value>
        </criteriaItems>
        <criteriaItems>
            <field>LLC_BI__Loan__c.LLC_BI__Product_Line__c</field>
            <operation>equals</operation>
            <value>Commercial</value>
        </criteriaItems>
        <criteriaItems>
            <field>LLC_BI__Loan__c.LLC_BI__Amount__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <description>Updates the application date today (although that is subjective based on organization), updates the term in months and the amortized term to facilitate ease of use of payment streams.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Card transition to Underwriting</fullName>
        <actions>
            <name>Card_Application_has_been_Submitted_Please_review</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LLC_BI__Loan__c.LLC_BI__Stage__c</field>
            <operation>equals</operation>
            <value>Underwriting</value>
        </criteriaItems>
        <criteriaItems>
            <field>LLC_BI__Loan__c.LLC_BI__Product_Line__c</field>
            <operation>equals</operation>
            <value>Business Card,Personal Card</value>
        </criteriaItems>
        <description>Based on the criteria, notify the loan team that the loan stage has been changed to underwriting and product line = &apos;Card&apos;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Client Acceptance Task</fullName>
        <actions>
            <name>Client_has_accepted_the_deal_please_engage_attorney</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <description>This is used to replace the Client_Acceptance button to create a task when the loan stage is &quot;Processing&quot;.</description>
        <formula>AND(ISPICKVAL(LLC_BI__Stage__c , &quot;Processing&quot;), ISPICKVAL(LLC_BI__Product_Type__c , &quot;Real Estate&quot;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Default HMDA record type</fullName>
        <actions>
            <name>Update_HMDA_record_type_2017</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LLC_BI__Loan__c.LLC_BI__HMDA_Reportable__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>When the loan is HMDA reportable, it will default the HMDA record type to 2017 unless otherwise specified.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LLC_BI__Alert on Lead Converted into Loan</fullName>
        <actions>
            <name>LLC_BI__Notify_Roles_of_Lead_Conversion_into_Loan</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>LLC_BI__Loan__c.LLC_BI__isConvert__c</field>
            <operation>equals</operation>
            <value>1</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LLC_BI__HMDA Record Type Check</fullName>
        <actions>
            <name>LLC_BI__Update_HMDA_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets the HMDA Record Type field based on the current date</description>
        <formula>TODAY()  &gt;=  DATE(2018,01,01)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>LLC_BI__Loan Closing Alert</fullName>
        <actions>
            <name>LLC_BI__Loan_Closing_E_mail_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>LLC_BI__Update_isClosed_to_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>LLC_BI__Loan__c.LLC_BI__Stage__c</field>
            <operation>equals</operation>
            <value>Closed Funded</value>
        </criteriaItems>
        <criteriaItems>
            <field>LLC_BI__Loan__c.LLC_BI__isClosed__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <description>When a loan is set to &quot;Closed Funded&quot; (Update for equivalent) send out the loan closing e-mail alert.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LLC_BI__Loan In Closing Stages</fullName>
        <active>false</active>
        <criteriaItems>
            <field>LLC_BI__Loan__c.LLC_BI__Stage__c</field>
            <operation>equals</operation>
            <value>Closing</value>
        </criteriaItems>
        <description>Notify respective loan administration / closers and loan team that the loan was moved to closing.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LLC_BI__Loan Set Balloon Indicator</fullName>
        <actions>
            <name>LLC_BI__Loan_Balloon_Indicator_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set the Loan Balloon indicator when the Amortization Period (Months) and the Term (Months) are different.</description>
        <formula>AND( ISPICKVAL(LLC_BI__Balloon_Product_Structure__c, &apos;&apos;),   OR ( ISCHANGED( LLC_BI__Amortized_Term_Months__c ) , ISCHANGED( LLC_BI__Term_Months__c )),   (LLC_BI__Amortized_Term_Months__c &lt;&gt;  LLC_BI__Term_Months__c) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LLC_BI__Loan Un-set Balloon Indicator</fullName>
        <actions>
            <name>LLC_BI__Loan_Balloon_Indicator_Unset</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Un-set the Loan Balloon indicator when the Amortization Period (Months) and the Term (Months) are the same.</description>
        <formula>AND( ISPICKVAL(LLC_BI__Balloon_Product_Structure__c, &apos;&apos;), OR ( ISCHANGED( LLC_BI__Amortized_Term_Months__c ) , ISCHANGED( LLC_BI__Term_Months__c )),  OR(IF(OR( ISBLANK(LLC_BI__Amortized_Term_Months__c), ISBLANK(LLC_BI__Term_Months__c)) , True, False),  (LLC_BI__Amortized_Term_Months__c  =  LLC_BI__Term_Months__c) ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LLC_BI__Loan Was Lost</fullName>
        <actions>
            <name>LLC_BI__Loan_Lost_MTK</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>LLC_BI__Loan__c.LLC_BI__Stage__c</field>
            <operation>equals</operation>
            <value>Complete</value>
        </criteriaItems>
        <criteriaItems>
            <field>LLC_BI__Loan__c.LLC_BI__Status__c</field>
            <operation>equals</operation>
            <value>Withdrawn</value>
        </criteriaItems>
        <description>When a loan stage is complete and the status is lost</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LLC_BI__Loan Withdrawn %2F Declined</fullName>
        <actions>
            <name>LLC_BI__Alert_Loan_Withdrawn_Declined</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>LLC_BI__Loan__c.LLC_BI__Stage__c</field>
            <operation>equals</operation>
            <value>Complete</value>
        </criteriaItems>
        <criteriaItems>
            <field>LLC_BI__Loan__c.LLC_BI__Status__c</field>
            <operation>equals</operation>
            <value>Withdrawn,Declined</value>
        </criteriaItems>
        <description>Notify appropriate individuals / department (loan ops)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LLC_BI__Loan Withdrawn Declined Product Package</fullName>
        <actions>
            <name>LLC_BI__IsOriginalDeclinedLoan</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>LLC_BI__Loan__c.LLC_BI__Status__c</field>
            <operation>equals</operation>
            <value>Withdrawn,Paid Out,Declined</value>
        </criteriaItems>
        <description>Sets the original declined loan field when a loan is loaded with declined or withdrawn status.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LLC_BI__Notify Loan Stage Change</fullName>
        <active>false</active>
        <criteriaItems>
            <field>LLC_BI__Loan__c.LLC_BI__Stage__c</field>
            <operation>equals</operation>
            <value>Loan Committee,Credit Underwriting,Processing,Doc Review,Doc Prep,Closing</value>
        </criteriaItems>
        <description>Based on the criteria, notify the loan team that the loan stage has been changed.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LLC_BI__On Closed Set isClosed</fullName>
        <actions>
            <name>LLC_BI__Update_isClosed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>LLC_BI__Loan__c.LLC_BI__Stage__c</field>
            <operation>equals</operation>
            <value>Closed Funded</value>
        </criteriaItems>
        <description>For simpler reporting purposes, if the loan has been closed at any point, set isClosed.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LLC_BI__Reviewed By Quality</fullName>
        <actions>
            <name>LLC_BI__Notify_Loan_Reviewed_by_Quality_Compliance</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>LLC_BI__Loan__c.LLC_BI__Reviewed_by_Compliance__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Loan has been reviewed by compliance</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LLC_BI__Set Payoff Date</fullName>
        <actions>
            <name>LLC_BI__Set_Payoff_Date_on_Paid_Out</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>LLC_BI__Loan__c.LLC_BI__Status__c</field>
            <operation>equals</operation>
            <value>Paid Out</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LLC_BI__Stage Change to Compliance</fullName>
        <active>false</active>
        <criteriaItems>
            <field>LLC_BI__Loan__c.LLC_BI__Stage__c</field>
            <operation>equals</operation>
            <value>Compliance</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.UserRoleId</field>
            <operation>notEqual</operation>
            <value>Compliance</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LLC_BI__Update UCC Dates</fullName>
        <actions>
            <name>LLC_BI__UCC_Update_State</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LLC_BI__Update_UCC_County</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>LLC_BI__Loan__c.LLC_BI__Stage__c</field>
            <operation>equals</operation>
            <value>Closed Funded,Closed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Loan - Feed Amount Outstanding</fullName>
        <actions>
            <name>Loan_Feed_Amount_Outstanding</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(LastModifiedDate)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Loan - Feed Amount Unused</fullName>
        <actions>
            <name>Loan_Feed_Amount_Unused</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(LastModifiedDate)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Loan - New Loan Class Update</fullName>
        <actions>
            <name>Loan_New_Loan_Class_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LLC_BI__Loan__c.LLC_BI__isRenewal__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Loan - Record Type %3D Card</fullName>
        <actions>
            <name>Update_Record_Type_Card</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LLC_BI__Loan__c.LLC_BI__Product_Line__c</field>
            <operation>equals</operation>
            <value>Business Card,Personal Card</value>
        </criteriaItems>
        <description>Updates the record type to Loan - Card when &quot;Card&quot; is chosen as the product line.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Loan - Record Type %3D Mortgage</fullName>
        <actions>
            <name>Loan_Record_Type_Mortgage</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LLC_BI__Loan__c.LLC_BI__Product_Line__c</field>
            <operation>equals</operation>
            <value>Mortgage System</value>
        </criteriaItems>
        <criteriaItems>
            <field>LLC_BI__Loan__c.Submitted_to_Underwriting__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Updates the record type to Loan - Mortgage when &quot;Mortgage&quot; is chosen as the product line.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Loan - Rename Loan</fullName>
        <actions>
            <name>Loan_Update_Loan_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This rule renames the loan upon creation as long as</description>
        <formula>AND( ISPICKVAL(LLC_BI__Product_Line__c, &apos;Consumer&apos;) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Loan - Renewal Loan Class Update</fullName>
        <actions>
            <name>Loan_Class_Renewal</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LLC_BI__Loan__c.LLC_BI__isRenewal__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Loan - Stage %3D Complete</fullName>
        <actions>
            <name>Loan_Stage_Complete</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LLC_BI__Loan__c.LLC_BI__Status__c</field>
            <operation>equals</operation>
            <value>Withdrawn,Charge-Off,Paid Out,Lost</value>
        </criteriaItems>
        <description>When a Loan is Lost, Withdrawn, Charged-Off or Paid-Out, update the Loan Stage to Complete</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Loan - Update Default App -  Card</fullName>
        <actions>
            <name>Loan_Default_App_Card</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LLC_BI__Loan__c.LLC_BI__Product_Line__c</field>
            <operation>equals</operation>
            <value>Business Card,Personal Card</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Loan - Update Default App -  Consumer</fullName>
        <actions>
            <name>Loan_Default_App_Consumer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LLC_BI__Loan__c.LLC_BI__Product_Line__c</field>
            <operation>equals</operation>
            <value>Consumer</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Loan - Update Default App -  SBA</fullName>
        <actions>
            <name>Loan_Default_App_SBA</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LLC_BI__Loan__c.LLC_BI__Product_Line__c</field>
            <operation>equals</operation>
            <value>SBA</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Loan - Update Default App - Commercial</fullName>
        <actions>
            <name>Loan_Default_App_Commercial</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LLC_BI__Loan__c.LLC_BI__Product_Line__c</field>
            <operation>equals</operation>
            <value>Commercial</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Loan - Update RT for Sub Loans</fullName>
        <actions>
            <name>Loan_Update_RT_for_Sub_Loans</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule will update the record type on the loans that are a Limit, Sub Limit, or Takedown.</description>
        <formula>LLC_BI__ParentLoan__c &lt;&gt; NULL</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Loan - Update Record Type %26 Default App - AIP</fullName>
        <actions>
            <name>Stage_Conditional_Approval</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Record_Type_to_EMEA_Mortgage</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_default_app_to_Mortgage</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LLC_BI__Loan__c.LLC_BI__Product__c</field>
            <operation>equals</operation>
            <value>AIP</value>
        </criteriaItems>
        <description>If the Product is AIP, this workflow rule updates the record type to AIP(EMEA) and it also updates the default app on the screen to AIP group UI.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Loan - Update Record Type %26 Default App - Mortgage APAC</fullName>
        <actions>
            <name>Loan_Update_Mortgage_Default_App</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Loan_Update_Mortgage_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Stage_Conditional_Approval</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LLC_BI__Loan__c.LLC_BI__Product_Type__c</field>
            <operation>equals</operation>
            <value>APAC,APAC - Purchase</value>
        </criteriaItems>
        <description>This is for APAC Mortgage Updates</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Loan - isCopy - Stage %3D Qualification %2F Application</fullName>
        <actions>
            <name>Loan_Stage_Qualification_Application</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LLC_BI__Loan__c.LLC_BI__Is_Copy__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Loan Amount Outstanding Updated by Principal Balance</fullName>
        <actions>
            <name>Update_Amount_Outstanding</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LLC_BI__Loan__c.LLC_BI__Principal_Balance__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Loan Mortgages</fullName>
        <actions>
            <name>Update_default_Mortgage</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LLC_BI__Loan__c.LLC_BI__Product_Type__c</field>
            <operation>equals</operation>
            <value>EMEA</value>
        </criteriaItems>
        <criteriaItems>
            <field>LLC_BI__Loan__c.LLC_BI__Product__c</field>
            <operation>notEqual</operation>
            <value>AIP</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Loan transitioned to underwriting</fullName>
        <actions>
            <name>Update_Queue_Underwriting</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Loan_is_now_in_underwriting_please</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Loan_is_now_in_underwriting_please_begin_financial_analysis</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Loan_is_now_in_underwriting_please_perform_collateral_analysis</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LLC_BI__Loan__c.LLC_BI__Stage__c</field>
            <operation>equals</operation>
            <value>Underwriting</value>
        </criteriaItems>
        <criteriaItems>
            <field>LLC_BI__Loan__c.LLC_BI__Product_Line__c</field>
            <operation>equals</operation>
            <value>Commercial,SBA,Consumer,Leasing and Finance</value>
        </criteriaItems>
        <description>Based on the criteria, notify the loan team that the loan stage has been changed to underwriting.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Loan- HELOC%2FHELOAN Initial Tasks</fullName>
        <actions>
            <name>Gather_Flood_Determination</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Gather_Insurance_Information</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Schedule_Appraisal_and_Gather_Fees</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LLC_BI__Loan__c.LLC_BI__Product_Type__c</field>
            <operation>equals</operation>
            <value>Consumer - HELOC,Consumer - Home Equity Term Loan</value>
        </criteriaItems>
        <criteriaItems>
            <field>LLC_BI__Loan__c.LLC_BI__Stage__c</field>
            <operation>equals</operation>
            <value>Processing</value>
        </criteriaItems>
        <description>Tasks are created to gather Insurance, Flood Determination and Appraisal when a HELOC / HELOAN Loan is created</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Loan-Default App-Lease</fullName>
        <actions>
            <name>Loan_Default_App_Lease</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Loan_RecordType_Leasing</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LLC_BI__Loan__c.LLC_BI__Product_Line__c</field>
            <operation>equals</operation>
            <value>Leasing and Finance</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Low Touch Move to UW</fullName>
        <actions>
            <name>Stage_Underwriting</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(OR(LLC_BI__Auto_Decision_Status__c = &apos;Approved&apos;, LLC_BI__Auto_Decision_Status__c = &apos;Recommend Approval&apos;), Authorization_to_pull_credit__c = TRUE,  ISPICKVAL(PRIORVALUE(LLC_BI__Stage__c),&quot;Qualification / Application&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send to Doc Prep Task</fullName>
        <actions>
            <name>Please_perform_documentation_preparation</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <description>This creates the Doc Prep task when the loan&apos;s stage has been updated to Document Prep via the &quot;Send to Doc Prep&quot; button.</description>
        <formula>ISPICKVAL( LLC_BI__Stage__c , &quot;Doc Prep&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Booked %26 Closed Date</fullName>
        <actions>
            <name>Update_Booked_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Closed_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_IsClosed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LLC_BI__Loan__c.LLC_BI__Stage__c</field>
            <operation>equals</operation>
            <value>Booked</value>
        </criteriaItems>
        <description>This workflow rule sets the booked date &amp; closed date when the stage is changed to Booked.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Trigger Forbearence tasks</fullName>
        <actions>
            <name>Financial_Analysis_and_Facility_Review</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LLC_BI__Loan__c.Loan_in_Arrears__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>When &apos;Loan in Arrears&apos; field is True, this workflow rule triggers a reminder task to the Loan Owner</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Unsecured Product Amount</fullName>
        <actions>
            <name>Loan_Unsecured_Amount_Set</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LLC_BI__Loan__c.LLC_BI__Product_Type__c</field>
            <operation>equals</operation>
            <value>Unsecured,Business Rewards,Personal Rewards,Business No Rewards,Personal No Rewards,Consumer - Unsecured LOC,Consumer - Unsecured Term</value>
        </criteriaItems>
        <description>DO NOT DEACTIVATE. Update the Unsecured Amount when Product = Unsecured. This is part of the Approval Processes!</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Unsecured Product Amount - Remove%21%21</fullName>
        <actions>
            <name>Loan_Unsecured_Amount_Remove</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LLC_BI__Loan__c.LLC_BI__Product_Type__c</field>
            <operation>equals</operation>
            <value>Real Estate,Non-Real Estate,Consumer - HELOC,Consumer - Recreational Vehicle,Consumer - Vehicle,7(a),504,Mortgage Loans-From Source System</value>
        </criteriaItems>
        <description>DO NOT DEACTIVATE - When the Product Type is not Unsecured or Consumer Unsecured, set the Unsecured Amount field to blank</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update First Payment Date</fullName>
        <actions>
            <name>Update_First_Payment_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LLC_BI__Loan__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Updates first payment date to close date + 30 to help with AM schedules</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>Card_Application_has_been_Submitted_Please_review</fullName>
        <assignedTo>peter.s@autorabitncinodemo.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Card Application has been Submitted. Please review.</subject>
    </tasks>
    <tasks>
        <fullName>Client_has_accepted_the_deal_please_engage_attorney</fullName>
        <assignedTo>peter.s@autorabitncinodemo.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Client has accepted the deal, please engage attorney.</subject>
    </tasks>
    <tasks>
        <fullName>Financial_Analysis_and_Facility_Review</fullName>
        <assignedToType>owner</assignedToType>
        <description>Please review the Financials for the client due to missed payments.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Financial Analysis and Facility Review</subject>
    </tasks>
    <tasks>
        <fullName>Gather_Flood_Determination</fullName>
        <assignedTo>peter.s@autorabitncinodemo.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Gather Flood Determination</subject>
    </tasks>
    <tasks>
        <fullName>Gather_Insurance_Information</fullName>
        <assignedTo>peter.s@autorabitncinodemo.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Gather Insurance Information</subject>
    </tasks>
    <tasks>
        <fullName>Loan_has_been_approved_Please_verify_client_acceptance</fullName>
        <assignedTo>peter.s@autorabitncinodemo.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Loan has been approved. Please verify client acceptance</subject>
    </tasks>
    <tasks>
        <fullName>Loan_has_changed_stages_please_review</fullName>
        <assignedTo>peter.s@autorabitncinodemo.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Loan has changed stages, please review</subject>
    </tasks>
    <tasks>
        <fullName>Loan_has_failed_minimum_scorecard_standards_Adverse_Action_Required</fullName>
        <assignedTo>peter.s@autorabitncinodemo.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Loan has failed minimum scorecard standards - Adverse Action Required</subject>
    </tasks>
    <tasks>
        <fullName>Loan_is_now_in_underwriting_please</fullName>
        <assignedTo>peter.s@autorabitncinodemo.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Loan is now in underwriting, please order consumer credit report for personal guarantors.</subject>
    </tasks>
    <tasks>
        <fullName>Loan_is_now_in_underwriting_please_begin_financial_analysis</fullName>
        <assignedTo>peter.s@autorabitncinodemo.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Loan is now in underwriting, please begin financial analysis.</subject>
    </tasks>
    <tasks>
        <fullName>Loan_is_now_in_underwriting_please_perform_collateral_analysis</fullName>
        <assignedTo>peter.s@autorabitncinodemo.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Loan is now in underwriting, please perform collateral analysis.</subject>
    </tasks>
    <tasks>
        <fullName>Online_Application_has_been_approved_Please_verify</fullName>
        <assignedTo>peter.s@autorabitncinodemo.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Online Application has been approved. Please verify</subject>
    </tasks>
    <tasks>
        <fullName>Please_perform_documentation_preparation</fullName>
        <assignedTo>peter.s@autorabitncinodemo.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Please perform documentation preparation.</subject>
    </tasks>
    <tasks>
        <fullName>Schedule_Appraisal_and_Gather_Fees</fullName>
        <assignedTo>peter.s@autorabitncinodemo.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Schedule Appraisal and Gather Fees</subject>
    </tasks>
    <tasks>
        <fullName>Test_Task</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Test Task</subject>
    </tasks>
</Workflow>