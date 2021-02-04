global with sharing class MaintenanceTypeController {

	@RemoteAction
	global static Set<String> retrieveMaintenanceTypes(){
		Schema.DescribeFieldResult fieldResult = Task.LLC_BI__SubType__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		Set<String> picVals = new Set<String>();
		for (Schema.PicklistEntry a : ple ) {
			picVals.add(a.getValue());
		}
		return picVals;
	}

	@RemoteAction
	global static Set<String> upsertMaintenanceTypes(List<String> newMaintenanceTypes){
		Set<String> maintenanceTypes = retrieveMaintenanceTypes();
		for(String maint : newMaintenanceTypes){
			if(!maintenanceTypes.contains(maint)){
				maintenanceTypes.add(maint);
			}
		}
		MetadataService.Picklist picklist = new MetadataService.Picklist();
		picklist.picklistValues = getPicklistValues(maintenanceTypes);
		picklist.sorted = true;
		String fieldName = SUBTYPE_FIELD;
		String label = Schema.Task.fields.LLC_BI__SubType__c.getDescribe().getLabel();
		String result = upsertPicklistMetadata(picklist, 'description', fieldName, label);
		return retrieveMaintenanceTypes();
	}

	private static String upsertPicklistMetadata(MetadataService.Picklist newTypes, String description, String fieldName, String label){
		MetadataService.MetadataPort mdCall = createService();
		MetadataService.CustomField customField = new MetadataService.CustomField();

		customField.fullName = fieldName;
		customField.label = label;
		customField.description = FIELD_DESCRIPTION;
		customField.type_x = PICKLIST;
		customField.picklist = newTypes;

		List<MetadataService.SaveResult> results = mdCall.updateMetadata(new List<MetadataService.Metadata> {customField});
		if(results != null){
			if(results.size() > 0){
				if(results[0].errors != null){
					return results[0].errors[0].message;
				}
			}
		}
		return null;

	}

	private static MetadataService.PicklistValue[] getPicklistValues(Set<String> newValues){
		MetadataService.PicklistValue[] newPicklists = new List<MetadataService.PicklistValue>();
		for(String newVal : newValues){
			MetadataService.PicklistValue plistValue = new MetadataService.PicklistValue();
			plistValue.fullName = newVal;
			plistValue.default_x = false;
			newPicklists.add(plistValue);
		}
		return newPicklists;
	}

	public static void getDependentPicklistValuesByRecordType(){
		MetadataService.MetadataPort service = createService();

		MetadataService.CustomField customField = (MetadataService.CustomField) service.readMetadata(
			CUSTOM_FIELD, new String[] { SUBTYPE_FIELD }
		).getRecords()[0];

		MetadataService.RecordType recordType = (MetadataService.RecordType) service.readMetadata(
			RECORD_TYPE, new String[] { CATEGORY_FIELD }
		).getRecords()[0];

		Map<String, MetadataService.PicklistValue> picklistValuesMap = new Map<String, MetadataService.PicklistValue>();
		for ( MetadataService.PicklistValue pk : customField.picklist.picklistValues ) {
			picklistValuesMap.put( pk.fullName, pk );
		}

		List<MetadataService.PicklistValue> filteredDependentValues = new List<MetadataService.PicklistValue>();

		for ( MetadataService.RecordTypePicklistValue rpk : recordType.picklistValues ) {
			if(MAINTENANCE_TYPE == rpk.picklist) {
				for ( MetadataService.PicklistValue pk : rpk.values) {
					MetadataService.PicklistValue picklistValue = picklistValuesMap.get( pk.fullName );
					String controllingFieldValue = YES;
					if ((picklistValue.controllingFieldValues == null ) || new Set<String>(picklistValue.controllingFieldValues).contains(controllingFieldValue)) {
						filteredDependentValues.add( picklistValue );
					}
				}
			}
		}
	}

	public static MetadataService.MetadataPort createService() {
		MetadataService.MetadataPort service = new MetadataService.MetadataPort();
		service.SessionHeader = new MetadataService.SessionHeader_element();
		service.SessionHeader.sessionId = UserInfo.getSessionId();
		return service;
	}


	private static final String SUBTYPE_FIELD ='Activity.LLC_BI__SubType__c';
	private static final String CATEGORY_FIELD = 'Activity.LLC_BI__Maintenance_Type__c';
	private static final String PICKLIST = 'Picklist';
	private static final String CUSTOM_FIELD = 'CustomField';
	private static final String RECORD_TYPE = 'RecordType';
	private static final String YES = 'Yes';
	private static final String FIELD_DESCRIPTION = 'This field is not required. This field is manually populated. This field describes the current Maintenance type for a particluar Maintenance Task. It is dependent on the LLC_BI__Maintenance_Type__c (Maintenance Category)';
	private static final String MAINTENANCE_TYPE = 'LLC_BI__Maintenance_Type__c';
}