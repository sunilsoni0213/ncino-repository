public with sharing class PrimaryIndividualContactController {
	
	private final Account acct {get;set;}
	public Contact contact {get;set;}
	private Id contactId {get;set;}
	public List<Contact> noPrimary {get;set;}

	public Boolean showContact {get;set;}
	public Boolean showNoPrimary {get;set;}
	public Boolean showEdit {get;set;}
    
	public PrimaryIndividualContactController(ApexPages.StandardController controller) {
		this.acct = (Account)controller.getRecord();

		this.theStart();
	}

	public PageReference theStart() {
		List<Contact> primary = [SELECT 
                                            Id 
									FROM 
                                            Contact 
									WHERE 
                                            AccountId =: acct.Id 
									AND 
                                            LLC_BI__Primary_Contact__c = true];

		if(primary.size() > 0) {
			contactId = primary.get(0).Id;
			this.contact = getTheContact();
			showContact = true;
			showNoPrimary = false;
			showEdit = false;
		} else {
			this.noPrimary = [SELECT   Id, 
									   Name, 
									   LLC_BI__Primary_Contact__c 
								FROM 
                                        Contact 
								WHERE 
                                        AccountId =:acct.Id];
			showContact = false;
			showNoPrimary = true;
			showEdit = false;
		}

		return null;
	}

	public List<Schema.FieldSetMember> getColumn1Fields() {
        return SObjectType.Contact.FieldSets.PrimaryContactColumn1.getFields();
    }

    public List<Schema.FieldSetMember> getColumn2Fields() {
        return SObjectType.Contact.FieldSets.PrimaryContactColumn2.getFields();
    }

    public Contact getTheContact() {
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : this.getColumn1Fields()) {
            query += f.getFieldPath() + ', ';
        }
        for(Schema.FieldSetMember f : this.getColumn2Fields()) {
            query += f.getFieldPath() + ', ';
        }
        query += 'Id, Name FROM Contact WHERE Id = \'' + contactId + '\'';
        return Database.query(query);
    }

    public PageReference theSavePrimaryConatact() {
    	try {
    		update contact;
    		theStart();
    	} catch(Exception ex) {
    		ApexPages.addMessages(ex);
    	}

    	return null;
    }

    public PageReference theSaveNewPrimary() {
    	try {
    		update noPrimary;
    		theStart();
    	} catch(Exception ex) {
    		ApexPages.addMessages(ex);
    	}
    	
    	return null;
    }

    public PageReference theEdit() {
    	showEdit = true;
    	showContact = false;
    	showNoPrimary = false;

    	return null;
    }

    public PageReference theCancel() {
    	return theStart();
    }
}