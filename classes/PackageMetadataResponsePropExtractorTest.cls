@isTest(IsParallel=true)
public with sharing class PackageMetadataResponsePropExtractorTest {

	@isTest
	public static void shouldReturnDocuments() {
		Map<String, Object> response = PackageMetadataResponsePropExtractorTest.createVendorResponse();

		Test.startTest();
		List<Object> documents = new PackageMetadataResponsePropExtractor().extractDocuments(response);
		Test.stopTest();

		System.assertEquals(2, documents.size());
	}

	@isTest
	public static void shouldReturnDocumentCollectionId() {
		Map<String, Object> response = PackageMetadataResponsePropExtractorTest.createVendorResponse();
		List<Object> documents = new PackageMetadataResponsePropExtractor().extractDocuments(response);

		Test.startTest();
		String docCollectionId = new PackageMetadataResponsePropExtractor().extractDocumentCollectionId((Map<String, Object>) documents[1]);
		Test.stopTest();

		System.assertEquals('🍓', docCollectionId);
	}

	@isTest
	public static void shouldReturnEmptyString_whenNoDocumentCollectionId() {
		Map<String, Object> response = PackageMetadataResponsePropExtractorTest.createVendorResponse();
		List<Object> documents = new PackageMetadataResponsePropExtractor().extractDocuments(response);

		Test.startTest();
		String docCollectionId = new PackageMetadataResponsePropExtractor().extractDocumentCollectionId((Map<String, Object>) documents[0]);
		Test.stopTest();

		System.assertEquals('', docCollectionId);
	}

	@isTest
	public static void shouldReturnDocumentCollectionIndexId() {
		Map<String, Object> response = PackageMetadataResponsePropExtractorTest.createVendorResponse();
		List<Object> documents = new PackageMetadataResponsePropExtractor().extractDocuments(response);

		Test.startTest();
		String docCollectionIndexId = new PackageMetadataResponsePropExtractor().extractDocumentCollectionIndexId((Map<String, Object>) documents[1]);
		Test.stopTest();

		System.assertEquals('🥔', docCollectionIndexId);
	}

	@isTest
	public static void shouldReturnEmptyString_whenNoDocumentCollectionIndexId() {
		Map<String, Object> response = PackageMetadataResponsePropExtractorTest.createVendorResponse();
		List<Object> documents = new PackageMetadataResponsePropExtractor().extractDocuments(response);

		Test.startTest();
		String docCollectionIndexId = new PackageMetadataResponsePropExtractor().extractDocumentCollectionIndexId((Map<String, Object>) documents[0]);
		Test.stopTest();

		System.assertEquals('', docCollectionIndexId);
	}

	@isTest
	public static void shouldReturnPlaceholderId() {
		Map<String, Object> response = PackageMetadataResponsePropExtractorTest.createVendorResponse();
		List<Object> documents = new PackageMetadataResponsePropExtractor().extractDocuments(response);

		Test.startTest();
		String placeholderId = new PackageMetadataResponsePropExtractor().extractPlaceholderId((Map<String, Object>) documents[1]);
		Test.stopTest();

		System.assertEquals('🌽', placeholderId);
	}

	@isTest
	public static void shouldReturnEmptyString_whenNoPlaceholderId() {
		Map<String, Object> response = PackageMetadataResponsePropExtractorTest.createVendorResponse();
		List<Object> documents = new PackageMetadataResponsePropExtractor().extractDocuments(response);

		Test.startTest();
		String placeholderId = new PackageMetadataResponsePropExtractor().extractPlaceholderId((Map<String, Object>) documents[0]);
		Test.stopTest();

		System.assertEquals('', placeholderId);
	}

	@isTest
	public static void shouldReturnDocumentVersionId() {
		Map<String, Object> response = PackageMetadataResponsePropExtractorTest.createVendorResponse();
		List<Object> documents = new PackageMetadataResponsePropExtractor().extractDocuments(response);

		Test.startTest();
		String docVerId = new PackageMetadataResponsePropExtractor().extractDocumentVersionId((Map<String, Object>) documents[1]);
		Test.stopTest();

		System.assertEquals('🌶', docVerId);
	}

	@isTest
	public static void shouldReturnEmptyString_whenNoDocumentVersionId() {
		Map<String, Object> response = PackageMetadataResponsePropExtractorTest.createVendorResponse();
		List<Object> documents = new PackageMetadataResponsePropExtractor().extractDocuments(response);

		Test.startTest();
		String docVerId = new PackageMetadataResponsePropExtractor().extractDocumentVersionId((Map<String, Object>) documents[0]);
		Test.stopTest();

		System.assertEquals('', docVerId);
	}

	@isTest
	public static void shouldReturnTrue_whenHasSignatureTag() {
		Map<String, Object> response = PackageMetadataResponsePropExtractorTest.createVendorResponse();
		List<Object> documents = new PackageMetadataResponsePropExtractor().extractDocuments(response);

		Test.startTest();
		Boolean hasSignature = new PackageMetadataResponsePropExtractor().hasSignatureTag((Map<String, Object>) documents[1]);
		Test.stopTest();

		System.assertEquals(true, hasSignature);
	}

	@isTest
	public static void shouldReturnFalse_whenNoSignatureTag() {
		Map<String, Object> response = PackageMetadataResponsePropExtractorTest.createVendorResponse();
		List<Object> documents = new PackageMetadataResponsePropExtractor().extractDocuments(response);

		Test.startTest();
		Boolean hasSignature = new PackageMetadataResponsePropExtractor().hasSignatureTag((Map<String, Object>) documents[0]);
		Test.stopTest();

		System.assertEquals(false, hasSignature);
	}


	public static Map<String, Object> createVendorResponse() {
		String responseJson = '{"status":"DRAFT","id":"seSBUB6Khek0Ny8PIXwKSDPtal8=","documents":[{"id":"default-consent","approvals":[],"data":{"ese_document_texttag_extract_needed":"false"},"fields":[],"name":"Electronic Disclosures and Signatures Consent"},{"description":"","id":"sample-id","approvals":[{"fields":[{"type":"SIGNATURE","value":"","name":""}],"name":""}],"data":{"documentVersionId":"🌶","placeholderId":"🌽","documentCollectionIndexId":"🥔","documentCollectionId":"🍓"},"index":1,"fields":[],"name":"Test Document"}],"type":"PACKAGE","messages":[],"name":"My Minimal Package"}';
		Map<String, Object> response = (Map<String, Object>) JSON.deserializeUntyped(responseJson);
		return response;
	}
}