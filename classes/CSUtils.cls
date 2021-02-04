/*

________/\\\\\\\\\_____/\\\\\\\\\\\____/\\\________/\\\______________________/\\\\\\_________________
 _____/\\\////////____/\\\/////////\\\_\/\\\_______\/\\\_____________________\////\\\_________________
  ___/\\\/____________\//\\\______\///__\/\\\_______\/\\\_____/\\\_______/\\\____\/\\\_________________
   __/\\\_______________\////\\\_________\/\\\_______\/\\\__/\\\\\\\\\\\_\///_____\/\\\_____/\\\\\\\\\\_
    _\/\\\__________________\////\\\______\/\\\_______\/\\\_\////\\\////___/\\\____\/\\\____\/\\\//////__
     _\//\\\____________________\////\\\___\/\\\_______\/\\\____\/\\\______\/\\\____\/\\\____\/\\\\\\\\\\_
      __\///\\\___________/\\\______\//\\\__\//\\\______/\\\_____\/\\\_/\\__\/\\\____\/\\\____\////////\\\_
       ____\////\\\\\\\\\_\///\\\\\\\\\\\/____\///\\\\\\\\\/______\//\\\\\___\/\\\__/\\\\\\\\\__/\\\\\\\\\\_
        _______\/////////____\///////////________\/////////_________\/////____\///__\/////////__\//////////__

*/

