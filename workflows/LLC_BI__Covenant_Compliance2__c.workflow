<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Approval_Date_Today</fullName>
        <description>Approval Date = Today</description>
        <field>LLC_BI__Approval_Date__c</field>
        <formula>Today()</formula>
        <name>Approval Date = Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Date_Today2</fullName>
        <field>LLC_BI__Approval_Date__c</field>
        <formula>Today()</formula>
        <name>Approval Date - today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approved_By_Approver</fullName>
        <field>LLC_BI__Approved_By__c</field>
        <lookupValue>peter.s@autorabitncinodemo.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Approved By = Approver</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approved_By_Pierre</fullName>
        <field>LLC_BI__Approved_By__c</field>
        <lookupValue>demomastertest.2j708bheislu@autorabitncinodemo.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Approved By = Pierre</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Auto_Approval_admin</fullName>
        <field>LLC_BI__Approved_By__c</field>
        <lookupValue>peter.s@autorabitncinodemo.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Auto Approval - admin</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Auto_Approved_True</fullName>
        <field>Auto_Approved__c</field>
        <literalValue>1</literalValue>
        <name>Auto Approved = True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Cov_Compliance_Excepti1on_Date_Today</fullName>
        <field>LLC_BI__Exception_Date__c</field>
        <formula>Today()</formula>
        <name>Cov Compliance - Exception Date = Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Cov_Compliance_Exception_Date_Today</fullName>
        <field>LLC_BI__Exception_Date__c</field>
        <formula>Today()</formula>
        <name>Cov Compliance - Exception Date = Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Cov_Compliance_Status_Compliant</fullName>
        <field>LLC_BI__Status__c</field>
        <literalValue>Compliant</literalValue>
        <name>Cov Compliance - Status = Compliant</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Cov_Compliance_Status_Exception</fullName>
        <field>LLC_BI__Status__c</field>
        <literalValue>Exception</literalValue>
        <name>Cov Compliance - Status = Exception</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Cove_Compliance_status_rejection2</fullName>
        <field>LLC_BI__Status__c</field>
        <literalValue>Exception</literalValue>
        <name>Cove Compliance - status rejection2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Coven_Compliance_Exception_Date_today</fullName>
        <field>LLC_BI__Exception_Date__c</field>
        <formula>Today()</formula>
        <name>Coven Compliance Exception Date today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Covenant_Compliance_Exception_Date_t</fullName>
        <field>LLC_BI__Exception_Date__c</field>
        <formula>Today()</formula>
        <name>Covenant Compliance - Exception Date = t</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Covenant_Compliance_Status_Exception</fullName>
        <field>LLC_BI__Status__c</field>
        <literalValue>Exception</literalValue>
        <name>Covenant Compliance - Status = Exception</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Evaluated_By</fullName>
        <field>LLC_BI__Evaluated_By__c</field>
        <lookupValue>peter.s@autorabitncinodemo.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Evaluated By</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Evaluation_date_today</fullName>
        <field>LLC_BI__Evaluation_Date__c</field>
        <formula>Today()</formula>
        <name>Evaluation date = today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__Covenant2_Update_Last_Evaluation_Status</fullName>
        <description>Update the last evaluation status on the Covenant2 object.</description>
        <field>LLC_BI__Last_Evaluation_Status__c</field>
        <formula>Text(LLC_BI__Status__c)</formula>
        <name>Covenant2 Update Last Evaluation Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>LLC_BI__Covenant__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__Covenant_Update_Last_Evaluation_Status</fullName>
        <description>Update the last evaluation status on the Covenant2 object.</description>
        <field>LLC_BI__Last_Evaluation_Status__c</field>
        <formula>Text(LLC_BI__Status__c)</formula>
        <name>Covenant Update Last Evaluation Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>LLC_BI__Covenant__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__Set_Covenant_Compliance_Exception_Date</fullName>
        <field>LLC_BI__Exception_Date__c</field>
        <formula>TODAY()</formula>
        <name>Set Covenant Compliance Exception Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__Set_Covenant_Compliance_Status_Compliant</fullName>
        <field>LLC_BI__Status__c</field>
        <literalValue>Compliant</literalValue>
        <name>Set Covenant Compliance Status Compliant</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__Set_Covenant_Compliance_Status_Exception</fullName>
        <field>LLC_BI__Status__c</field>
        <literalValue>Exception</literalValue>
        <name>Set Covenant Compliance Status Exception</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__Set_Historic_Financial_Indicator_Value</fullName>
        <description>Historic Financial Indicator Value to the value of the Financial Indicator Value of the related Covenant2 record</description>
        <field>LLC_BI__Historic_Financial_Indicator__c</field>
        <formula>LLC_BI__Covenant__r.LLC_BI__Financial_Indicator_Value__c</formula>
        <name>Set_Historic_Financial_Indicator_Value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__Update_Last_Evaluation_Date</fullName>
        <description>Update Last Evaluation Date on the Covenant2 object when it changes on the Covenant Compliance2 object.</description>
        <field>LLC_BI__Last_Evaluation_Date__c</field>
        <formula>LLC_BI__Evaluation_Date__c</formula>
        <name>Update Last Evaluation Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>LLC_BI__Covenant__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__Update_Last_Evaluation_Status</fullName>
        <description>Update the Evaluation Status on the Covenant2 with the status on the Covenant Compliance2 record.</description>
        <field>LLC_BI__Last_Evaluation_Status__c</field>
        <formula>Text( LLC_BI__Status__c )</formula>
        <name>Update Last Evaluation Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>LLC_BI__Covenant__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__Update_Last_Reviewed_Date</fullName>
        <description>Update the Last Evaluation Date on the Covenant2 Object when the review date changes</description>
        <field>LLC_BI__Last_Evaluation_Date__c</field>
        <formula>LLC_BI__Evaluation_Date__c</formula>
        <name>Update Last Evaluation Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>LLC_BI__Covenant__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__Update_Next_Evaluation_Date</fullName>
        <description>Update the Covenant Compliance2 next evaluation date when the underlying covenant2 is marked compliant.</description>
        <field>LLC_BI__Next_Evaluation_Date__c</field>
        <formula>
