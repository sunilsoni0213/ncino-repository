public with sharing class CSA_ScreenSectionList {
	public nForce__Screen_Section__c screenSection {get;Set;}
	public Integer numSectionConfig {get;Set;}
	public Integer numSectionAttachment {get;Set;}

	public CSA_ScreenSectionList(nForce__Screen_Section__c sSection) {
		this.screenSection = sSection;
		this.numSectionConfig = getNumSectionConfig(sSection.Id);
		this.numSectionAttachment = getNumSectionAttachment(sSection.Id);
	}

	private Integer getNumSectionConfig(Id recordId) {
		return [SELECT
					COUNT()
				FROM 
					nForce__Section_Configuration__c
				WHERE 
					nForce__Screen_Section__c = :recordId];
	}

	private Integer getNumSectionAttachment(Id recordId) {
		return [SELECT
					COUNT()
				FROM 
					Attachment
				WHERE 
					ParentId = :recordId];
	} 
}