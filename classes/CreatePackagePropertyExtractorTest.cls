@isTest(IsParallel=true)
public with sharing class CreatePackagePropertyExtractorTest {
	@isTest
	private static void shouldReturnException_WhenNoDocumentCollection() {
		nFUSE.AMiddlewareMessage message = new nFUSE.MiddlewareMessage();
		message.properties = new Map<String, Object>();

		try {
			new CreatePackagePropertyExtractor().getDocumentCollection((Map<String, Object>) JSON.deserializeUntyped(message.toMsg()));
			System.assert(false, 'expected exception was not thrown');
		} catch (Exception ex) {
			System.assert(ex.getMessage().startsWith(
				new CreatePackagePropertyExtractor().buildExceptionMessage(
					APropertyExtractor.X_MISSING_REQUIRED_DATA,
					new List<String>{
						CreatePackagePropertyExtractor.KEY_DOCUMENT_COLLECTION
					}
				)
			));
		}
	}

	@isTest
	private static void shouldReturnException_WhenNoCollectionId() {
		Map<String, Object> docCollection = new Map<String, Object>();

		nFUSE.AMiddlewareMessage message = new nFUSE.MiddlewareMessage();
		message.properties = new Map<String, Object>();
		message.properties.put(CreatePackagePropertyExtractor.KEY_DOCUMENT_COLLECTION, docCollection);

		try {
			new CreatePackagePropertyExtractor().getDocumentCollectionId((Map<String, Object>) JSON.deserializeUntyped(message.toMsg()));
			System.assert(false, 'expected exception was not thrown');
		} catch (Exception ex) {
			System.assert(ex.getMessage().startsWith(
				new CreatePackagePropertyExtractor().buildExceptionMessage(
					APropertyExtractor.X_MISSING_REQUIRED_DATA,
					new List<String>{
						CreatePackagePropertyExtractor.KEY_DOCUMENT_COLLECTION,
						CreatePackagePropertyExtractor.KEY_RECORD_ID
					}
				)));
		}
	}

	@isTest
	private static void shouldReturnCollectionId() {
		Map<String, Object> docCollection = new Map<String, Object>();
		docCollection.put(CreatePackagePropertyExtractor.KEY_RECORD_ID, '567');
		nFUSE.AMiddlewareMessage message = new nFUSE.MiddlewareMessage();
		message.properties = new Map<String, Object>();
		message.properties.put(CreatePackagePropertyExtractor.KEY_DOCUMENT_COLLECTION, docCollection);

		try {
			String docId = new CreatePackagePropertyExtractor().getDocumentCollectionId((Map<String, Object>) JSON.deserializeUntyped(message.toMsg()));
			System.assertEquals('567', docId);
		} catch (Exception ex) {
			System.assert(false, ex.getMessage());
		}
	}

	@isTest
	private static void shouldReturnException_WhenNoDocumentCollectionName() {
		Map<String, Object> docCollection = new Map<String, Object>();
		Map<String, Object> props = new Map<String, Object>();
		docCollection.put(CreatePackagePropertyExtractor.KEY_PROPERTIES, props);
		docCollection.put(CreatePackagePropertyExtractor.KEY_PROPERTIES, new Map<String, Object>());

		nFUSE.AMiddlewareMessage message = new nFUSE.MiddlewareMessage();
		message.properties = new Map<String, Object>();
		message.properties.put(CreatePackagePropertyExtractor.KEY_DOCUMENT_COLLECTION, docCollection);

		try {
			new CreatePackagePropertyExtractor().getDocumentCollectionName((Map<String, Object>) JSON.deserializeUntyped(message.toMsg()));
			System.assert(false, 'expected exception was not thrown');
		} catch (Exception ex) {
			System.assert(ex.getMessage().startsWith(
				new CreatePackagePropertyExtractor().buildExceptionMessage(
					APropertyExtractor.X_MISSING_REQUIRED_DATA,
					new List<String>{
						CreatePackagePropertyExtractor.KEY_DOCUMENT_COLLECTION,
						CreatePackagePropertyExtractor.KEY_NAME
					}
				)));
		}
	}

	@isTest
	private static void shouldReturnDocumentCollectionName() {
		Map<String, Object> docCollection = new Map<String, Object>();
		docCollection.put(CreatePackagePropertyExtractor.KEY_NAME, '🍄');

		nFUSE.AMiddlewareMessage message = new nFUSE.MiddlewareMessage();
		message.properties = new Map<String, Object>();
		message.properties.put(CreatePackagePropertyExtractor.KEY_DOCUMENT_COLLECTION, docCollection);

		try {
			String name = new CreatePackagePropertyExtractor().getDocumentCollectionName((Map<String, Object>) JSON.deserializeUntyped(message.toMsg()));
			System.assertEquals('🍄', name);
		} catch (Exception ex) {
			System.assert(false, ex.getMessage());
		}
	}

	@isTest
	private static void shouldReturnException_WhenNoAuthorizedSigners() {
		nFUSE.AMiddlewareMessage message = new nFUSE.MiddlewareMessage();
		message.properties = new Map<String, Object>();

		try {
			new CreatePackagePropertyExtractor().getAuthorizedSigners((Map<String, Object>) JSON.deserializeUntyped(message.toMsg()));
			System.assert(false, 'expected exception was not thrown');
		} catch (Exception ex) {
			System.assert(ex.getMessage().startsWith(
				new CreatePackagePropertyExtractor().buildExceptionMessage(
					APropertyExtractor.X_MISSING_REQUIRED_DATA,
					new List<String>{CreatePackagePropertyExtractor.KEY_AUTHORIZED_SIGNERS}
				)
			));
		}
	}

	@isTest
	private static void shouldReturnAuthorizedSigners() {
		nFUSE.AMiddlewareMessage message = prepareMiddlewareMessage();

		Test.startTest();
		List<Map<String, Object>> signers = new CreatePackagePropertyExtractor().getAuthorizedSigners((Map<String, Object>) JSON.deserializeUntyped(message.toMsg()));
		Test.stopTest();

		System.assertEquals(2, signers.size());
		System.assertNotEquals(null, signers[0].get(CreatePackagePropertyExtractor.KEY_PROPERTIES));

	}

	@isTest
	private static void shouldReturnException_WhenNoSignerAuthFirstName() {
		Map<String, Object> contactSigner = new Map<String, Object>();
		contactSigner.put(CreatePackagePropertyExtractor.KEY_PROPERTIES, new Map<String, Object>());

		try {
			new CreatePackagePropertyExtractor().getSignerAuthFirstName(contactSigner);
			System.assert(false, 'expected exception was not thrown');
		} catch (Exception ex) {
			System.assert(ex.getMessage().startsWith(
				new CreatePackagePropertyExtractor().buildExceptionMessage(
					APropertyExtractor.X_MISSING_REQUIRED_DATA,
					new List<String>{
						CreatePackagePropertyExtractor.KEY_AUTHORIZED_SIGNERS,
						CreatePackagePropertyExtractor.KEY_FIRST_NAME

					}
				)));
		}
	}

	@isTest
	private static void shouldReturnSignerAuthFirstName() {
		Map<String, Object> authSigner = getAuthSigner('🎤', 'Drop', 'mike@drop.com', 'Mike_Drop');

		try {
			String name = new CreatePackagePropertyExtractor().getSignerAuthFirstName(authSigner);
			System.assertEquals('🎤', name);
		} catch (Exception ex) {
			System.assert(false, ex.getMessage());
		}
	}

	@isTest
	private static void shouldReturnException_WhenNoSignerAuthLastName() {
		Map<String, Object> contactSigner = new Map<String, Object>();
		contactSigner.put(CreatePackagePropertyExtractor.KEY_PROPERTIES, new Map<String, Object>());

		try {
			new CreatePackagePropertyExtractor().getSignerAuthLastName(contactSigner);
			System.assert(false, 'expected exception was not thrown');
		} catch (Exception ex) {
			System.assert(ex.getMessage().startsWith(
				new CreatePackagePropertyExtractor().buildExceptionMessage(
					APropertyExtractor.X_MISSING_REQUIRED_DATA,
					new List<String>{
						CreatePackagePropertyExtractor.KEY_AUTHORIZED_SIGNERS,
						CreatePackagePropertyExtractor.KEY_LAST_NAME
					}
				)));
		}
	}

	@isTest
	private static void shouldReturnSignerAuthLastName() {
		Map<String, Object> authSigner = getAuthSigner('🎤', 'Drop', 'mike@drop.com', 'Mike_Drop');

		try {
			String name = new CreatePackagePropertyExtractor().getSignerAuthLastName(authSigner);
			System.assertEquals('Drop', name);
		} catch (Exception ex) {
			System.assert(false, ex.getMessage());
		}
	}

	@isTest
	private static void shouldReturnException_WhenNoSignerAuthEmail() {
		Map<String, Object> contactSigner = new Map<String, Object>();
		contactSigner.put(CreatePackagePropertyExtractor.KEY_PROPERTIES, new Map<String, Object>());

		try {
			new CreatePackagePropertyExtractor().getSignerAuthEmail(contactSigner);
			System.assert(false, 'expected exception was not thrown');
		} catch (Exception ex) {
			System.assert(ex.getMessage().startsWith(
				new CreatePackagePropertyExtractor().buildExceptionMessage(
					APropertyExtractor.X_MISSING_REQUIRED_DATA,
					new List<String>{
						CreatePackagePropertyExtractor.KEY_AUTHORIZED_SIGNERS,
						CreatePackagePropertyExtractor.KEY_EMAIL
					}
				)));
		}
	}

	@isTest
	private static void shouldReturnSignerAuthEmail() {
		Map<String, Object> authSigner = getAuthSigner('🎤', 'Drop', 'mike@drop.com', 'Mike_Drop');

		try {
			String name = new CreatePackagePropertyExtractor().getSignerAuthEmail(authSigner);
			System.assertEquals('mike@drop.com', name);
		} catch (Exception ex) {
			System.assert(false, ex.getMessage());
		}
	}

	@isTest
	private static void shouldReturnException_WhenNoSignerAuthId() {
		Map<String, Object> contactSigner = new Map<String, Object>();
		contactSigner.put(CreatePackagePropertyExtractor.KEY_PROPERTIES, new Map<String, Object>());

		try {
			new CreatePackagePropertyExtractor().getSignerAuthId(contactSigner);
			System.assert(false, 'expected exception was not thrown');
		} catch (Exception ex) {
			System.assert(ex.getMessage().startsWith(
				new CreatePackagePropertyExtractor().buildExceptionMessage(
					APropertyExtractor.X_MISSING_REQUIRED_DATA,
					new List<String>{
						CreatePackagePropertyExtractor.KEY_AUTHORIZED_SIGNERS,
						CreatePackagePropertyExtractor.KEY_RECORD_ID
					}
				)));
		}
	}

	@isTest
	private static void shouldReturnSignerAuthId() {
		Map<String, Object> authSigner = getAuthSigner('🎤', 'Drop', 'mike@drop.com', 'Mike_Drop');

		try {
			String name = new CreatePackagePropertyExtractor().getSignerAuthId(authSigner);
			System.assertEquals('Mike_Drop', name);
		} catch (Exception ex) {
			System.assert(false, ex.getMessage());
		}
	}

	private static nFUSE.AMiddlewareMessage prepareMiddlewareMessage() {
		nFUSE.AMiddlewareMessage message = new nFUSE.MiddlewareMessage();

		Map<String, Object> authSigner1 = getAuthSigner('Cup', 'Joe', 'cup@joe.com', 'Cup_of_Joe');
		Map<String, Object> authSigner2 = getAuthSigner('🎤', 'Drop', 'mike@drop.com', 'Mike_Drop');

		message.properties = new Map<String, Object>();
		message.properties.put(CreatePackagePropertyExtractor.KEY_AUTHORIZED_SIGNERS,
			new List<Map<String, Object>>{authSigner1, authSigner2});

		return message;
	}

	private static Map<String, Object> getAuthSigner(String firstName, String lastName, String email, String signerId) {
		Map<String, Object> signer = new Map<String, Object>();
		Map<String, Object> fnameMap = new Map<String, Object>();
		Map<String, Object> lnameMap = new Map<String, Object>();
		Map<String, Object> emailMap = new Map<String, Object>();

		fnameMap.put(APropertyExtractor.KEY_VALUE, firstName);
		lnameMap.put(APropertyExtractor.KEY_VALUE, lastName);
		emailMap.put(APropertyExtractor.KEY_VALUE, email);

		signer.put(CreatePackagePropertyExtractor.KEY_FIRST_NAME, fnameMap);
		signer.put(CreatePackagePropertyExtractor.KEY_LAST_NAME, lnameMap);
		signer.put(CreatePackagePropertyExtractor.KEY_EMAIL, emailMap);

		Map<String, Object> contactSigner1 = new Map<String, Object>();
		contactSigner1.put(CreatePackagePropertyExtractor.KEY_RECORD_ID, signerId);
		contactSigner1.put(CreatePackagePropertyExtractor.KEY_PROPERTIES, signer);

		return contactSigner1;
	}
}