public with sharing class WebSvcCallout {
	public static MetadataService.SaveResult[] upsertPicklists(){
		MetadataService.MetadataPort service = createService();
		MetadataService.SaveResult[] sampleResult = service.updateMetadata(new List<MetadataService.Metadata>());
		return sampleResult;
	}

	private static MetadataService.MetadataPort createService() {
		MetadataService.MetadataPort service = new MetadataService.MetadataPort();
		service.SessionHeader = new MetadataService.SessionHeader_element();
		service.SessionHeader.sessionId = UserInfo.getSessionId();
		return service;
	}
}