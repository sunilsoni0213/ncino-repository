public class CSA_ObjectHistoryController  {
	public Integer PAGE_SIZE { get; set; }
	public Integer OFFSET {get;set;}
	public String objName;
	public String objHistName {get;set;}
	public String recordId;
	public Map <String, String> fieldLabels { get;set; }
	public Map <String, String> fieldTypes { get;set; }
	public Map <String, Object> recordOldValues { get; set; }
	public Map <String, Object> recordNewValues { get; set; }
	public Map <String, Integer> fieldScales { get;set; } 
	private SObjectType objType = null;
	public String errorMessage {get;Set;}
	 
	private List<SObject> histRecordList = new List<SObject>();
	public Boolean hasNext { get; set;} 
	public Boolean hasPrevious { get; set;} 
	private Map <String, Schema.SObjectField> fieldMap = null;

	public PageReference NextPage() {
		this.OFFSET += PAGE_SIZE;
		this.getRecords();
		return null;
	}

	public PageReference PreviousPage() {
		this.OFFSET -= PAGE_SIZE;
		this.getRecords();
		return null;
	}

	public Boolean getDisplayPrevious () {
		return this.hasPrevious;
	}
	public Boolean getDisplayNext () {
		return this.hasNext;
	}

	public List<SObject> getRecordList() {
		return this.histRecordList;
	}

	public CSA_ObjectHistoryController() { 
		this.OFFSET = 0;
		this.PAGE_SIZE = 10;
		this.hasNext = false;
		this.hasPrevious = false;
		
		this.recordId = ApexPages.currentPage().getParameters().get('id'); 
		this.objType = Id.valueOf(this.recordId).getSobjectType();
		DescribeSObjectResult objDesc = objType.getDescribe();

		this.objName = objDesc.getName();

		this.recordOldValues = new Map<String, Object>();
		this.recordNewValues = new Map<String, Object>(); 
		fieldMap = objDesc.fields.getMap();
		this.fieldScales = new Map<String, Integer>(); 
		this.fieldLabels = new Map<String, String>();
		this.fieldTypes = new Map<String, String>();
		
		for (String currField : fieldMap.keySet()) {
			String currFieldName = fieldMap.get(currField).getDescribe().getName();
			Schema.DescribeFieldResult dfr = fieldMap.get(currField).getDescribe();
			this.fieldLabels.put(currFieldName, dfr.getLabel());
			this.fieldTypes.put(currFieldName, String.valueOf(dfr.getType()).toLowerCase());
			this.fieldScales.put(currFieldName, dfr.getScale());
		}
		this.getRecords();
	}	


	 /*******************************************************************************************************
    * @description Query records for Selected Object
    */
    public void getRecords() { 
		this.hasNext = false;
		this.hasPrevious = false;
		try {
			
			this.recordOldValues = new Map<String, Object>();
			this.recordNewValues = new Map<String, Object>();
			histRecordList.clear();
			
			if (this.objName != '') {
				// If objName contains __c replace with __history for the objHistName value
				if ((this.objHistName == null || this.objHistName == '') && this.objName.contains('__c')) {
					this.objHistName = objName.replace('__c', '__history');
				}
				String histQuery = 'SELECT ParentId, OldValue, NewValue, Field, CreatedBy.Name, CreatedDate FROM ' + this.objHistName + ' where parentId = \'' + recordId + '\' ORDER BY CreatedDate DESC LIMIT ' + String.valueOf(PAGE_SIZE + 1);
				if (OFFSET > 0) {
					histQuery = histQuery + ' OFFSET ' + String.valueOf(OFFSET);
					this.hasPrevious = true;
				}

				System.debug(histQuery);
				histRecordList = Database.query(histQuery);

				if (histRecordList.size() > PAGE_SIZE) {
					histRecordList.remove(PAGE_SIZE);
					this.hasNext = true;
				}

				for (SObject currObj : histRecordList) {
					String currField = String.valueOf(currObj.get('Field'));
					String currId = String.valueOf(currObj.get('Id'));
					if (fieldMap.containsKey(currField)) {
						nFORCE.Field oldValue = new nFORCE.Field(objType, fieldMap.get(currField), currObj.get('OldValue'));
						nFORCE.Field newValue = new nFORCE.Field(objType, fieldMap.get(currField), currObj.get('NewValue'));
						this.recordOldValues.put(currId, oldValue.getValue());
						this.recordNewValues.put(currId, newValue.getValue());
					}
					else {
						System.debug('Field not found in map: ' + currField);
					}
				}

				
			} 

		} catch (exception ex) {
            errorMessage = ex.getMessage();
        }
    } 
}