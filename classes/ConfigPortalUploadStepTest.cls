/****************************************************************************************
Name            : ConfigPortalUploadStepTest
Revision Log    : 2020-03-17 John Kuhl - CodeScience
                :
                :
Use             : Unit Test for IConfigStep class ConfigPortalUploadStep
****************************************************************************************/
@isTest
public class ConfigPortalUploadStepTest {
    
    @isTest
    public static void testConfigPortalUploadStep(){
        Test.setMock(WebServiceMock.class, new CSMetadataServiceTest.WebServiceMockImpl());

        Test.startTest();
        ConfigPortalUploadStep.execute();
        Test.stopTest();
    }
}