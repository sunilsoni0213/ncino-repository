@isTest(IsParallel=true)
public with sharing class PackageMetadataMessagePropExtractorTest {
	@isTest
	private static void shouldReturnException_WhenNoDocumentCollection() {
		Map<String, Object> message = new Map<String, Object>();
		Map<String, Object> props = new Map<String, Object>();
		message.put(AddDocumentPropertyExtractor.KEY_PROPERTIES, props);

		try {
			new PackageMetadataMessagePropertyExtractor().getDocumentCollection(message);
			System.assert(false, 'expected exception was not thrown');
		} catch (Exception ex) {
			System.assert(ex.getMessage().startsWith(
				new PackageMetadataMessagePropertyExtractor().buildExceptionMessage(
					APropertyExtractor.X_MISSING_REQUIRED_DATA,
					new List<String>{PackageMetadataMessagePropertyExtractor.KEY_DOCUMENT_COLLECTION}
				)
			));
		}
	}

	@isTest
	private static void shouldReturnException_WhenNoProperties() {
		Map<String, Object> message = new Map<String, Object>();
		Map<String, Object> props = new Map<String, Object>();
		Map<String, Object> docCollection = new Map<String, Object>();
		props.put(PackageMetadataMessagePropertyExtractor.KEY_DOCUMENT_COLLECTION, docCollection);
		message.put(PackageMetadataMessagePropertyExtractor.KEY_PROPERTIES, props);

		try {
			new PackageMetadataMessagePropertyExtractor().getVendorCollectionId(message);
			System.assert(false, 'expected exception was not thrown');
		} catch (Exception ex) {
			System.assert(ex.getMessage().startsWith(
				new PackageMetadataMessagePropertyExtractor().buildExceptionMessage(
					APropertyExtractor.X_MISSING_REQUIRED_DATA,
					new List<String>{
						PackageMetadataMessagePropertyExtractor.KEY_DOCUMENT_COLLECTION,
						PackageMetadataMessagePropertyExtractor.KEY_PROPERTIES
					}
				)
			));
		}
	}

	@isTest
	private static void shouldReturnException_WhenNoVendorId() {
		Map<String, Object> message = new Map<String, Object>();
		Map<String, Object> props = new Map<String, Object>();
		Map<String, Object> collectionProps = new Map<String, Object>();
		Map<String, Object> docCollection = new Map<String, Object>();
		docCollection.put(PackageMetadataMessagePropertyExtractor.KEY_PROPERTIES, collectionProps);
		props.put(PackageMetadataMessagePropertyExtractor.KEY_DOCUMENT_COLLECTION, docCollection);
		message.put(PackageMetadataMessagePropertyExtractor.KEY_PROPERTIES, props);

		try {
			new PackageMetadataMessagePropertyExtractor().getVendorCollectionId(message);
			System.assert(false, 'expected exception was not thrown');
		} catch (Exception ex) {
			System.assert(ex.getMessage().startsWith(
				new PackageMetadataMessagePropertyExtractor().buildExceptionMessage(
					APropertyExtractor.X_MISSING_REQUIRED_DATA,
					new List<String>{
						PackageMetadataMessagePropertyExtractor.KEY_DOCUMENT_COLLECTION,
						PackageMetadataMessagePropertyExtractor.KEY_VENDOR_COLLECTION_ID
					}
				)));
		}
	}

	@isTest
	private static void shouldReturnVendorId() {
		Map<String, Object> message = new Map<String, Object>();
		Map<String, Object> props = new Map<String, Object>();
		Map<String, Object> collectionProps = new Map<String, Object>();
		Map<String, Object> docCollection = new Map<String, Object>();
		Map<String, Object> vendorIdMap = new Map<String, Object>();
		vendorIdMap.put(APropertyExtractor.KEY_VALUE, '567');
		collectionProps.put(PackageMetadataMessagePropertyExtractor.KEY_VENDOR_COLLECTION_ID, vendorIdMap);
		docCollection.put(PackageMetadataMessagePropertyExtractor.KEY_PROPERTIES, collectionProps);
		props.put(PackageMetadataMessagePropertyExtractor.KEY_DOCUMENT_COLLECTION, docCollection);
		message.put(PackageMetadataMessagePropertyExtractor.KEY_PROPERTIES, props);

		try {
			String vendorId = new PackageMetadataMessagePropertyExtractor().getVendorCollectionId(message);
			System.assertEquals('567', vendorId);
		} catch (Exception ex) {
			System.assert(false, ex.getMessage());
		}
	}
}