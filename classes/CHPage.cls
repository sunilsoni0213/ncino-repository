global with sharing class CHPage {

	@AuraEnabled
	public static string sayMyName(id recordId){
		string nameField;

		Schema.SObjectType token = recordId.getSObjectType();
		for (Schema.SObjectField dfr:token.getDescribe().fields.getMap().values()){
			if (dfr.getDescribe().isNameField()){
				nameField = dfr.getDescribe().getName();
			}
		}
		string query = 'select ' + nameField + ' from ' + recordId.getSObjectType() + ' where id = \'' + recordId + '\'';
		system.debug(query);
		recordStuff rs = new recordStuff();
		rs.recordName = string.valueOf(Database.query(query)[0].get(nameField));
		rs.objectType = string.valueOf(recordId.getSObjectType().getDescribe().getLabel());

		return JSON.serialize(rs);

	}

	class recordStuff {
		string recordName {get;set;}
		string objectType {get;set;}
	}
}