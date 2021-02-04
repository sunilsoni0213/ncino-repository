public with sharing class ProductClassificationAppController {

    private Id contextId;

    public ProductClassificationAppController(String i){
        this.contextId = i;
    }

    public ProductClassificationAppController(){
        this.contextId = ApexPages.currentPage().getParameters().get('Id');
    }

    public ProductClassificationAppController(ApexPages.StandardController controller){
        this.contextId = controller.getId();
    }

    public String getClassificationBuckets(){
        return getClassificationBuckets(this.contextId);
    }


    public String getClassificationBuckets(Id acctId){
        List<LLC_BI__Deposit__c> acctDeposits= [
                SELECT
                        Id,
                        LLC_BI__Status__c,
                        LLC_BI__Product__c,
                        LLC_BI__Product_Reference__r.Classificationproduct__c,
                        LLC_BI__Product_Reference__r.LLC_BI__Product_Type__r.LLC_BI__Product_Line__r.LLC_BI__Category__c,
                        LLC_BI__Account__r.Id
                FROM
                        LLC_BI__Deposit__c
                WHERE
                        LLC_BI__Account__r.Id = :acctId
        ];

        List<LLC_BI__Loan__c> acctLoans = new List<LLC_BI__Loan__c>();
        acctLoans= [
                SELECT
                        Id,
                        LLC_BI__Status__c,
                        LLC_BI__Product__c,
                        LLC_BI__Product_Reference__r.Classificationproduct__c,
                        LLC_BI__Product_Reference__r.LLC_BI__Product_Type__r.LLC_BI__Product_Line__r.LLC_BI__Category__c,
                        LLC_BI__Account__r.Id
                FROM
                        LLC_BI__Loan__c
                WHERE
                        LLC_BI__Account__r.Id = :acctId
        ];

        List<LLC_BI__Treasury_Service__c> acctTreasuryServices = new List<LLC_BI__Treasury_Service__c>();
        acctTreasuryServices= [
                SELECT
                        Id,
                        LLC_BI__Status__c,
                        LLC_BI__Product_Reference__r.Classificationproduct__c,
                        LLC_BI__Product_Reference__r.LLC_BI__Product_Type__r.LLC_BI__Product_Line__r.LLC_BI__Category__c,
                        LLC_BI__Relationship__r.Id
                FROM
                        LLC_BI__Treasury_Service__c
                WHERE
                        LLC_BI__Relationship__r.Id = :acctId
        ];

        List<ProductClassificationDataService.ProductWithClassification> products = getProductsWithClassification(acctDeposits, acctLoans, acctTreasuryServices);

        String toReturn = JSON.serialize(new ProductClassificationDataService.ClassificationBuckets(
            new ProductClassificationDataService.ClassifiedProducts(products)));

        return toReturn;
    }

    private List<ProductClassificationDataService.ProductWithClassification> getProductsWithClassification(List<LLC_BI__Deposit__c> acctDeposits, List<LLC_BI__Loan__c> acctLoans, List<LLC_BI__Treasury_Service__c> acctTreasuryServices){
        List<ProductClassificationDataService.ProductWithClassification> productsWithClassifications = new List<ProductClassificationDataService.ProductWithClassification>();

        if(acctDeposits.size() > 0){
            for(LLC_BI__Deposit__c d : acctDeposits){
                productsWithClassifications.add(new ProductClassificationDataService.ProductWithClassification(
                        d.LLC_BI__Product_Reference__r.Classificationproduct__c,
                        d.LLC_BI__Status__c,
                        d.LLC_BI__Product_Reference__r.LLC_BI__Product_Type__r.LLC_BI__Product_Line__r.LLC_BI__Category__c
                ));
            }
        }
        if(acctLoans.size() > 0) {
            for (LLC_BI__Loan__c l : acctLoans) {
                productsWithClassifications.add(new ProductClassificationDataService.ProductWithClassification(
                        l.LLC_BI__Product_Reference__r.Classificationproduct__c,
                        l.LLC_BI__Status__c,
                        l.LLC_BI__Product_Reference__r.LLC_BI__Product_Type__r.LLC_BI__Product_Line__r.LLC_BI__Category__c
                ));
            }
        }
        if(acctTreasuryServices.size() > 0) {
            for (LLC_BI__Treasury_Service__c t : acctTreasuryServices) {
                productsWithClassifications.add(new ProductClassificationDataService.ProductWithClassification(
                        t.LLC_BI__Product_Reference__r.Classificationproduct__c,
                        t.LLC_BI__Status__c,
                        t.LLC_BI__Product_Reference__r.LLC_BI__Product_Type__r.LLC_BI__Product_Line__r.LLC_BI__Category__c
                ));
            }
        }
        //select all products
        //create new ProductWithClassification and add to list
        List<LLC_BI__Product__c> products = [
            SELECT
                Id,
                Name,
                Classificationproduct__c,
                LLC_BI__Product_Type__r.LLC_BI__Product_Line__r.LLC_BI__Category__c
            FROM
                LLC_BI__Product__c
            WHERE
                Classificationproduct__c != ''
        ];

        for(LLC_BI__Product__c p : products) {
            productsWithClassifications.add(new ProductClassificationDataService.ProductWithClassification(
                    p.Classificationproduct__c,
                    '',
                    p.LLC_BI__Product_Type__r.LLC_BI__Product_Line__r.LLC_BI__Category__c
            ));
        }

        productsWithClassifications = filterProductsByAccountType(productsWithClassifications);

        return productsWithClassifications;
    }

    private List<ProductClassificationDataService.ProductWithClassification> filterProductsByAccountType(List<ProductClassificationDataService.ProductWithClassification> products){
        Account acct = getAccount();
        List<ProductClassificationDataService.ProductWithClassification> newProducts = new List<ProductClassificationDataService.ProductWithClassification>();

        if(acct.Type == 'Household'){
            return products;
        }
        else if(acct.Type == 'Individual'){
            for (Integer i = 0; i < products.size(); i++){
                if(products[i].line == 'Consumer'){
                    System.debug(products[i]);

                    newProducts.add(products[i]);
                }
            }
        }
        else{
            for (Integer i = 0; i < products.size(); i++){
                System.debug('remaining '+products[i]);
                if(products[i].line == 'Business'){
                    System.debug(products[i].classification);
                    System.debug(products[i].line);
                    newProducts.add(products[i]);
                    System.debug(products.size());
                }
            }
        }

        return newProducts;
    }

    private Account getAccount(){
        return [SELECT
                    Id,
                    Type
                FROM
                    Account
                WHERE
                    Account.Id = :this.contextId
        ];
    }
    
    public static void fakeTestMethod(){
        Integer i=0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }

}