public with sharing class CSUtils {

    private static Map<String, Schema.SObjectType> sObjectTypeMap = Schema.getGlobalDescribe();
    private static Map<String, Map<String, Schema.RecordTypeInfo>> sObjectTypeToRecordTypesMap = new Map<String, Map<String, Schema.RecordTypeInfo>>();
    private static final String NAMESPACE = CSUtils.class.getName().substringBefore('CSUtils').removeEnd('.');


    /**
     * Determine if a String object has a numeric value.
     */
    public static Boolean isNumeric(String value) {
        try {
            Double.valueOf(value);
            return true;
        } catch (Exception e) {
            return false;
        }
    }
    
    /**
     * Determine if a String is a valid email address.
     */
    public static Boolean isValidEmail(String email) {
        if (email == null) {
            return true;
        } else {
            return Pattern.matches('[a-zA-Z0-9]+[a-zA-Z0-9\\.\\_]*[a-zA-Z0-9]+@[a-zA-Z0-9\\-]+(\\.[a-zA-Z]+)+', email);
        }
    }

    /**
     * Left pad a String to the given length with the given pad character.
     */
    public static String leftPad(String value, String pad, Integer length) {
        if (value != null) {
            while ((length - value.length()) > 0) {
                value = pad + value;
            }
        }

        return value;
    }

    /**
     * Right pad a String to the given length with the given pad character.
     */
    public static String rightPad(String value, String pad, Integer length) {
        if (value != null) {
            while ((length - value.length()) > 0) {
                value += pad;
            }
        }

        return value;
    }

    /**
     * Convert a String to an array (List) of characters (1-letter Strings).
     */
    public static List<String> toCharacterArray(String value) {
        if (value == null) {
            return null;
        }

        List<String> characters = new List<String>();

        for (Integer i = 0; i < value.length(); i++) {
            characters.add(value.substring(i, i + 1));
        }

        return characters;
    }

    /**
     * Perform a null-safe equals comparison on two strings.
     */
    public static Boolean nullSafeEquals(String a, String b) {
        return a == null ? (b == null ? true : false) : (b == null ? false : a.equals(b));
    }

    /**
     * Join a set of String values into one string separated by the specified separator.
     * NOTE: For consistency, the values in the set are sorted after being converted to a list.
     */
    public static String join(Set<String> values, String separator) {
        List<String> valuesList;

        if (values != null) {
            valuesList = new List<String>();
            valuesList.addAll(values);
            valuesList.sort();
        }

        return String.join(valuesList, separator);
    }

    /**
     * Join a list of field values from a list of SObjects into one string separated by the specified separator.
     */
    public static String join(List<sObject> objects, String fieldName, String separator) {
        List<String> valuesList;

        if (objects != null) {
            valuesList = new List<String>();

            for (sObject obj : objects) {
                valuesList.add(String.valueOf(obj.get(fieldName)));
            }
        }

        return String.join(valuesList, separator);
    }

    /*
     * Shuffles a list of Strings into random order.
     */
    public static List<String> shuffle(List<String> values) {
        if (values == null) return null;

        Integer top = values.size();
        Integer current = top;

        if (top > 1) {
            while (--top > 0) {
                current = Math.floor(Math.random() * (top + 1)).intValue();
                String value = values[current];
                values[current] = values[top];
                values[top] = value;
            }
        }

        return values;
    }

    /**
     * Wraps a string in quote (") characters and escapes any existing quotes in the string.
     */
    public static String quote(String value) {
        if (String.isBlank(value)) return '""';

        String escaped = value.replace('"', '""');

        return '"' + escaped + '"';
    }

    /**
     * Quotes a list of values.
     */
    public static List<String> quote(List<String> values) {
        if (values == null) return null;

        List<String> quotedValues = new List<String>();
        for (String value : values) {
            String quotedValue = quote(value);
            quotedvalues.add(quotedValue);
        }

        return quotedValues;
    }

    /**
     * Wraps a string in sinql quote (') characters and escapes any existing single quotes in the string.
    */
    public static String singleQuote(String value) {
        if (String.isBlank(value)) return '\'\'';

        return '\'' + String.escapeSingleQuotes(value) + '\'';
    }

    /**
    * Single quotes a list of values.
    */
    public static List<String> singleQuote(List<String> values) {
        if (values == null) return null;

        List<String> quotedValues = new List<String>();
        for (String value : values) {
            String quotedValue = singleQuote(value);
            quotedvalues.add(quotedValue);
        }

        return quotedValues;
    }

    /**
     * Format a Date with the given format.
     */
    public static String formatDate(Date d, String format) {
        if (d == null) return null;

        DateTime dt = DateTime.newInstance(d.year(), d.month(), d.day());
        return dt.format(format);
    }

    /**
     * Format a DateTime as UTC format (e.g., 2010-03-12T19:44:00Z).
     */
    public static String formatDateTimeUTC(DateTime dt) {
        if (dt == null) return null;

        return dt.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
    }

    /**
     * Convert a DateTime object to a Date object.
     */
    public static Date convertDateTimeToDate(DateTime dt) {
        if (dt == null) return null;

        return Date.newInstance(dt.year(), dt.month(), dt.day());
    }

    /**
     * Given an SObject name and Record Type name, return the Record Type's Id.
     */
    public static Id getRecordTypeId(String sObjectType, String recordType) {
        if (sObjectTypeToRecordTypesMap.containsKey(sObjectType) == false) {
            Schema.SObjectType sotype = sObjectTypeMap.get(sObjectType);
            Map<String, Schema.RecordTypeInfo> recordTypesMap = sotype.getDescribe().getRecordTypeInfosByName();
            sObjectTypeToRecordTypesMap.put(sObjectType, recordTypesMap);
        }

        Map<String, Schema.RecordTypeInfo> recordTypesMap = sObjectTypeToRecordTypesMap.get(sObjectType);
        if (recordTypesMap != null) {
            Schema.RecordTypeInfo recordTypeInfo = recordTypesMap.get(recordType);
            if (recordTypeInfo != null) {
                return recordTypeInfo.getRecordTypeId();
            }
        }

        return null;
    }

    /**
     * Get metadata for an SObject.
     */
    public static Schema.DescribeSObjectResult getObjectMetadata(String objectName) {
        Schema.sObjectType objectType = sObjectTypeMap.get(objectName);
        if (objectType == null) {
            return null;
        }

        return objectType.getDescribe();
    }

    /**
     * Get metadata for an SObject's field.
     */
    public static Schema.DescribeFieldResult getFieldMetadata(String objectName, String fieldName) {
        Map<String, Schema.SObjectField> fieldsMap = getObjectMetadata(objectName).fields.getMap();
        return fieldsMap.get(fieldName).getDescribe();
    }

    /**
     * Get a list of a field's picklist values.
     */
    public static List<String> getPicklistValues(String objectName, String fieldName, Boolean sortValues) {
        List<String> values = new List<String>();

        for (Schema.PickListEntry entry : getFieldMetadata(objectName, fieldName).getPickListValues()) {
            values.add(entry.getValue());
        }

        if (sortValues) {
            values.sort();
        }

        return values;
    }

    /**
     * Get a field's picklist default value.
     */
    public static String getPicklistDefaultValue(String objectName, String fieldName) {
        for (Schema.PickListEntry entry : getFieldMetadata(objectName, fieldName).getPickListValues()) {
            if (entry.isDefaultValue()) {
                return entry.getValue();
            }
        }

        return null;
    }

    /**
     * Get a field's picklist values as list of SelectOptions that can be used with a VF page.
     */
    public static List<SelectOption> getPicklistAsSelectOptions(String objectName, String fieldName, Boolean sortValues) {
        List<SelectOption> selectOptions = new List<SelectOption>();
        for (String value : getPicklistValues(objectName, fieldName, sortValues)) {
            selectOptions.add(new SelectOption(value, value));
        }

        return selectOptions;
    }

    /**
     * Get the field length for a text field.
     */
    public static Integer getTextFieldLength(String objectName, String fieldName) {
        return getFieldMetadata(objectName, fieldName).getLength();
    }

    /**
     * Given a Salesforce object id, return the name of the object that the id is for.
     */
    public static String getObjectNameFromId(Id id) {
        if (id == null) return null;

        return id.getSObjectType().getDescribe().getName();

    }

    /**
     * Converts a Salesforce id to fifteen character variant.
     */
    public static String fifteenCharacterId(String originalId) {
        if (String.isBlank(originalId) || originalId.length() <= 15) {
            return originalId;
        }

        return originalId.substring(0, 15);
    }

    /**
     * Given two objects and a set of field names, determine if any of the fields' values are different.
     */
    public static Boolean fieldValuesDifferent(SOBject objectA, SObject objectB, Set<String> fieldNames) {
        for (String fieldName : fieldNames) {
            if (objectA.get(fieldName) != objectB.get(fieldName)) {
                return true;
            }
        }

        return false;
    }

    /**
     * Send an email.
     */
    public static void sendEmail(List<String> recipients, String subject, String message) {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(recipients);
        email.setSubject(subject);
        email.setPlainTextBody(message);
        email.setHtmlBody(message);

        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{
                email
        });
    }

    /**
     * returns day of week as a string ('Monday', 'Tuesday', etc)
     */

    public static String dayOfWeek(Date d) {
        Datetime dt = DateTime.newInstance(d.year(), d.month(), d.day());
        return dt.format('EEEE');
    }


    /**
	 * Returns a preformatted soql select statement
	 * with all viewable fields in alphabetical order
	 */
    public static String selectStar(String objectName, Boolean standardOnly) {
        SObjectType objToken = Schema.getGlobalDescribe().get(objectName);
        DescribeSObjectResult objDef = objToken.getDescribe();
        Map<String, SObjectField> fields = objDef.fields.getMap();
        Set<String> fieldSet = fields.keySet();
        List<String> fieldList = new List<String>{
        };
        fieldList.addAll(fields.keySet());
        fieldList.sort();
        List<String> fieldsToQuery = new List<String>{
        };

        for (String fieldName : fieldList) {
            SObjectField fieldToken = fields.get(fieldName);
            DescribeFieldResult selectedField = fieldToken.getDescribe();

            //respect CRUD/FLS
            if (selectedField.isAccessible()) {
                if (standardOnly && !fieldName.endsWith('__c')) {
                    //only add standard fields
                    fieldsToQuery.add(selectedField.getName());
                } else if (!standardOnly) {
                    //add standard and custom fields
                    fieldsToQuery.add(selectedField.getName());
                }
            } else {
                System.debug('not accessible: ' + selectedField.getName());
            }
        }

        String queryString = 'SELECT ';
        queryString += String.join(fieldsToQuery, ', ');
        queryString += ' FROM ' + objectName + ' ';

        return queryString;
    }

    public static SObjectType getSObjectType(String objectName) {
        sObjectType sobjType = sObjectTypeMap.get(objectName);

        if (sobjType == null) {
            sobjType = sObjectTypeMap.get(applyNameSpace(objectName));
        }
        return sobjType;
    }

    public static String applyNameSpace(String item) {
        String newValue = item;
        String nameSpace = getNamespaceWithUnderScores();
        if (String.isNotBlank(newValue)) {
            if (!item.containsIgnoreCase(nameSpace)) {
                newValue = nameSpace + item;
            }
        }
        return newValue;
    }

    public static String getNamespace() {
        return NAMESPACE;
    }

    public static Boolean isNamespaced() {
        return String.isNotEmpty(NAMESPACE);
    }

    public static String getNamespaceWithUnderScores() {
        String nameSpace = getNamespace();

        if (nameSpace != '') {
            return nameSpace + '__';
        } else {
            return '';
        }
    }

    public static String getNamespaceWithPeriod(){
        String nameSpace = getNamespace();
        if ( String.isNotBlank(nameSpace)) {
            return nameSpace + '.';
        } else {
            return '';
        }
    }

    public static Schema.DescribeSObjectResult getObjectDescription(String objectName) {
        Schema.sObjectType objectType = sObjectTypeMap.get(objectName);
        if (objectType == null) {
            return null;
        }

        return objectType.getDescribe();
    }


    /*
 * Convert a Decimal to an Integer by removing everything after the decimal.
 */
    public static Integer convertDecimalToInteger(Decimal dec) {
        String decimalString = dec + '';

        Integer decimalPlace = decimalString.indexOf('.');
        if (decimalPlace != -1) {
            decimalString = decimalString.substring(0, decimalPlace);
        }

        return Integer.valueOf(decimalString);
    }

    public static String getbaseUrlForVF() {
        String url = null;
        Id userId = UserInfo.getUserId();
        List<User> users = [SELECT Id, SmallPhotoUrl FROM User WHERE Id =: userId];
        User u = users[0];
        url = u.SmallPhotoUrl;
        url = url.substringBefore('.com');

        if(url.contains('content.force')){
            url = url.replace('content.force','visual.force.com');
        }else{
            //This is the new url format effective March 16, 2019
            //https://help.salesforce.com/articleView?id=000270912&language=en_US&type=1
            url = url.replace('documentforce','visualforce.com');
        }

        if(isNamespaced()){
            url = url = url.replace('--c','--' + getNamespace().toLowerCase());
        }
        return url;
    }

    public static String getLightningUrl() {
        String lightningDomain = URL.getOrgDomainUrl().toString().substringBetween('[delegate=',']');
        lightningDomain = lightningDomain.substringBefore('.');
        lightningDomain += '.lightning.force.com';
        return lightningDomain;
    }
}