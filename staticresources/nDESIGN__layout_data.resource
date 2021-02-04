if(!window.Layout){
	window.Layout = {};
}
if(!Layout.DATA){
	Layout.DATA = {};
	(function(DATA){
		// supported data types per: http://www.salesforce.com/us/developer/docs/apexcode/Content/apex_methods_system_fields_describe.htm?SearchType=Stem&Highlight=Describe|describes|described|describe|Describes|describing#apex_displaytype
		DATA.fieldTypes = ['anytype',
								'base64',
								'Boolean',
								'Combobox',
								'Currency',
								'DataCategoryGroupReference',
								'Date',
								'DateTime',
								'Double',
								'Email',
								'EncryptedString',
								'ID',
								'Integer',
								'MultiPicklist',
								'Percent',
								'Phone',
								'Picklist',
								'Reference',
								'String',
								'TextArea',
								'Time',
								'URL'];
		_.each(DATA.fieldTypes, function(element, index){
			DATA.fieldTypes[element.toUpperCase()] = element.toUpperCase();
			delete DATA.fieldTypes[index];
		});
		
	})(Layout.DATA);
}
