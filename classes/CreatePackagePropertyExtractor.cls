public with sharing class CreatePackagePropertyExtractor extends APropertyExtractor {

	public String getDocumentCollectionId(Map<String, Object> message) {
		Map<String, Object> collection = getDocumentCollection(message);
		String collectionId = getMapValueAsString(collection.get(KEY_RECORD_ID));
		validateProperty(collectionId, new List<String>{KEY_DOCUMENT_COLLECTION, KEY_RECORD_ID});

		return collectionId;
	}

	public String getDocumentCollectionName(Map<String, Object> message) {
		Map<String, Object> collection = getDocumentCollection(message);
		String collectionId = getMapValueAsString(collection.get(KEY_NAME));
		validateProperty(collectionId, new List<String>{KEY_DOCUMENT_COLLECTION, KEY_NAME});

		return collectionId;
	}

	@TestVisible
	private Map<String, Object> getDocumentCollection(Map<String, Object> message) {
		Map<String, Object> properties = (Map<String, Object>) message.get(KEY_PROPERTIES);
		Map<String, Object> collection = (Map<String, Object>) properties.get(KEY_DOCUMENT_COLLECTION);
		validateProperty(collection, new List<String>{KEY_DOCUMENT_COLLECTION});

		return collection;
	}

	public String getSignerAuthFirstName(Map<String, Object> authSigner) {
		Map<String, Object> props = (Map<String, Object>) authSigner.get(KEY_PROPERTIES);
		String firstName = getMapValueAsString((Map<String, Object>) props.get(KEY_FIRST_NAME));
		validateProperty(firstName, new List<String>{KEY_AUTHORIZED_SIGNERS, KEY_FIRST_NAME});

		return firstName;
	}

	public String getSignerAuthLastName(Map<String, Object> authSigner) {
		Map<String, Object> props = (Map<String, Object>) authSigner.get(KEY_PROPERTIES);
		String lastName = getMapValueAsString((Map<String, Object>) props.get(KEY_LAST_NAME));
		validateProperty(lastName, new List<String>{KEY_AUTHORIZED_SIGNERS, KEY_LAST_NAME});

		return lastName;
	}

	public String getSignerAuthEmail(Map<String, Object> authSigner) {
		Map<String, Object> props = (Map<String, Object>) authSigner.get(KEY_PROPERTIES);
		String email = getMapValueAsString((Map<String, Object>) props.get(KEY_EMAIL));
		validateProperty(email, new List<String>{KEY_AUTHORIZED_SIGNERS, KEY_EMAIL});

		return email;
	}

	public String getSignerAuthId(Map<String, Object> authSigner) {
		String authId = getMapValueAsString(authSigner.get(KEY_RECORD_ID));
		validateProperty(authId, new List<String>{KEY_AUTHORIZED_SIGNERS, KEY_RECORD_ID});

		return authId;
	}

	public List<Map<String, Object>> getAuthorizedSigners(Map<String, Object> message) {
		Map<String, Object> properties = (Map<String, Object>) message.get(KEY_PROPERTIES);
		validateProperty(properties, new List<String>{KEY_PROPERTIES});

		Object signersObj = properties.get(KEY_AUTHORIZED_SIGNERS);
		validateProperty(signersObj, new List<String>{KEY_AUTHORIZED_SIGNERS});

		List<Object> signers = (List<Object>) properties.get(KEY_AUTHORIZED_SIGNERS);
		List<Map<String, Object>> signerMap = new List<Map<String, Object>>();
		for (Object signer : signers) {
			signerMap.add((Map<String, Object>) signer);
		}
		validateProperty(signerMap, new List<String>{KEY_AUTHORIZED_SIGNERS});
		return signerMap;
	}

	@TestVisible
	private static final String
		KEY_AUTHORIZED_SIGNERS = 'authorized_signers',
		KEY_DOCUMENT_COLLECTION = 'document_collection',
		KEY_EMAIL = 'Email',
		KEY_FIRST_NAME = 'FirstName',
		KEY_LAST_NAME = 'LastName',
		KEY_NAME = 'name',
		KEY_PROPERTIES = 'properties',
		KEY_RECORD_ID = 'recordId';
}