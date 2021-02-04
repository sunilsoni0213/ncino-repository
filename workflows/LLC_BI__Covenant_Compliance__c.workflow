<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CC_Last_Evaluation_Date_Set</fullName>
        <field>LLC_BI__Last_Evaluation_Date__c</field>
        <formula>LLC_BI__Evaluation_Date__c</formula>
        <name>CC - Last Evaluation Date - Set</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>LLC_BI__Covenant__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CC_Last_Evaluation_Status_Set</fullName>
        <field>LLC_BI__Last_Evaluation_Status__c</field>
        <formula>TEXT(LLC_BI__Status__c)</formula>
        <name>CC - Last Evaluation Status - Set</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>LLC_BI__Covenant__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CC_Status_In_progress</fullName>
        <field>LLC_BI__Status__c</field>
        <literalValue>In Progress</literalValue>
        <name>CC - Status = In progress</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__Covenant_Update_Last_Evaluation_Status</fullName>
        <description>Update the last evaluation status on the Covenant object.</description>
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
        <fullName>LLC_BI__Update_Last_Evaluation_Date</fullName>
        <description>Update Last Evaluation Date on the Covenant object when it changes on the Covenant Compliance object.</description>
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
        <description>Update the Evaluation Status on the Covenant with the status on the Covenant Compliance record.</description>
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
        <description>Update the Last Evaluation Date on the Covenant Object when the review date changes</description>
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
        <description>Update the Covenant Compliance next evaluation date when the underlying covenant is marked compliant.</description>
        <field>LLC_BI__Next_Evaluation_Date__c</field>
        <formula>DATE(
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
    <rules>
        <fullName>Covenant Compliance Update Last  Status</fullName>
        <actions>
            <name>CC_Last_Evaluation_Status_Set</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update the Last Evaluation Date on the Covenant Object when a covenant is reviewed-Correct</description>
        <formula>ISCHANGED(LLC_BI__Status__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Covenant Compliance Update Last Evaluation Date</fullName>
        <actions>
            <name>CC_Last_Evaluation_Date_Set</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update the Last Evaluation Date on the Covenant Object when a covenant is reviewed-Correct</description>
        <formula>ISCHANGED( LLC_BI__Evaluation_Date__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
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
        <active>false</active>
        <description>Set the last evaluation status on the Covenant object when it gets updated on the Covenant Compliance object.</description>
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
        <criteriaItems>
            <field>LLC_BI__Covenant_Compliance__c.LLC_BI__Status__c</field>
            <operation>equals</operation>
            <value>Compliant</value>
        </criteriaItems>
        <description>Update the next Covenant Compliance evaluation date based on the frequency and the last scheduled evaluation date.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
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
        <active>false</active>
        <description>Update the Last Evaluation Date on the Covenant Object when a covenant is reviewed</description>
        <formula>ISCHANGED( LLC_BI__Evaluation_Date__c ) || ISNEW()</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>