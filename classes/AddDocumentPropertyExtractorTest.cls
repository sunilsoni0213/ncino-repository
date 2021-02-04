@isTest(IsParallel=true)
public with sharing class AddDocumentPropertyExtractorTest {
	@isTest
	private static void shouldReturnException_WhenNoDocumentCollectionIndex() {
		Map<String, Object> message = new Map<String, Object>();
		Map<String, Object> props = new Map<String, Object>();
		message.put(AddDocumentPropertyExtractor.KEY_PROPERTIES, props);

		try {
			new AddDocumentPropertyExtractor().getDocumentCollectionIndex(message);
			System.assert(false, 'expected exception was not thrown');
		} catch (Exception ex) {
			System.assert(ex.getMessage().startsWith(
				new PackageMetadataMessagePropertyExtractor().buildExceptionMessage(
					APropertyExtractor.X_MISSING_REQUIRED_DATA,
					new List<String>{AddDocumentPropertyExtractor.KEY_DOCUMENT_COLLECTION_INDEX}
				)
			));
		}
	}

	@isTest
	private static void shouldReturnException_WhenNoCollectionIndexId() {
		Map<String, Object> message = new Map<String, Object>();
		Map<String, Object> props = new Map<String, Object>();
		Map<String, Object> docCollectionIndex = new Map<String, Object>();
		props.put(AddDocumentPropertyExtractor.KEY_DOCUMENT_COLLECTION_INDEX, docCollectionIndex);
		message.put(AddDocumentPropertyExtractor.KEY_PROPERTIES, props);

		try {
			new AddDocumentPropertyExtractor().getDocumentCollectionIndexId(message);
			System.assert(false, 'expected exception was not thrown');
		} catch (Exception ex) {
			System.assert(ex.getMessage().startsWith(
				new PackageMetadataMessagePropertyExtractor().buildExceptionMessage(
					APropertyExtractor.X_MISSING_REQUIRED_DATA,
					new List<String>{
						AddDocumentPropertyExtractor.KEY_DOCUMENT_COLLECTION_INDEX,
						AddDocumentPropertyExtractor.KEY_RECORD_ID
					}
				)
			));
		}
	}

	@isTest
	private static void shouldReturnDocumentCollectionIndexId() {
		Map<String, Object> message = new Map<String, Object>();
		Map<String, Object> props = new Map<String, Object>();
		Map<String, Object> docCollectionIndex = new Map<String, Object>();
		docCollectionIndex.put(AddDocumentPropertyExtractor.KEY_RECORD_ID, '1234');
		props.put(AddDocumentPropertyExtractor.KEY_DOCUMENT_COLLECTION_INDEX, docCollectionIndex);
		message.put(AddDocumentPropertyExtractor.KEY_PROPERTIES, props);

		try {
			String id = new AddDocumentPropertyExtractor().getDocumentCollectionIndexId(message);
			System.assertEquals('1234', id);
		} catch (Exception ex) {
			System.assert(false, ex.getMessage());
		}
	}

	@isTest
	private static void shouldReturnException_WhenNoDocCollectionProperties() {
		Map<String, Object> message = new Map<String, Object>();
		Map<String, Object> props = new Map<String, Object>();
		Map<String, Object> docCollectionIndex = new Map<String, Object>();
		Map<String, Object> docCollection = new Map<String, Object>();
		docCollectionIndex.put(AddDocumentPropertyExtractor.KEY_DOCUMENT_COLLECTION, docCollection);
		docCollectionIndex.put(AddDocumentPropertyExtractor.KEY_RECORD_ID, '1234');
		props.put(AddDocumentPropertyExtractor.KEY_DOCUMENT_COLLECTION_INDEX, docCollectionIndex);
		message.put(AddDocumentPropertyExtractor.KEY_PROPERTIES, props);

		try {
			new AddDocumentPropertyExtractor().getVendorCollectionId(message);
			System.assert(false, 'expected exception was not thrown');
		} catch (Exception ex) {
			System.assert(ex.getMessage().startsWith(
				new PackageMetadataMessagePropertyExtractor().buildExceptionMessage(
					APropertyExtractor.X_MISSING_REQUIRED_DATA,
					new List<String>{
						AddDocumentPropertyExtractor.KEY_DOCUMENT_COLLECTION,
						AddDocumentPropertyExtractor.KEY_PROPERTIES
					}
				)
			));
		}
	}

	@isTest
	private static void shouldReturnException_WhenNoCollectionId() {
		Map<String, Object> message = new Map<String, Object>();
		Map<String, Object> props = new Map<String, Object>();
		Map<String, Object> docCollectionIndex = new Map<String, Object>();
		Map<String, Object> docCollection = new Map<String, Object>();
		docCollectionIndex.put(AddDocumentPropertyExtractor.KEY_DOCUMENT_COLLECTION, docCollection);
		props.put(AddDocumentPropertyExtractor.KEY_DOCUMENT_COLLECTION_INDEX, docCollectionIndex);
		message.put(AddDocumentPropertyExtractor.KEY_PROPERTIES, props);

		try {
			new AddDocumentPropertyExtractor().getDocumentCollectionId(message);
			System.assert(false, 'expected exception was not thrown');
		} catch (Exception ex) {
			System.assert(ex.getMessage().startsWith(
				new PackageMetadataMessagePropertyExtractor().buildExceptionMessage(
					APropertyExtractor.X_MISSING_REQUIRED_DATA,
					new List<String>{
						AddDocumentPropertyExtractor.KEY_DOCUMENT_COLLECTION,
						AddDocumentPropertyExtractor.KEY_RECORD_ID
					}
				)
			));
		}
	}

	@isTest
	private static void shouldReturnDocumentCollectionId() {
		Map<String, Object> message = new Map<String, Object>();
		Map<String, Object> props = new Map<String, Object>();
		Map<String, Object> docCollectionIndex = new Map<String, Object>();
		Map<String, Object> docCollection = new Map<String, Object>();
		docCollection.put(AddDocumentPropertyExtractor.KEY_RECORD_ID, '1234');
		docCollectionIndex.put(AddDocumentPropertyExtractor.KEY_DOCUMENT_COLLECTION, docCollection);
		props.put(AddDocumentPropertyExtractor.KEY_DOCUMENT_COLLECTION_INDEX, docCollectionIndex);
		message.put(AddDocumentPropertyExtractor.KEY_PROPERTIES, props);

		try {
			String id = new AddDocumentPropertyExtractor().getDocumentCollectionId(message);
			System.assertEquals('1234', id);
		} catch (Exception ex) {
			System.assert(false, ex.getMessage());
		}
	}

	@isTest
	private static void shouldReturnException_WhenNoVendorId() {
		Map<String, Object> message = new Map<String, Object>();
		Map<String, Object> props = new Map<String, Object>();
		Map<String, Object> docCollectionIndex = new Map<String, Object>();
		Map<String, Object> docCollection = new Map<String, Object>();
		docCollection.put(AddDocumentPropertyExtractor.KEY_RECORD_ID, '1234');
		docCollection.put(AddDocumentPropertyExtractor.KEY_PROPERTIES, new Map<String, Object>());
		docCollectionIndex.put(AddDocumentPropertyExtractor.KEY_DOCUMENT_COLLECTION, docCollection);
		props.put(AddDocumentPropertyExtractor.KEY_DOCUMENT_COLLECTION_INDEX, docCollectionIndex);
		message.put(AddDocumentPropertyExtractor.KEY_PROPERTIES, props);

		try {
			new AddDocumentPropertyExtractor().getVendorCollectionId(message);
			System.assert(false, 'expected exception was not thrown');
		} catch (Exception ex) {
			System.assert(ex.getMessage().startsWith(
				new AddDocumentPropertyExtractor().buildExceptionMessage(
					APropertyExtractor.X_MISSING_REQUIRED_DATA,
					new List<String>{
						AddDocumentPropertyExtractor.KEY_DOCUMENT_COLLECTION,
						AddDocumentPropertyExtractor.KEY_VENDOR_COLLECTION_ID
					}
				)));
		}
	}

	@isTest
	private static void shouldReturnVendorId() {
		Map<String, Object> message = new Map<String, Object>();
		Map<String, Object> props = new Map<String, Object>();
		Map<String, Object> docCollectionIndex = new Map<String, Object>();
		Map<String, Object> docCollection = new Map<String, Object>();
		Map<String, Object> docProps = new Map<String, Object>();
		Map<String, Object> vendorIdMap = new Map<String, Object>();
		vendorIdMap.put(APropertyExtractor.KEY_VALUE, '1234');
		docProps.put(AddDocumentPropertyExtractor.KEY_VENDOR_COLLECTION_ID, vendorIdMap);
		docCollection.put(AddDocumentPropertyExtractor.KEY_PROPERTIES, docProps);
		docCollectionIndex.put(AddDocumentPropertyExtractor.KEY_DOCUMENT_COLLECTION, docCollection);
		props.put(AddDocumentPropertyExtractor.KEY_DOCUMENT_COLLECTION_INDEX, docCollectionIndex);
		message.put(AddDocumentPropertyExtractor.KEY_PROPERTIES, props);

		try {
			String vendorId = new AddDocumentPropertyExtractor().getVendorCollectionId(message);
			System.assertEquals('1234', vendorId);
		} catch (Exception ex) {
			System.assert(false, ex.getMessage());
		}
	}

	@isTest
	private static void shouldReturnException_WhenNoContentVersion() {
		Map<String, Object> message = new Map<String, Object>();
		Map<String, Object> props = new Map<String, Object>();
		Map<String, Object> docCollectionIndex = new Map<String, Object>();
		Map<String, Object> documentStore = new Map<String, Object>();
		docCollectionIndex.put(AddDocumentPropertyExtractor.KEY_DOCUMENT_STORE, documentStore);
		props.put(AddDocumentPropertyExtractor.KEY_DOCUMENT_COLLECTION_INDEX, docCollectionIndex);
		message.put(AddDocumentPropertyExtractor.KEY_PROPERTIES, props);

		try {
			new AddDocumentPropertyExtractor().getDocumentVersions(message);
			System.assert(false, 'expected exception was not thrown');
		} catch (Exception ex) {
			System.assert(ex.getMessage().startsWith(
				new AddDocumentPropertyExtractor().buildExceptionMessage(APropertyExtractor.X_MISSING_REQUIRED_DATA,
					new List<String>{
						AddDocumentPropertyExtractor.KEY_DOCUMENT_STORE,
						AddDocumentPropertyExtractor.KEY_DOCUMENT_VERSIONS
					}
				)));
		}
	}

	@isTest
	private static void shouldReturnException_WhenNoDocumentVersionProperties() {
		Map<String, Object> message = new Map<String, Object>();
		Map<String, Object> props = new Map<String, Object>();
		Map<String, Object> docCollectionIndex = new Map<String, Object>();
		Map<String, Object> documentStore = new Map<String, Object>();
		Map<String, Object> contentVersion = new Map<String, Object>();
		documentStore.put(AddDocumentPropertyExtractor.KEY_DOCUMENT_VERSIONS, new List<Object>{contentVersion});
		docCollectionIndex.put(AddDocumentPropertyExtractor.KEY_DOCUMENT_STORE, documentStore);
		props.put(AddDocumentPropertyExtractor.KEY_DOCUMENT_COLLECTION_INDEX, docCollectionIndex);
		message.put(AddDocumentPropertyExtractor.KEY_PROPERTIES, props);

		try {
			new AddDocumentPropertyExtractor().getDocumentVersionProps(message);
			System.assert(false, 'expected exception was not thrown');
		} catch (Exception ex) {
			System.assert(ex.getMessage().startsWith(
				new AddDocumentPropertyExtractor().buildExceptionMessage(APropertyExtractor.X_MISSING_REQUIRED_DATA,
					new List<String>{
						AddDocumentPropertyExtractor.KEY_DOCUMENT_VERSIONS,
						AddDocumentPropertyExtractor.KEY_PROPERTIES
					}
				)));
		}
	}

	@isTest
	private static void shouldReturnException_WhenNoContentVersionId() {
		Map<String, Object> message = new Map<String, Object>();
		Map<String, Object> props = new Map<String, Object>();
		Map<String, Object> docCollectionIndex = new Map<String, Object>();
		Map<String, Object> documentStore = new Map<String, Object>();
		Map<String, Object> contentVersion = new Map<String, Object>();
		contentVersion.put(AddDocumentPropertyExtractor.KEY_PROPERTIES, new Map<String, Object>());
		documentStore.put(AddDocumentPropertyExtractor.KEY_DOCUMENT_VERSIONS, new List<Object>{contentVersion});
		docCollectionIndex.put(AddDocumentPropertyExtractor.KEY_DOCUMENT_STORE, documentStore);
		props.put(AddDocumentPropertyExtractor.KEY_DOCUMENT_COLLECTION_INDEX, docCollectionIndex);
		message.put(AddDocumentPropertyExtractor.KEY_PROPERTIES, props);

		try {
			new AddDocumentPropertyExtractor().getContentVersionId(message);
			System.assert(false, 'expected exception was not thrown');
		} catch (Exception ex) {
			System.assert(ex.getMessage().startsWith(
				new AddDocumentPropertyExtractor().buildExceptionMessage(APropertyExtractor.X_MISSING_REQUIRED_DATA,
					new List<String>{
						AddDocumentPropertyExtractor.KEY_DOCUMENT_VERSIONS,
						AddDocumentPropertyExtractor.KEY_CONTENT_VERSION_ID
					}
				)));
		}
	}

	@isTest
	private static void shouldReturnContentVersionId() {
		Map<String, Object> message = getMessageWithContentVersionProps();

		try {
			String id = new AddDocumentPropertyExtractor().getContentVersionId(message);
			System.assertEquals('cvId', id);
		} catch (Exception ex) {
			System.assert(false, ex.getMessage());
		}
	}

	@isTest
	private static void shouldReturnException_WhenNoFileName() {
		Map<String, Object> message = getMessageWithEmptyContentVersionProps();

		try {
			new AddDocumentPropertyExtractor().getFileName(message);
			System.assert(false, 'expected exception was not thrown');
		} catch (Exception ex) {
			System.assert(ex.getMessage().startsWith(
				new AddDocumentPropertyExtractor().buildExceptionMessage(
					APropertyExtractor.X_MISSING_REQUIRED_DATA,
					new List<String>{
						AddDocumentPropertyExtractor.KEY_DOCUMENT_VERSIONS,
						AddDocumentPropertyExtractor.KEY_FILE_TITLE
					}
				)
			));
		}
	}

	@isTest
	private static void shouldReturnFileName() {
		Map<String, Object> message = getMessageWithContentVersionProps();

		try {
			String title = new AddDocumentPropertyExtractor().getFileName(message);
			System.assertEquals('rage.PDF', title);
		} catch (Exception ex) {
			System.assert(false, ex.getMessage());
		}
	}

	@isTest
	private static void shouldReturnException_WhenNoFileType() {
		Map<String, Object> message = getMessageWithEmptyContentVersionProps();

		try {
			new AddDocumentPropertyExtractor().getFileExtension(message);
			System.assert(false, 'expected exception was not thrown');
		} catch (Exception ex) {
			System.assert(ex.getMessage().startsWith(
				new AddDocumentPropertyExtractor().buildExceptionMessage(
					APropertyExtractor.X_MISSING_REQUIRED_DATA,
					new List<String>{
						AddDocumentPropertyExtractor.KEY_DOCUMENT_VERSIONS,
						AddDocumentPropertyExtractor.KEY_FILE_EXTENSION
					}
				)
			));
		}
	}

	@isTest
	private static void shouldReturnFileType() {
		Map<String, Object> message = getMessageWithContentVersionProps();

		try {
			String type = new AddDocumentPropertyExtractor().getFileExtension(message);
			System.assertEquals('PDF', type);
		} catch (Exception ex) {
			System.assert(false, ex.getMessage());
		}
	}

	@isTest
	private static void shouldReturnException_WhenNoPlaceholderId() {
		Map<String, Object> message = getMessageWithEmptyContentVersionProps();

		try {
			new AddDocumentPropertyExtractor().getPlaceholderId(message);
			System.assert(false, 'expected exception was not thrown');
		} catch (Exception ex) {
			System.assert(ex.getMessage().startsWith(
				new AddDocumentPropertyExtractor().buildExceptionMessage(
					APropertyExtractor.X_MISSING_REQUIRED_DATA,
					new List<String>{
						AddDocumentPropertyExtractor.KEY_DOCUMENT_VERSIONS,
						AddDocumentPropertyExtractor.KEY_PLACEHOLDER_ID
					}
				)
			));
		}
	}

	@isTest
	private static void shouldReturnPlaceholderId() {
		Map<String, Object> message = getMessageWithContentVersionProps();

		try {
			String id = new AddDocumentPropertyExtractor().getPlaceholderId(message);
			System.assertEquals('1234', id);
		} catch (Exception ex) {
			System.assert(false, ex.getMessage());
		}
	}

	@isTest
	private static void shouldReturnException_WhenNoDocumentVersionId() {
		Map<String, Object> message = getMessageWithEmptyContentVersionProps();

		try {
			new AddDocumentPropertyExtractor().getDocumentVersionId(message);
			System.assert(false, 'expected exception was not thrown');
		} catch (Exception ex) {
			System.assert(ex.getMessage().startsWith(
				new AddDocumentPropertyExtractor().buildExceptionMessage(
					APropertyExtractor.X_MISSING_REQUIRED_DATA,
					new List<String>{
						AddDocumentPropertyExtractor.KEY_DOCUMENT_VERSIONS,
						AddDocumentPropertyExtractor.KEY_RECORD_ID
					}
				)
			));
		}
	}

	@isTest
	private static void shouldReturnDocumentVersionId() {
		Map<String, Object> message = getMessageWithContentVersionProps();

		try {
			String id = new AddDocumentPropertyExtractor().getDocumentVersionId(message);
			System.assertEquals('1234', id);
		} catch (Exception ex) {
			System.assert(false, ex.getMessage());
		}
	}

	private static Map<String, Object> getMessageWithContentVersionProps() {
		Map<String, Object> message = new Map<String, Object>();
		Map<String, Object> props = new Map<String, Object>();
		Map<String, Object> docCollectionIndex = new Map<String, Object>();
		Map<String, Object> documentStore = new Map<String, Object>();
		Map<String, Object> documentVersion = new Map<String, Object>();
		Map<String, Object> documentVersionProperties = new Map<String, Object>();
		Map<String, Object> title = new Map<String, Object>();
		title.put(APropertyExtractor.KEY_VALUE, 'rage.PDF');
		Map<String, Object> type = new Map<String, Object>();
		type.put(APropertyExtractor.KEY_VALUE, 'PDF');
		Map<String, Object> pl = new Map<String, Object>();
		pl.put(APropertyExtractor.KEY_VALUE, '1234');
		Map<String, Object> contentId = new Map<String, Object>();
		contentId.put(APropertyExtractor.KEY_VALUE, 'cvId');

		documentVersionProperties.put(AddDocumentPropertyExtractor.KEY_CONTENT_VERSION_ID, contentId);
		documentVersionProperties.put(AddDocumentPropertyExtractor.KEY_FILE_TITLE, title) ;
		documentVersionProperties.put(AddDocumentPropertyExtractor.KEY_FILE_EXTENSION, type) ;
		documentVersionProperties.put(AddDocumentPropertyExtractor.KEY_PLACEHOLDER_ID, pl) ;
		documentVersion.put(AddDocumentPropertyExtractor.KEY_RECORD_ID,'1234');
		documentVersion.put(AddDocumentPropertyExtractor.KEY_PROPERTIES, documentVersionProperties);
		documentStore.put(AddDocumentPropertyExtractor.KEY_DOCUMENT_VERSIONS, new List<Object>{(Object) documentVersion});
		docCollectionIndex.put(AddDocumentPropertyExtractor.KEY_DOCUMENT_STORE, documentStore);
		props.put(AddDocumentPropertyExtractor.KEY_DOCUMENT_COLLECTION_INDEX, docCollectionIndex);
		message.put(AddDocumentPropertyExtractor.KEY_PROPERTIES, props);

		return message;
	}

	private static Map<String, Object> getMessageWithEmptyContentVersionProps() {
		Map<String, Object> message = new Map<String, Object>();
		Map<String, Object> props = new Map<String, Object>();
		Map<String, Object> docCollectionIndex = new Map<String, Object>();
		Map<String, Object> documentStore = new Map<String, Object>();
		Map<String, Object> contentVersion = new Map<String, Object>();

		contentVersion.put(AddDocumentPropertyExtractor.KEY_PROPERTIES, new Map<String, Object>());
		documentStore.put(AddDocumentPropertyExtractor.KEY_DOCUMENT_VERSIONS, new List<Object>{contentVersion});
		docCollectionIndex.put(AddDocumentPropertyExtractor.KEY_DOCUMENT_STORE, documentStore);
		props.put(AddDocumentPropertyExtractor.KEY_DOCUMENT_COLLECTION_INDEX, docCollectionIndex);
		message.put(AddDocumentPropertyExtractor.KEY_PROPERTIES, props);

		return message;
	}

}