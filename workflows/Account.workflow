<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Account_Default_App</fullName>
        <field>LLC_BI__Default_App__c</field>
        <formula>&apos;relationship.productclassification&apos;</formula>
        <name>Account - Default App</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_DocMan_Identifier_Vendor</fullName>
        <field>NDOC__Document_Manager_Identifier__c</field>
        <literalValue>Vendor</literalValue>
        <name>Account - DocMan Identifier = Vendor</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Record_Type_Referral_Source</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Referral_Source</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Account - Record Type = Referral Source</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Record_Type_Vendor</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Vendor</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Account - Record Type = Vendor</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Business_with_Connections</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Business_with_Connections</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Business with Connections</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Business_without_Connections</fullName>
        <field>RecordTypeId</field>
        <lookupValue>LLC_BI__Business</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Business without Connections</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EMEA_Business_with_Connections</fullName>
        <field>RecordTypeId</field>
        <lookupValue>EMEA_Business_with_Connections</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>EMEA Business with Connections</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EMEA_Business_without_Connections</fullName>
        <field>RecordTypeId</field>
        <lookupValue>EMEA_Business</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>EMEA Business without Connections</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EMEA_Individual_with_Connections</fullName>
        <field>RecordTypeId</field>
        <lookupValue>EMEA_Individual_with_Connections</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>EMEA Individual with Connections</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EMEA_Individual_without_Connections</fullName>
        <field>RecordTypeId</field>
        <lookupValue>EMEA_Individual</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>EMEA Individual without Connections</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Individual_with_Connections</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Individual_with_Connections</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Individual with Connections</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Individual_without_Connections</fullName>
        <field>RecordTypeId</field>
        <lookupValue>LLC_BI__Individual</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Individual without Connections</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__Set_Account_Business_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>LLC_BI__Business</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Account Business Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__Set_Account_Household_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>LLC_BI__Household</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Account Household Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__Set_Account_Individual_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>LLC_BI__Individual</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Account Individual Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__Set_Default_App_to_Counterparty_Report</fullName>
        <description>Update default app to Counterparty Report</description>
        <field>LLC_BI__Default_App__c</field>
        <literalValue>counterparty-report.counterparty-report</literalValue>
        <name>Set Default App to Counterparty Report</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__Update_Record_Type_to_Lender</fullName>
        <description>If Account type is &quot;Institutional Investor&quot; or &quot;Financial Institution&quot; update record type to Lender.</description>
        <field>RecordTypeId</field>
        <lookupValue>LLC_BI__Lender</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type to Lender</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lender_Type_Set</fullName>
        <field>RecordTypeId</field>
        <lookupValue>LLC_BI__Lender</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Lender Type Set</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>OFAC_Date_Update</fullName>
        <field>nBRIDGER__OFAC_Disposition_Date__c</field>
        <formula>CreatedDate</formula>
        <name>OFAC Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>OFAC_Disposition_Update</fullName>
        <field>nBRIDGER__OFAC_Disposition_Status__c</field>
        <literalValue>No Match</literalValue>
        <name>OFAC Disposition Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Default_App</fullName>
        <field>LLC_BI__Default_App__c</field>
        <formula>&apos;relationship.relationship-loan-products&apos;</formula>
        <name>Set Default App</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Shipping_City_Billing_City</fullName>
        <field>ShippingCity</field>
        <formula>BillingCity</formula>
        <name>Shipping City = Billing City</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Shipping_Country_Billing_Country</fullName>
        <field>ShippingCountry</field>
        <formula>BillingCountry</formula>
        <name>Shipping Country = Billing Country</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Shipping_Postal_Code_Billing_Postal_Co</fullName>
        <field>ShippingPostalCode</field>
        <formula>BillingPostalCode</formula>
        <name>Shipping Postal Code = Billing Postal Co</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Shipping_State_Billing_State</fullName>
        <field>ShippingState</field>
        <formula>BillingState</formula>
        <name>Shipping State = Billing State</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Shipping_Street_Billing_Street</fullName>
        <field>ShippingStreet</field>
        <formula>BillingStreet</formula>
        <name>Shipping Street = Billing Street</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UI_default_app</fullName>
        <field>LLC_BI__Default_App__c</field>
        <formula>&apos;relationship-individual.relationship-overview-individual&apos;</formula>
        <name>UI default app</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UI_default_app2</fullName>
        <field>LLC_BI__Default_App__c</field>
        <formula>&apos;relationship-individual.relationship-overview-individual&apos;</formula>
        <name>UI default app</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UI_default_app3</fullName>
        <field>LLC_BI__Default_App__c</field>
        <formula>&apos;relationship-business.relationship-overview-business&apos;</formula>
        <name>UI default app</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UI_default_app4</fullName>
        <field>LLC_BI__Default_App__c</field>
        <formula>&apos;relationship-business.relationship-overview-business&apos;</formula>
        <name>UI default app</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Customer_Since_Field</fullName>
        <field>Customer_Since__c</field>
        <formula>TODAY()</formula>
        <name>Update Customer Since Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_DSC</fullName>
        <field>LLC_BI__DSC_Post_OC__c</field>
        <formula>1.25</formula>
        <name>Update DSC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Debt_Service_Coverage</fullName>
        <field>LLC_BI__Debt_Service_Coverage__c</field>
        <formula>LLC_BI__DSC_Post_OC__c * 1</formula>
        <name>Update Debt Service Coverage %</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Default_App_Account_Household</fullName>
        <field>LLC_BI__Default_App__c</field>
        <formula>&apos;relationship.relationship-loan-products&apos;</formula>
        <name>Update Default App Account Household</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_FICO_DATE</fullName>
        <field>LLC_BI__FICO_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update FICO DATE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_NAICS_Code</fullName>
        <field>LLC_BI__Naics_Code__c</field>
        <formula>NAICS_Description__r.NAICS_Code__c</formula>
        <name>Update NAICS Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Relationship_Risk_Grad</fullName>
        <field>LLC_BI__Risk_Rating_Review_Grade__c</field>
        <formula>1</formula>
        <name>Update Relationship Risk Grad</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Risk_Grade</fullName>
        <field>LLC_BI__Highest_Risk_Grade__c</field>
        <formula>TEXT(1)</formula>
        <name>Update Risk Grade</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Account - Business with Connections</fullName>
        <actions>
            <name>Business_with_Connections</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Type</field>
            <operation>notEqual</operation>
            <value>Household,Individual,Financial Institution,Institutional Investor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.LLC_BI__Status__c</field>
            <operation>equals</operation>
            <value>Prospect,Customer,Referral Source</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Connection_Flag__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.LocaleSidKey</field>
            <operation>equals</operation>
            <value>English (United States)</value>
        </criteriaItems>
        <description>Account Type not = &quot;Household&quot;or &quot;Individual&quot; and Connection Flag = True</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Account - Business without Connections</fullName>
        <actions>
            <name>Business_without_Connections</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Type</field>
            <operation>notEqual</operation>
            <value>Household,Individual,Financial Institution,Institutional Investor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.LLC_BI__Status__c</field>
            <operation>equals</operation>
            <value>Prospect,Customer,Referral Source</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Connection_Flag__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.LocaleSidKey</field>
            <operation>equals</operation>
            <value>English (United States)</value>
        </criteriaItems>
        <description>Account Type not = &quot;Household&quot;, or &quot;Individual&quot; and Connection Flag = False</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Account - Individual with Connections</fullName>
        <actions>
            <name>Individual_with_Connections</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Type</field>
            <operation>equals</operation>
            <value>Individual</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.LLC_BI__Status__c</field>
            <operation>equals</operation>
            <value>Prospect,Customer,Referral Source</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Connection_Flag__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.LocaleSidKey</field>
            <operation>equals</operation>
            <value>English (United States)</value>
        </criteriaItems>
        <description>Type = &quot;Individual&quot; and Connection Flag = True</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Account - Individual without Connections</fullName>
        <actions>
            <name>Individual_without_Connections</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Type</field>
            <operation>equals</operation>
            <value>Individual</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.LLC_BI__Status__c</field>
            <operation>equals</operation>
            <value>Prospect,Customer,Referral Source</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Connection_Flag__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.LocaleSidKey</field>
            <operation>equals</operation>
            <value>English (United States)</value>
        </criteriaItems>
        <description>Type = &quot;Individual&quot; and Connection Flag = False</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Account - Same as Physical Address %3D True</fullName>
        <actions>
            <name>Shipping_City_Billing_City</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Shipping_Country_Billing_Country</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Shipping_Postal_Code_Billing_Postal_Co</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Shipping_State_Billing_State</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Shipping_Street_Billing_Street</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Same_as_Physical_Address__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Account - Status %3D Vendor</fullName>
        <actions>
            <name>Account_Record_Type_Vendor</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.LLC_BI__Status__c</field>
            <operation>equals</operation>
            <value>Vendor</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Account Set Referral Source Set</fullName>
        <actions>
            <name>Account_Record_Type_Referral_Source</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.LLC_BI__Status__c</field>
            <operation>equals</operation>
            <value>Referral Source</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EMEA - Account - Business with Connections</fullName>
        <actions>
            <name>EMEA_Business_with_Connections</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Type</field>
            <operation>notEqual</operation>
            <value>Household,Individual,Financial Institution,Institutional Investor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.LLC_BI__Status__c</field>
            <operation>equals</operation>
            <value>Prospect,Customer,Referral Source</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Connection_Flag__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.LocaleSidKey</field>
            <operation>notEqual</operation>
            <value>English (United States)</value>
        </criteriaItems>
        <description>EMEA - Account Type not = &quot;Household&quot;, or &quot;Individual&quot; and Connection Flag = False</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>EMEA - Account - Business without Connections</fullName>
        <actions>
            <name>EMEA_Business_without_Connections</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Type</field>
            <operation>notEqual</operation>
            <value>Household,Individual,Financial Institution,Institutional Investor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.LLC_BI__Status__c</field>
            <operation>equals</operation>
            <value>Prospect,Customer,Referral Source</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Connection_Flag__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.LocaleSidKey</field>
            <operation>notEqual</operation>
            <value>English (United States)</value>
        </criteriaItems>
        <description>EMEA Account Type not = &quot;Household&quot;, or &quot;Individual&quot; and Connection Flag = False</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>EMEA Account - Individual with Connections</fullName>
        <actions>
            <name>EMEA_Individual_with_Connections</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Type</field>
            <operation>equals</operation>
            <value>Individual</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.LLC_BI__Status__c</field>
            <operation>equals</operation>
            <value>Prospect,Customer,Referral Source</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Connection_Flag__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.LocaleSidKey</field>
            <operation>notEqual</operation>
            <value>English (United States)</value>
        </criteriaItems>
        <description>Type = &quot;Individual&quot; and Connection Flag = True</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>EMEA Account - Individual without Connections</fullName>
        <actions>
            <name>EMEA_Individual_without_Connections</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Type</field>
            <operation>equals</operation>
            <value>Individual</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.LLC_BI__Status__c</field>
            <operation>equals</operation>
            <value>Prospect,Customer,Referral Source</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Connection_Flag__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.LocaleSidKey</field>
            <operation>notEqual</operation>
            <value>English (United States)</value>
        </criteriaItems>
        <description>Type = &quot;Individual&quot; and Connection Flag = False</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Household Set Default App</fullName>
        <actions>
            <name>Set_Default_App</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Type</field>
            <operation>equals</operation>
            <value>Household</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LLC_BI__Account Set Business Record Type</fullName>
        <actions>
            <name>LLC_BI__Set_Account_Business_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Type</field>
            <operation>notEqual</operation>
            <value>Household,Individual,Sole Proprietorship,Financial Institution,Institutional Investor</value>
        </criteriaItems>
        <description>sets Record Type to Business if Account Type is not &quot;Household&quot;, &quot;Sole Proprietorship&quot;, &quot;Institutional Investor&quot;, &quot;Financial Institution&quot; or &quot;Individual&quot;</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LLC_BI__Account Set Household Record Type</fullName>
        <actions>
            <name>LLC_BI__Set_Account_Household_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Type</field>
            <operation>equals</operation>
            <value>Household</value>
        </criteriaItems>
        <description>sets Record Type to Household if Account Type is &quot;Household&quot;</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LLC_BI__Account Set Individual Record Type</fullName>
        <actions>
            <name>LLC_BI__Set_Account_Individual_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Type</field>
            <operation>equals</operation>
            <value>Individual,Sole Proprietorship</value>
        </criteriaItems>
        <description>sets Record Type to Individual if Account Type is &quot;Sole Proprietorship&quot; or &quot;Individual&quot;</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LLC_BI__Account Set Lender Record Type</fullName>
        <actions>
            <name>LLC_BI__Update_Record_Type_to_Lender</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Type</field>
            <operation>equals</operation>
            <value>Financial Institution,Institutional Investor</value>
        </criteriaItems>
        <description>sets Record Type to Lender if Account Type is &quot;Financial Institution&quot; or &quot;Institutional Investor&quot;</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LLC_BI__Set Default App for Lenders</fullName>
        <actions>
            <name>LLC_BI__Set_Default_App_to_Counterparty_Report</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Lender</value>
        </criteriaItems>
        <description>When Record Type is Lender, set default app to be counterparty report.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Populate NAICS Code</fullName>
        <actions>
            <name>Update_NAICS_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(NAICS_Description__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Review Frequency Notification</fullName>
        <actions>
            <name>Annual_Review_Coming_Due_Please_Review</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISNULL( LLC_BI__Next_Review_Date__c ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <offsetFromField>Account.LLC_BI__Next_Review_Date__c</offsetFromField>
            <timeLength>-30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Translate CFC to Debt Service Percent</fullName>
        <actions>
            <name>Update_Debt_Service_Coverage</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Relationship Fields at creation of new relationship</fullName>
        <actions>
            <name>OFAC_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>OFAC_Disposition_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Customer_Since_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_DSC</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_FICO_DATE</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Relationship_Risk_Grad</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Risk_Grade</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>For Demo Purposes, this rule simulates a credit report pull, auto risk grading, spreads calculation to assist with auto-decisioning based on criteria.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <tasks>
        <fullName>Annual_Review_Coming_Due_Please_Review</fullName>
        <assignedTo>peter.s@autorabitncinodemo.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Annual Review Coming Due - Please Review</subject>
    </tasks>
</Workflow>