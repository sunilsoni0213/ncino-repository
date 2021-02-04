public class LPReferral {
     public static final String destinationUrl =
        'https://llclp.na14.visual.force.com/apex/LaserPro_Review?scontrolCaching=1';

    public String referral {get;set;}
    public String finalDestination {get;set;}

    public LPReferral() {
      referral = ApexPages.currentPage().getHeaders().get('referer');
        finalDestination = destinationUrl + getId();
    }


    public String getId()
    {
        Integer idIndex = referral.indexOf('&id=');
        String currId = '';
        if (idIndex > 0) {
            currId = referral.substring(idIndex);
            currId = currId.replace('&scontrolCaching=1', '');
        }
        return currId;
    }

    public PageReference redirect() {
        
        return new PageReference(finalDestination);
    }
}