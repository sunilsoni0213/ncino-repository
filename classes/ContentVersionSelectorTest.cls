@isTest
public with sharing class ContentVersionSelectorTest {
	@isTest
	private static void shouldReturnContentVersion() {
		Id contentVersionId = createContentVersion();

		Test.startTest();
		ContentVersion content = new ContentVersionSelector().fetchContentVersion((String) contentVersionId);
		Test.stopTest();

		System.assertEquals('🍗', content.VersionData.toString());
	}

	@isTest
	private static void shouldReturnNull_WhenNullId() {
		Test.startTest();
		ContentVersion content = new ContentVersionSelector().fetchContentVersion(null);
		Test.stopTest();

		System.assertEquals(null, content);
	}

	@isTest
	private static void shouldReturnNull_WhenInvalidId() {
		Test.startTest();
		ContentVersion content = new ContentVersionSelector().fetchContentVersion('M❤️J');
		Test.stopTest();

		System.assertEquals(null, content);
	}

	private static Id createContentVersion() {
		ContentVersion content = new ContentVersion();
		content.PathOnClient = 'rage.pdf';
		content.Title = '🌮';
		content.VersionData = Blob.valueOf('🍗');
		nFORCE.DmlUtility.insertObj(content);

		return content.Id;
	}
}