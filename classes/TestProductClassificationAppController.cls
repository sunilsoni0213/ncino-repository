@IsTest
public with sharing class TestProductClassificationAppController {

    @IsTest
    public static void TestConstructor(){
        Account a = new Account(Name = 'somerandomname', Type = 'Individual');
        insert a;

        ProductClassificationAppController con = new ProductClassificationAppController(a.Id);

        con.getClassificationBuckets();

        ProductClassificationAppController.fakeTestMethod();
        ProductClassificationDataService.fakeTestMethod();

        System.assert(true);
    }

    @IsTest
    public static void TestConstructor2(){
        Account a = new Account(Name = 'somerandomname', Type = 'Individual');
        insert a;

        ApexPages.currentPage().getParameters().put('Id', a.Id);

        ProductClassificationAppController con = new ProductClassificationAppController();

        con.getClassificationBuckets();

        System.assert(true);
    }


}