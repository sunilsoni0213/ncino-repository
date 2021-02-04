@isTest(IsParallel=true)
public with sharing class DocumentEncodeUtilityTest {
	@isTest
	public static void shouldEncodeContent() {
		String encodeString = 'Encoded String';

		Test.startTest();
		String result = DocumentEncodeUtility.encodeContent(encodeString);
		Test.stopTest();

		System.assertEquals('RW5jb2RlZCBTdHJpbmcNCg0K', result);
	}

	@isTest
	public static void shouldEncodeContent_withTrailingSpace() {
		String encodeString = 'Encoded String ';

		Test.startTest();
		String result = DocumentEncodeUtility.encodeContent(encodeString);
		Test.stopTest();

		System.assertEquals('RW5jb2RlZCBTdHJpbmcgDQoN', result);
	}

	@isTest
	public static void shouldEncodeString() {
		String encodeString = 'Encoded String';

		Test.startTest();
		String result = DocumentEncodeUtility.encodeString(encodeString);
		Test.stopTest();

		System.assertEquals('RW5jb2RlZCBTdHJpbmcNCg0K', result);
	}

	@isTest
	public static void shouldEncodeDocument() {
		Blob fileBlob = Blob.valueOf('fileBlob');
		String headerEncoded = 'LS1ib3VuZGFyeQpDb250ZW50LURpc3Bvc2l0aW9uOiBmb3JtLWRhdGE7IG5hbWU9ImZpbGUiOyBmaWxlbmFtZT0iZmlsZU5hbWUucGRmIgpDb250ZW50LVR5cGU6IGFwcGxpY2F0aW9uL3BkZiANCg0K';
		String bodyEncoded = 'ZmlsZUJsb2IN';
		String footer = 'Ci0tYm91bmRhcnktLQ==';

		Test.startTest();
		List<String> encodedStrings = DocumentEncodeUtility.encodeDocument(fileBlob, 'boundary', 'fileName.pdf', 'application/pdf');
		Test.stopTest();

		System.assertEquals(headerEncoded + bodyEncoded, encodedStrings[0]);
		System.assertEquals(footer, encodedStrings[1]);
	}
}