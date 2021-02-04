public with sharing class ContentVersionSelector {
	public ContentVersion fetchContentVersion(String contentVersionId) {
		if (contentVersionId != null) {
			List<ContentVersion> contentVersions = fetchContentVersions(new List<String>{contentVersionId});
			return contentVersions.isEmpty() ? null : contentVersions.get(0);
		}
		return null;
	}

	private List<ContentVersion> fetchContentVersions(List<String> contentVersionIds) {
		if (contentVersionIds != null) {
			List<ContentVersion> contentVersions = [
				SELECT
					VersionData
				FROM
					ContentVersion
				WHERE
					Id IN :contentVersionIds
			];

			return contentVersions;
		}
		return null;
	}
}