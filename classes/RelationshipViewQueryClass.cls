public with sharing class RelationshipViewQueryClass {
	private String sObjClass = null;
	private List<String> sObjectFields = null; 
	private List<String> whereField = null; 
	private List<String> orderByField = null;
	private List<Object> whereValue = null;
	private String sortDirection = null;
	private List<String> whereClauseOperators = null;

	public RelationshipViewQueryClass(
        String varsObjClass,
        List<String> varsObjectFields,
        List<String> varwhereField,
        List<String> varorderByField,
        List<Object> varwhereValue,
        String varsortDirection,
        List<String> varwhereClauseOperators) 
	{
    	this.sObjClass = varsObjClass;
    	this.sObjectFields = varsObjectFields;
    	this.whereField = varwhereField;
    	this.orderByField = varorderByField;
    	this.whereValue = varwhereValue;
    	this.sortDirection = varsortDirection;
    	this.whereClauseOperators = varwhereClauseOperators;
	}

    public override String toString() {
    	String queryString = '';
        String selectClause = SELECT_CLAUSE_PREFIX;
        String whereClause = '';
		string wherePrefix = WHERE_CLAUSE_PREFIX;
        String orderByClause = '';
	        	
        if ((whereField!= null && whereField.size() > 0) && (whereValue!= null && whereValue.size() > 0)) {
            for (Integer i = 0; i < whereField.size(); i++) {
	         	if (whereClauseOperators[i].containsIgnoreCase('in') || whereValue[i]==null) {
	        		whereClause += wherePrefix +  whereField[i] + ' ' + whereClauseOperators[i] + ' ';
	        		if (whereValue[i]==null || (whereValue[i] instanceOf String) && ((String)whereValue[i]).containsIgnoreCase(':')){
	        			whereClause += whereValue[i];
	        		} else {
        				if (whereValue[i] instanceOf Set<id>) {
            				whereClause += '(' + setToString((Set<Id>)whereValue[i]) + ') ';
        				} else if (whereValue[i] instanceOf String[]) {
        					whereClause += '(' + stringListToString((String[])whereValue[i]) + ') ';
        				}
	        		}
	        	} else {
					if (whereValue[i] instanceOf boolean || whereValue[i] instanceOf Integer) {
						whereClause += wherePrefix + whereField[i] + ' ' + whereClauseOperators[i] + ' ' + whereValue[i];
					} else {
						whereClause += wherePrefix + whereField[i] + ' ' + whereClauseOperators[i] + ' \'' + whereValue[i] + '\'';
					}
	        	}
	        	if (i==0) wherePrefix = AND_CONNECTOR;
	        }
        }
	
        if (orderByField != null && orderByField.size() > 0) {
            orderByClause = ORDER_BY_CLAUSE_PREFIX + orderByField[0];
            for (Integer i = 1; i < orderByField.size(); i++) {
                orderByClause = orderByClause + ', ' + orderByField[i];
            }
        }
	
        orderByClause = 
            (orderByClause != null && orderByClause.length() > 0
                ? (sortDirection != null && sortDirection.length() > 0
                    ? orderByClause + ' ' + sortDirection.trim()
                    : orderByClause)
                : orderByClause);
        
        String fromClause = FROM_CLAUSE_PREFIX + sObjClass;
	        
        if (sObjectFields == null || sObjectFields.size() <= 0) {
            Schema.SObjectType objectType = Schema.getGlobalDescribe().get(sObjClass);
            sObjectFields = new List<String>{};
            try {
                sObjectFields.addAll(objectType.getDescribe().fields.getMap().keySet());
            } catch (Exception e) {
                throw new GQueryException('Schema Error: ' + e.getMessage());
            }
        }
	        
        String prefix = '';
        for (String fieldName: sObjectFields){
            selectClause = selectClause + prefix + fieldName;
            prefix = ', ';
        }
	
        queryString = 
            selectClause + fromClause + whereClause + orderByClause;

		return queryString;               	
    } 
        
    private static String stringListToString(String[] strList) {
   		String returnValue = '';
		boolean firstTime = true;
		for (String value : strList) {
			returnValue += (firstTime ? '\'' + value.trim() + '\'' :  ', \'' + value.trim() + '\'');
			if (firstTime) { firstTime = false; }
		}
    	return returnValue;
    }
    private static String setToString(Set<Id> localSet) {
    	String returnValue = '';
		boolean firstTime = true;
		for (Id value : localSet) {
			returnValue += (firstTime ? '\'' + value + '\'' :  ', \'' + value + '\'');
			if (firstTime) { firstTime = false; }
		}
    	return returnValue;
    }
    	
    public class GQueryException extends Exception{}
    // Generic query code constants
    private static final String SELECT_CLAUSE_PREFIX = 'SELECT ';
    private static final String FROM_CLAUSE_PREFIX = ' FROM ';
    private static final String WHERE_CLAUSE_PREFIX = ' WHERE ';
    private static final String ORDER_BY_CLAUSE_PREFIX = ' order by ';
    private static final String WHERE_CONNECTOR_PREFIX = ' =:'; 
    private static final String AND_CONNECTOR = ' AND ';
}