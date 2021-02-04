var DocMan = (DocMan) ? DocMan : {};
(function(){
	var SFDCAttachmentFileStore = function(config) {
		var self = this;
		self.sessionId = null;
		self.associatedObjectId = null;
		_.extend(self, config);

		self.uploadDocument = function(fileWrapper, successCallback, failureCallback){
			var newAttachment = new sforce.SObject("Attachment");
			newAttachment.Body = fileWrapper.base64file;
			newAttachment.ContentType = fileWrapper.type;
			newAttachment.Name = fileWrapper.file.name;
			newAttachment.ParentId = fileWrapper.docStoreId;

			sforce.connection.Transfer_Encoding = 'chunked';
			sforce.connection.Authorization = 'Bearer ' + self.sessionId;

			var response = function(result){
				if(result[0] != undefined && result[0].success != undefined && result[0].success == 'true'){
					if(_.isFunction(successCallback)){
						successCallback.apply(this, [fileWrapper]);
					}
				}else{
					if(_.isFunction(failureCallback)){
						failureCallback.apply(this, [fileWrapper]);
					}
				}
			};

			sforce.connection.create([newAttachment], {onSuccess: response, onFailure: response});
		};

		self.setDocumentMetadata = function(fileWrapper, successCallback) {
			DocMan.autoUpdateDocumentAttachment(
				self.associatedObjectId,
				fileWrapper.documentId,
				function(data) { // TODO: is it reasonable to expect all implementations to return this array?
					if(_.isFunction(successCallback)){
						successCallback.apply(this, [data]);
					}
				},
				DocMan.failure
			);
		};

		self.downloadDocument = function(documentId) {
			DocMan.getDocument(
				self.associatedObjectId,
				documentId,
				function(data) {
					if(data.attachmentId !== undefined && data.attachmentId !== null 
						&& $.trim(data.attachmentId) !== '' && !data.isExternal) {

						window.open("/servlet/servlet.FileDownload?file=" + data.attachmentId);
					}else if(data.isExternal && data.docStoreType == 'Offline'){
						Dialogs.openDialogViewOfflineComment(data.offline);
					}
				},
				DocMan.failure
			);
		};

		self.deleteDocument = function(documentId, successCallback){
			DocMan.deleteSFDCAttachment(
				documentId,
				function(data) {
					if(_.isFunction(successCallback)){
						successCallback.apply(this, [data]);
					}
				},
				DocMan.failure
			);
		};

		return self;
	};
	if(!DocMan.SFDCAttachmentFileStore){
		DocMan.SFDCAttachmentFileStore = SFDCAttachmentFileStore;
	}
})();