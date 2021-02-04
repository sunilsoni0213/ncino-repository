<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>35 - Update Flow Formulas</label>
    <protected>false</protected>
    <values>
        <field>Active__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>AutomationClass__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>ModalPath__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>StepDependsOn__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>StepDescription__c</field>
        <value xsi:type="xsd:string">1. Click Hyperlink in right corner
2. Open LoanAutoDecision Flow
3. Click Manager
4. Find Advance_Rate_LTV Formula
5. Paste -

IF({!Loan.LLC_BI__Current_Total_Lendable_Value__c} = 0,
{!Loan.LLC_BI__Current_Gross_Lendable_Value_Collateral1__c}/{!Loan.LLC_BI__Amount__c},
{!Loan.LLC_BI__Current_Total_Lendable_Value__c}/{!Loan.LLC_BI__Amount__c})

6. Click Done
7. Click Save As
8. Click Activate
9. Click Back


1. Open CalculateOriginalAmount1 Flow
2. Click manager
3. Edit DescriptionUpdateError
4. Paste -

&quot;The original loan amount for loan &quot; &amp; {!LoanRecord.Name} &amp; &quot; could not be updated due the missing calculation for product type &quot; &amp; TEXT({!LoanRecord.LLC_BI__Product_Type__c}) &amp; &quot;. &quot;

5. Click Done
6. Click OriginalAmountCashOut
7. Paste -

{!LoanRecord.LLC_BI__AmountOutstanding__c} + {!MortgageRecord.LLC_BI__Desired_Cash_Out_Amount_2__c}

8. Click Done
9. Click OriginalAmountPurchase
10. Paste -

{!MortgageRecord.LLC_BI__Purchase_Price_2__c} -BLANKVALUE({!MortgageRecord.LLC_BI__Down_Payment_2__c},0)

11. Click Done
12. Click OriginalAmountRateTerm
13. Paste -

BLANKVALUE({!LoanRecord.LLC_BI__AmountOutstanding__c},0)

14. Click Done
15. Click Save As
16. Click Activate</value>
    </values>
    <values>
        <field>StepHyperlink__c</field>
        <value xsi:type="xsd:string">/lightning/setup/Flows/home</value>
    </values>
    <values>
        <field>StepNumber__c</field>
        <value xsi:type="xsd:double">35.0</value>
    </values>
    <values>
        <field>StepTitle__c</field>
        <value xsi:type="xsd:string">Update Flow Formulas</value>
    </values>
    <values>
        <field>StepType__c</field>
        <value xsi:type="xsd:string">Manual-Confirm</value>
    </values>
</CustomMetadata>
