/****************************************************************************************
Name            : ConfigCreateCorsWhitelistOriginStepTest
Revision Log    : 2020-03-17 John Kuhl - CodeScience
                :
                :
Use             : Unit Test for IConfigStep class ConfigCreateCorsWhitelistOriginStep
****************************************************************************************/
@isTest
public class ConfigCreateCorsWhitelistOriginStepTest {
    
    @isTest
    public static void testConfigCreateCorsWhitelistOriginStep(){
        Test.setMock(WebServiceMock.class, new CSMetadataServiceTest.WebServiceMockImpl());

        Test.startTest();
        ConfigCreateCorsWhitelistOriginStep.execute();
        Test.stopTest();
        
    }
}