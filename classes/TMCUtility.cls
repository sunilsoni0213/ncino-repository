public with sharing class TMCUtility {

	public static String getNamespace(){
		String ns = getCoreNamespace();
		if(ns == LLCBI){
			ns += UNDERSCORES;
		}
		return ns;
	}

	public static String getCoreNamespace(){
		ApexClass cs =[select NamespacePrefix from ApexClass where Name =:'TreasuryManagementConvertController'];
		return cs.NamespacePrefix;
	}

	public static String getConfigNamespace() {
		ApexClass cs = [select NamespacePrefix from ApexClass where Name =:'UpsertPicklistMockCallout'];
		return cs.NamespacePrefix;
	}

	public static String alphanumericOnly(String text) {
		String specialChars = ',|.|~|:|;|@|#|$|%|^|&|*|(|)|-|_|+|=|<|>|?|`|[|]|{|}|"|!|\\|/|\'';
		for(integer i=0; i<specialChars.split('|').size(); i++)
			text = text.replace(specialChars.split('|')[i], '');
		text = text.deleteWhiteSpace();
		return text;
	}

	public static sObject createSystemProperty(
		String propertyName,
		String categoryName,
		String key,
		String value,
		Boolean isActive,
		Boolean insertRecord
	) {
		Schema.SObjectType systemPropertyType = 
			Schema.getGlobalDescribe().get(TreasuryConfigurationConstants.PROPERTY_TABLE_NAME);
		if (systemPropertyType == null) {
			
		}
		sObject systemProperty = systemPropertyType.newSObject();
		systemProperty.put(
			TreasuryConfigurationConstants.PROPERTY_FIELD_NAME, 
			(propertyName == null ? (new LLC_BI.GuidGenerator()).randomUUID() : propertyName));
		systemProperty.put(TreasuryConfigurationConstants.PROPERTY_FIELD_CATEGORY, categoryName);
		systemProperty.put(TreasuryConfigurationConstants.PROPERTY_FIELD_KEY, key);
		systemProperty.put(TreasuryConfigurationConstants.PROPERTY_FIELD_VALUE, value);
		systemProperty.put(TreasuryConfigurationConstants.PROPERTY_FIELD_IS_ACTIVE, isActive);

		if (insertRecord) {
			insert systemProperty;
		}
		
		return systemProperty;
	}

	public static sObject updateSystemProperty(
		String propertyName,
		String categoryName,
		String key,
		String value,
		Boolean isActive
	) {
		sObject property= 
			retrieveSystemPropertyObject(
				categoryName,
				key);
		if (property != null) {
			property.put(TreasuryConfigurationConstants.PROPERTY_FIELD_VALUE, value);
			if (isActive != null) {
				property.put(TreasuryConfigurationConstants.PROPERTY_FIELD_IS_ACTIVE, isActive);
			}
			Database.update(property);
		} else {
			property = 
				createSystemProperty(
			    	(propertyName == null ? (new LLC_BI.GuidGenerator()).randomUUID() : propertyName),
			    	categoryName,
			    	key,
			    	value,
			    	isActive,
			    	true
				);
		}
		return property;
	}

	public static void deleteSystemProperty(
		String categoryName,
		String key
	) {
		sObject property = 
			retrieveSystemPropertyObject(
				categoryName,
				key);
		if (property != null) {
			Database.delete(property);
		}
    }

	public static Boolean isProduction() {
		return
			TreasuryConfigurationConstants.SYSTEM_PROPERTIES.getPropertyAsBoolean(
				TreasuryConfigurationConstants.TM_CONFIG_CATEGORY, 
				TreasuryConfigurationConstants.TM_CONFIG_IS_PRODUCTION_KEY, 
				false);
	}

	public static Boolean isToolDataInstalled() {
		return
			TreasuryConfigurationConstants.SYSTEM_PROPERTIES.getPropertyAsBoolean(
				TreasuryConfigurationConstants.TM_CONFIG_CATEGORY, 
				TreasuryConfigurationConstants.TM_INITIAL_DATA_INSTALLED_KEY, 
				false);
	}

	public static Boolean isConfigurationToolInstalled() {
		return
			TreasuryConfigurationConstants.SYSTEM_PROPERTIES.getPropertyAsBoolean(
				TreasuryConfigurationConstants.TM_CONFIG_CATEGORY, 
				TreasuryConfigurationConstants.TM_CONFIGURATION_TOOL_INSTALLED_KEY, 
				false);
	}

	public static sObject retrieveSystemPropertyObject(
		String categoryName,
		String key
	){
		sObject retObject = null;
		String queryString = 
			getQueryString(
				TreasuryConfigurationConstants.PROPERTY_TABLE_NAME,
				new List<String>{
					TreasuryConfigurationConstants.PROPERTY_FIELD_CATEGORY,
					TreasuryConfigurationConstants.PROPERTY_FIELD_KEY,
					TreasuryConfigurationConstants.PROPERTY_FIELD_VALUE,
					TreasuryConfigurationConstants.PROPERTY_FIELD_IS_ACTIVE
				},
				TreasuryConfigurationConstants.PROPERTY_FIELD_KEY + ' = \'' + key + '\'' +
					' AND ' + 
					TreasuryConfigurationConstants.PROPERTY_FIELD_CATEGORY + ' = \'' + categoryName + '\'' + 
					' LIMIT 1',
				null
			);
		sObject[] properties = Database.query(queryString);

		if (properties != null && properties.size() > 0) {
			retObject = properties[0];
		}
		return retObject;
	}

	/**
	* Method to generate a query string from its component parts
	*
	* @param  objectName     Name of the object to query from
	* @param  fields         List of fields to query
	* @param  whereClause    Where clause to add to query
	* @param  orderByClause  Order by clause to add to query
	*
	* @return queryString    Fully qualified query string from component parts
	*/
	public static String getQueryString(String objectName, List<String> fields, String whereClause, String orderbyClause) {
		String query = 'SELECT ';
		if (fields != null) {
			for (String field : fields) {
				query += field + ',';
			}
		}
		query += 'ID ';
		query += 'FROM ' + objectName;
		if (whereClause != null) {
			query += ' WHERE ' + whereClause;
		}
 		if (orderbyClause != null) {
			query += ' ORDER BY ' + orderbyClause;
		}
		return query;
	}

//	public static final nFORCE.SystemProperties SYSTEM_PROPERTIES = nFORCE.SystemProperties.getInstance();
	private static final String LLCBI = 'LLC_BI';
	private static final String UNDERSCORES = '__';
}