DATE(
	YEAR(LLC_BI__Covenant__r.LLC_BI__Next_Evaluation_Date__c) +
		FLOOR((MONTH(LLC_BI__Covenant__r.LLC_BI__Next_Evaluation_Date__c) + LLC_BI__Covenant__r.LLC_BI__Frequency_Months__c) / 12) +
		IF(
			MOD(MONTH(LLC_BI__Covenant__r.LLC_BI__Next_Evaluation_Date__c) + LLC_BI__Covenant__r.LLC_BI__Frequency_Months__c, 12) = 0,
			-1,
			0
		),
	IF(
		MOD(MONTH(LLC_BI__Covenant__r.LLC_BI__Next_Evaluation_Date__c) + LLC_BI__Covenant__r.LLC_BI__Frequency_Months__c, 12) = 0,
		12,
		MOD(MONTH(LLC_BI__Covenant__r.LLC_BI__Next_Evaluation_Date__c) + LLC_BI__Covenant__r.LLC_BI__Frequency_Months__c , 12)
	),
	IF(
		IF(
			MONTH(LLC_BI__Covenant__r.LLC_BI__Next_Evaluation_Date__c) = 12,
			DATE(YEAR(LLC_BI__Covenant__r.LLC_BI__Next_Evaluation_Date__c), 12, 31),
			DATE(YEAR(LLC_BI__Covenant__r.LLC_BI__Next_Evaluation_Date__c), MONTH(LLC_BI__Covenant__r.LLC_BI__Next_Evaluation_Date__c) + 1, 1) - 1 
		) = LLC_BI__Covenant__r.LLC_BI__Next_Evaluation_Date__c,
		CASE(
			IF(
				MOD(MONTH(LLC_BI__Covenant__r.LLC_BI__Next_Evaluation_Date__c) + LLC_BI__Covenant__r.LLC_BI__Frequency_Months__c, 12) = 0,
				12,
				MOD(MONTH(LLC_BI__Covenant__r.LLC_BI__Next_Evaluation_Date__c) + LLC_BI__Covenant__r.LLC_BI__Frequency_Months__c , 12)
			),
			2, IF(
				MOD(
					YEAR(LLC_BI__Covenant__r.LLC_BI__Next_Evaluation_Date__c) +
						FLOOR((MONTH(LLC_BI__Covenant__r.LLC_BI__Next_Evaluation_Date__c) + LLC_BI__Covenant__r.LLC_BI__Frequency_Months__c) / 12) +
						IF(
							MOD(MONTH(LLC_BI__Covenant__r.LLC_BI__Next_Evaluation_Date__c) + LLC_BI__Covenant__r.LLC_BI__Frequency_Months__c, 12) = 0,
							-1,
							0
						),
					4
				) = 0,
				29,
				28
			),
			4,30,
			6,30,
			9,30,
			11,30,
			31
		),
		MIN(
			DAY(LLC_BI__Covenant__r.LLC_BI__Next_Evaluation_Date__c),
			CASE(
				IF(
					MOD(MONTH(LLC_BI__Covenant__r.LLC_BI__Next_Evaluation_Date__c) + LLC_BI__Covenant__r.LLC_BI__Frequency_Months__c, 12) = 0,
					12,
					MOD(MONTH(LLC_BI__Covenant__r.LLC_BI__Next_Evaluation_Date__c) + LLC_BI__Covenant__r.LLC_BI__Frequency_Months__c , 12)
				),
				2, IF(
					MOD(
						YEAR(LLC_BI__Covenant__r.LLC_BI__Next_Evaluation_Date__c) +
							FLOOR((MONTH(LLC_BI__Covenant__r.LLC_BI__Next_Evaluation_Date__c) + LLC_BI__Covenant__r.LLC_BI__Frequency_Months__c) / 12) +
							IF(
								MOD(MONTH(LLC_BI__Covenant__r.LLC_BI__Next_Evaluation_Date__c) + LLC_BI__Covenant__r.LLC_BI__Frequency_Months__c, 12) = 0,
								-1,
								0
							),
						4
					) = 0,
					29,
					28
				),
				4,30,
				6,30,
				9,30,
				11,30,
				31
			)
		)
	)
)</formula>
        <name>Update Next Evaluation Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>LLC_BI__Covenant__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Exception</fullName>
        <field>LLC_BI__Status__c</field>
        <literalValue>Exception</literalValue>
        <name>Status = Exception</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Pending</fullName>
        <description>Status = Pending</description>
        <field>LLC_BI__Status__c</field>
        <literalValue>Pending</literalValue>
        <name>Status = Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Pending2</fullName>
        <field>LLC_BI__Status__c</field>
        <literalValue>Pending</literalValue>
        <name>Status = Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Covenant_Status</fullName>
        <field>LLC_BI__Last_Evaluation_Status__c</field>
        <formula>TEXT(LLC_BI__Status__c)</formula>
        <name>Update Covenant Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>LLC_BI__Covenant__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>LLC_BI__Covenant Compliance Set Last Evaluation Status</fullName>
        <actions>
            <name>LLC_BI__Covenant_Update_Last_Evaluation_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LLC_BI__Update_Last_Evaluation_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set the last evaluation status on the Covenant2 object when it gets updated on the Covenant Compliance2 object.</description>
        <formula>ISCHANGED( LLC_BI__Status__c ) || ISNEW()</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LLC_BI__Covenant Compliance Set Next Evaluation Date</fullName>
        <actions>
            <name>LLC_BI__Update_Next_Evaluation_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update the next Covenant Compliance2 evaluation date based on the frequency and the last scheduled evaluation date.</description>
        <formula>OR(         AND(         ISPICKVAL(PRIORVALUE(LLC_BI__Status__c),&quot;Pending&quot;),         OR(         ISPICKVAL(LLC_BI__Status__c, &quot;Compliant&quot;),         ISPICKVAL(LLC_BI__Status__c, &quot;Waived&quot;)         )         ),         AND(         ISPICKVAL(LLC_BI__Status__c, &apos;Exception&apos;),         ISPICKVAL(PRIORVALUE(LLC_BI__Status__c),&quot;Pending&quot;)         )         )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LLC_BI__Covenant Compliance Update Last Evaluation Date</fullName>
        <actions>
            <name>LLC_BI__Update_Last_Evaluation_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LLC_BI__Update_Last_Reviewed_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update the Last Evaluation Date on the Covenant2 Object when a covenant is reviewed</description>
        <formula>ISCHANGED( LLC_BI__Evaluation_Date__c ) || ISNEW()</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LLC_BI__Financial Covenant Compliance Compliant</fullName>
        <actions>
            <name>LLC_BI__Set_Covenant_Compliance_Status_Compliant</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>LLC_BI__Covenant_Compliance2__c.LLC_BI__Evaluation_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>LLC_BI__Covenant_Compliance2__c.LLC_BI__Associated_Statement_Period_Status__c</field>
            <operation>equals</operation>
            <value>Associated</value>
        </criteriaItems>
        <criteriaItems>
            <field>LLC_BI__Covenant_Compliance2__c.LLC_BI__Automated_Testing_Status__c</field>
            <operation>equals</operation>
            <value>Pass</value>
        </criteriaItems>
        <description>When Spreads automated testing evaluates a Covenant_Compliance2 record to have complete data or pass a Covenant rule, this sets the Status to Compliant.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LLC_BI__Financial Covenant Compliance Exception</fullName>
        <actions>
            <name>LLC_BI__Set_Covenant_Compliance_Exception_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LLC_BI__Set_Covenant_Compliance_Status_Exception</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>LLC_BI__Covenant_Compliance2__c.LLC_BI__Evaluation_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>LLC_BI__Covenant_Compliance2__c.LLC_BI__Associated_Statement_Period_Status__c</field>
            <operation>equals</operation>
            <value>Unassociated</value>
        </criteriaItems>
        <criteriaItems>
            <field>LLC_BI__Covenant_Compliance2__c.LLC_BI__Automated_Testing_Status__c</field>
            <operation>equals</operation>
            <value>Fail,Incomplete</value>
        </criteriaItems>
        <description>When Spreads automated testing evaluates a Covenant_Compliance2 record to have incomplete data or fail a Covenant rule, this sets the Status to Exception and the Exception Date to today.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LLC_BI__Set_Historic_Financial_Indicator_Value</fullName>
        <actions>
            <name>LLC_BI__Set_Historic_Financial_Indicator_Value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LLC_BI__Covenant_Compliance2__c.LLC_BI__Status__c</field>
            <operation>equals</operation>
            <value>Compliant</value>
        </criteriaItems>
        <description>When the Covenant_Compliance2 Status is set to Compliant, sets the Historic Financial Indicator Value to Covenant2.Financial_Indicator_Value</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>