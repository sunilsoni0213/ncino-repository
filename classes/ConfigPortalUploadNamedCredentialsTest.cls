/****************************************************************************************
Name            : ConfigPortalUploadNamedCredentialsTest
Revision Log    : 2020-03-30 John Kuhl - CodeScience
                :
                :
Use             : Unit Test for IConfigStep class ConfigPortalUploadNamedCredentialsStep
****************************************************************************************/
@isTest
public class ConfigPortalUploadNamedCredentialsTest {

    /**
     * ConfigPortalUploadNamedCredentialsStep
     *
     * This method asychronously executes the the creation of the Named Credential and Connected App
     **/    
    @isTest
    public static void testConfigPortalUploadStep(){
        Test.setMock(WebServiceMock.class, new CSMetadataServiceTest.WebServiceMockImpl());

        Test.startTest();
        ConfigPortalUploadNamedCredentialsStep.execute();
        Test.stopTest();
    }
}