public class NewField{
	public String objectName {get; set;}
	public String fieldName {get;set;}
	public String fullName {get;set;}
	public String fieldLabel {get;set;}
	public String fieldType {get; set;}
	private String longName {get; set;}
	private Map<String, Schema.DescribeFieldResult> loanMap {get; set;}
	List<String> fieldList {get; set;}
	Schema.DescribeFieldResult describe {get; set;}
	MetadataService.CustomField field {get;set;}
	MetadataService.MetadataPort service {get;set;}

	public NewField(String objectName, String fieldName, String label, String type, Schema.DescribeFieldResult describeField){
		this.objectName = objectName;
		this.fieldName = fieldName;
		this.fieldLabel = label;
		this.fieldType = type;
		this.describe = describeField;
		this.fullName = objectName+'.'+this.fieldName;
		this.field = new MetadataService.CustomField();
	}

	public MetadataService.CustomField createField(){
		this.field.fullName = this.fullName;
		this.field.label = this.fieldLabel;
		if(this.fieldType != DBL){
			this.field.type_x = this.fieldType;
		} else{
			this.field.type_x = DOUB;
		}
		if(this.field.type_x == TEXTAREA || this.field.type_x == PLAINTEXT){
			return createTextField();
		}
		if(this.field.type_x == DATETYPE || this.field.type_x == DT){
			return createDateField();
		}
		if(this.field.type_x == CURR || this.field.type_x == DOUB || this.field.type_x == PER){
			return createDecimalField();
		}
		if(this.field.type_x == PICKLIST){
			return createPicklistField();
		}
		if(this.field.type_x == BOOL){
			return createBooleanField();
		}
		return this.field;
	}

	public MetadataService.CustomField createTextField(){
		this.field.length = this.describe.getLength();
		return this.field;
	}

	public MetadataService.CustomField createDateField(){
		return this.field;
	}

	public MetadataService.CustomField createDecimalField(){
		this.field.precision = this.describe.getPrecision();
		this.field.scale = this.describe.getScale();
		return this.field;
	}

	public MetadataService.CustomField createPicklistField(){
		this.field.picklist = createPicklist();
		return this.field;
	}

	public MetadataService.CustomField createBooleanField(){
		this.field.defaultValue = 'false';
		return this.field;
	}

	public MetadataService.Picklist createPicklist(){
		MetadataService.Picklist pl = new MetadataService.Picklist();
		pl.sorted = false;
		pl.picklistValues = getPicklistValues();
		return pl;
	}

	public MetadataService.PicklistValue[] getPicklistValues(){
		MetadataService.PicklistValue[] plv = new MetadataService.PicklistValue[] {};
		List<Schema.PicklistEntry> ple = this.describe.getPicklistValues();
		for(Schema.PicklistEntry p : ple){
			MetadataService.PicklistValue pl = new MetadataService.PicklistValue();
			pl.fullName = p.getValue();
			pl.default_x = false;
			if(p.isDefaultValue()){
				pl.default_x = true;
			}
			plv.add(pl);
		}
		return plv;
	}

	public static final String TEXTAREA = 'TextArea';
	public static final String PLAINTEXT = 'Text';
	public static final String PICKLIST = 'Picklist';
	public static final String CURR = 'Currency';
	public static final String INTG = 'Integer';
	public static final String BOOL = 'Checkbox';
	public static final String DT = 'DateTime';
	public static final String PER = 'Percent';
	public static final String DATETYPE = 'Date';
	public static final String DBL = 'Double';
	public static final String DOUB = 'Number';

	private static final String NAMESPACE = 'LLC_BI__';
	private static final String EMPTY_SPACE = '';

}