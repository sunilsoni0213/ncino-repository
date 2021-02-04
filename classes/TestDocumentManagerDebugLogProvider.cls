@isTest
private class TestDocumentManagerDebugLogProvider {
	@isTest
    private static void testLog(){
		new DocumentManagerDebugLogProvider().log(LoggingLevel.ERROR, DocumentManagerDebugLogProvider.class, 'Some Message');
    }
}