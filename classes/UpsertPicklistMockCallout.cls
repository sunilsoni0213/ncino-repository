@isTest
public class UpsertPicklistMockCallout implements WebServiceMock {
	public void doInvoke(
			Object stub,
			Object request,
			Map<String, Object> response,
			String endpoint,
			String soapAction,
			String requestName,
			String responseNS,
			String responseName,
			String responseType) {
		MetadataService.updateMetadataResponse_element responseElement = new MetadataService.updateMetadataResponse_element();
		responseElement.result = createResponse();
		response.put('response_x', responseElement); 
	}

	public MetadataService.SaveResult[] createResponse(){
		MetadataService.SaveResult[] result = new MetadataService.SaveResult[]{};
		return result;
	}
}