public virtual class BaseUIReferrer {

    public String destinationUrl { get; set; }
    
    public String getId()
    {
        destinationUrl = 'https://llclp.na14.visual.force.com/apex/LaserPro_Review?scontrolCaching=1';
        String referrer = ApexPages.currentPage().getHeaders().get('referer');
        
        Integer idIndex = referrer.indexOf('&id=');
        String currId = '';
        if (idIndex > 0) { 
        	currId = referrer.substring(idIndex);
        	currId = currId.replace('&scontrolCaching=1', '');
    	}
        return currId;
    }
    
    public PageReference Redirect() {
        return new PageReference(destinationUrl + getId());
    
    }
}