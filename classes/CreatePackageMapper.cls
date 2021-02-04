public with sharing class CreatePackageMapper {
	@TestVisible
	CreatePackagePropertyExtractor extractor = new CreatePackagePropertyExtractor();

	public CreatePackageModel buildCreatePackageModel(nFUSE.AMiddlewareMessage message) {
		Map<String, Object> msgMap = (Map<String, Object>) JSON.deserializeUntyped(message.toMsg());
		List<Map<String, Object>> authorizedSigners = extractor.getAuthorizedSigners(msgMap);

		CreatePackageModel model = new CreatePackageModel();
		model.status = PACKAGE_STATUS_DRAFT;
		model.emailMessage = '';
		model.language = LANGUAGE_EN;
		model.name = extractor.getDocumentCollectionName(msgMap);
		model.data = new PackageCustomData();
		model.data.documentCollectionId = extractor.getDocumentCollectionId(msgMap);

		model.roles = new List<Role>();
		Set<String> processedEmails = new Set<String>();
		for (Map<String, Object> authSigner : authorizedSigners) {
			String email = extractor.getSignerAuthEmail(authSigner).toLowerCase();
			//todo - this is here until the nFUSE bug for duplicate auths is resolved
			if (containsEmail(processedEmails, email)) continue;
			processedEmails.add(email);

			Signer signer = new Signer();
			signer.email = email;
			signer.firstName = extractor.getSignerAuthFirstName(authSigner);
			signer.lastName = extractor.getSignerAuthLastName(authSigner);

			Role role = new Role();
			role.id = extractor.getSignerAuthId(authSigner);
			role.signers = new List<Signer>{
				signer
			};

			model.roles.add(role);
		}

		return model;
	}

	private Boolean containsEmail(Set<String> emails, String authSignerEmail) {
		return emails.contains(authSignerEmail);
	}

	private class XException extends Exception {
	}

	@TestVisible
	private static final String
		LANGUAGE_EN = 'en',
		PACKAGE_STATUS_DRAFT = 'DRAFT';
	private static final Integer MAX_ID_LENGTH = 65;
}