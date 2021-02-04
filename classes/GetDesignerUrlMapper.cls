public with sharing class GetDesignerUrlMapper {
	@TestVisible
	private GetDesignerUrlPropertyExtractor extractor = new GetDesignerUrlPropertyExtractor();

	public DesignerUrlModel buildDesignerUrlModel(Map<String, Object> message) {
		DesignerUrlModel model = new DesignerUrlModel();
		model.packageId = extractor.getVendorCollectionId(message);

		return model;
	}
}