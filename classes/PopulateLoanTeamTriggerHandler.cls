global class PopulateLoanTeamTriggerHandler extends LLC_BI__.ATriggerHandler {
	private map<String, String> sourceFields = new map<String, String>();
	private map<String, String> targetFields = new map<String, String>();
	private map<String, String> targetRoleName = new map<String, String>();
	private map<Id,User> users;
	List<LLC_BI__LoanTeam__c> teamRecordsToInsert = new List<LLC_BI__LoanTeam__c>();
					
	global override boolean isDoubleFireSafe() {
		return false;
	}
	
	global override type getType() {
		return Type.forName(CLASS_NAME);
	}

	global override void afterInsert(
		List<sObject> objs, 
		set<Id> objIds) 
	{
		if (objs != null && objs.size() > 0) {
			initCopyData();
			getUserRecords(objs);
			for (LLC_BI__Loan__c loan : (List<LLC_BI__Loan__c>)objs) {
				Id loanOfficerId = (Id)loan.LLC_BI__Loan_Officer__c;
				if (loanOfficerId != null) {
					for (String key : sourceFields.keySet()) {
						Id userId = (Id)((User)users.get(loanOfficerId)).get(sourceFields.get(key));
						String role = (String)targetRoleName.get(key);
						teamRecordsToInsert.add(newTeamRecord(loan.id, role, userId));
					}
				}
			}
		}
		if (teamRecordsToInsert != null && teamRecordsToInsert.size() > 0) {
			addAllInsert(teamRecordsToInsert);
		}
	}

	private LLC_BI__LoanTeam__c newTeamRecord(id loanId, String role, Id roleUserId) { //'Manager', manager)
		return 
			new LLC_BI__LoanTeam__c (
				LLC_BI__Loan__c = loanId,
				LLC_BI__Role__c = role,
				LLC_BI__User__c = roleUserId
			);
	}
	private void getUserRecords(List<sObject>objs){
		set<Id> userIds = new set<Id>();
		for (LLC_BI__Loan__c loan : (List<LLC_BI__Loan__c>)objs) {
			if (loan.LLC_BI__Loan_Officer__c != null) {
				userIds.add(loan.LLC_BI__Loan_Officer__c);
			}
		}
		String sObjClass = 'User'; // get the sObject name from sObject
		List<String> fieldList = this.sourceFields.values();
		String query =
			new RelationshipViewQueryClass(
	        	sObjClass,
	        	fieldList, 
	        	new String[]{'Id'},
	        	null,
	        	new Object[]{':userIds'},
	        	null,
	        	new String[]{'IN'}
	        ).toString();
		
        this.users = 
	        new Map<Id,User>(
		        (List<User>)database.query(
		        	query
				)
		    );
	}
	
	private void initCopyData() {
		// Note: Once the system properties object is updated to expose getting the category collections
		//       modify this to remove the iteration over the systemProperties map
		LLC_BI__.SystemProperties props = LLC_BI__.SystemProperties.getInstance();
		
		Map<String,LLC_BI__System_Properties__c> systemProperties = LLC_BI__System_Properties__c.getAll();
		
		List<String> keyNames = new List<String>();
		
		for (String key:systemProperties.keySet()){
			LLC_BI__System_Properties__c systemProperty = SystemProperties.get(key);
		
			if(systemProperty.LLC_BI__Category_Name__c == 'LoanTeam'){
				keyNames.add(key);
				this.sourceFields.put(key,props.getProperty('LoanTeam.'+systemProperties.get(key).LLC_BI__Key__c+'.sourceField','sourceField'));
				this.targetFields.put(key,props.getProperty('LoanTeam.'+systemProperties.get(key).LLC_BI__Key__c+'.targetField','targetField'));
				this.targetRoleName.put(key,props.getProperty('LoanTeam.'+systemProperties.get(key).LLC_BI__Key__c+'.roleName','roleName'));
			}
		}
	}

	private static String CLASS_NAME = 'PopulateLoanTeamTriggerHandler';
}