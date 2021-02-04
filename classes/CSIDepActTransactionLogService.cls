public class CSIDepActTransactionLogService {

    public CSIDepActTransactionLogService(){}

    public nFUSE__Transaction_Log__c getTransactionLog(String id) {
        nFUSE__Transaction_Log__c[] logs = [
                SELECT
                        Id,
                        nFUSE__External_Id__c,
                        nFUSE__Vendor_Status__c,
                        nFUSE__Transaction_Status__c,
                        nFUSE__Primary_Object_Id__c
                FROM
                        nFUSE__Transaction_Log__c
                WHERE
                        nFUSE__External_Id__c =: id
                OR
                        Id =: id
        ];

        if(logs != null && logs.size() > 0)
            return logs[0];

        return null;
    }

    public void updateVendorStatus(String externalId, String vendorStatus){
        updateVendorStatus(externalId, vendorStatus, null);
    }
    public void updateVendorStatus(String externalId, String vendorStatus, String transactionStatus){

        nFUSE__Transaction_Log__c log = getTransactionLog(externalId);
        if(log == null) throw new XTransactionLogServiceException(CSIDepActDocPrepConstants.X_NO_TRANSACTION_FOUND);
        if(transactionStatus != null){
            log.nFUSE__Transaction_Status__c = transactionStatus;
        }
        log.nFUSE__Vendor_Status__c = vendorStatus;
        nFORCE.DmlUtility.updateObj(log);
    }

    public Attachment getLogAttachment(String attachmentName, String logExternalId){
        nFUSE__Transaction_Log__c log = this.getTransactionLog(logExternalId);
        return getLogAttachment(attachmentName, log.Id);
    }

    public Attachment getLogAttachment(String attachmentName, Id logId){
        List<Attachment> attachments =  [
                SELECT
                        Id,
                        Body,
                        BodyLength,
                        ContentType,
                        CreatedDate,
                        Description
                FROM
                        Attachment
                WHERE
                        ParentId =: logId
                AND
                        Name LIKE: attachmentName
                ORDER BY
                        CreatedDate desc
                Limit 1];
        if(attachments != null && attachments.size() > 0){
            return attachments[0];
        }
        return null;
    }

    private class XTransactionLogServiceException extends Exception {}

}