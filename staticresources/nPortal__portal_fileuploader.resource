var Portal = Portal || {};
(function(){
	var FileUploader = function(){
		var self = this;
		var config = {
			sfdcSessionId: '',
			maxFileSize: 0,
			maxFileSizeDisplay: 0,
			remoteActions: {},
			messages: {}
		};
		var uploadTriggerSelector = '.upload-trigger';
		var downloadTriggerSelector = '.download-trigger';
		var submitAllDocumentsSelector = '#submitDocuments';
		var STATUS_REVIEW = 'REVIEW';
		var SYSTEM_ERROR_NO_PLATFORM_LICENSE = '(1028437153)';

		self.generateErrorMarkup = function(documentId, message) {
			var $footer = jQuery('#' + documentId + '_footer');
			$footer.removeClass('portal-success');
			$footer.addClass('portal-failure');

			jQuery('#' + documentId + '_success').hide();
			jQuery('#' + documentId + '_failure').show();

			self.showMessage(documentId, message);
		};

		self.generateSuccessMarkup = function(documentId, message) {
			var $footer = jQuery('#' + documentId + '_footer');
			$footer.removeClass('portal-failure');
			$footer.addClass('portal-success');

			jQuery('#' + documentId + '_failure').hide();
			jQuery('#' + documentId + '_success').show();

			self.showMessage(documentId, message);
		};

		self.showMessage = function(documentId, message) {
			var $message = jQuery('#' + documentId + '_message');
			$message.text(message);
			if (message) {
				$message.show();
			}
			else {
				$message.hide();
			}
		};

		self.enableUploadButtons = function(){
			jQuery(uploadTriggerSelector).removeAttr('disabled');
		};

		self.disableUploadButtons = function(){
			jQuery(uploadTriggerSelector).attr('disabled', 'disabled');
		};

		self.showProgressBar = function(documentId) {
			jQuery('#' + documentId + '_success').hide();
			jQuery('#' + documentId + '_failure').hide();
			jQuery('#' + documentId + '_spinner').show();

			var $footer = jQuery('#' + documentId + '_footer');
			$footer.removeClass('portal-failure');
			$footer.addClass('portal-success');
		};

		self.hideProgressBar = function(documentId) {
			jQuery('#' + documentId + '_spinner').hide();
		};

		self.getUploadDisplayForDocument = function(documentId){
			return jQuery('#' + documentId + '_upload');
		};

		self.getObjectContextId = function(documentId) {
			return jQuery('#' + documentId + '_filename').attr('data-context');
		};

		self.rollbackDocument = function(contextId, doc) {
			Visualforce.remoting.Manager.invokeAction(
				config.remoteActions.uploadFailed,
				contextId,
				doc,
				function(){}
			);
		};

		self.uploadFileToDocumentStore = function(documentId, attachmentId, file, rawFile) {
			Visualforce.remoting.Manager.invokeAction(
				config.remoteActions.initializeUpload,
				function(doc) {
					self.upload(
						doc,
						attachmentId,
						file,
						rawFile,
						function(response) {
							var documentStoreIndexId = doc.documentStoreIndexId || '';
							self.updateDocument(response.id, documentId, documentStoreIndexId, file);
						},
						function(request, status, response) {
							var $uploadDisplay = self.getUploadDisplayForDocument(documentId);
							$uploadDisplay.append(self.generateErrorMarkup(documentId, config.messages.error_upload));
							self.hideProgressBar(documentId);
							self.enableUploadButtons();
							self.rollbackDocument(self.getObjectContextId(documentId), doc);
						},
						function(ev) {
						}
					);
				}
			);
		};

		self.updateDocument = function(objectId, documentId, docStoreIndexId, file) {
			var fileProps = {};
			fileProps.name = file.name;
			fileProps.size = file.size;
			fileProps.type = file.type;
			Visualforce.remoting.Manager.invokeAction(
				(self.isInReview(documentId) ? config.remoteActions.replaceDocument : config.remoteActions.updateDocument),
				objectId,
				documentId,
				docStoreIndexId,
				JSON.stringify(fileProps),
				function(result, event) {
					var $uploadDisplay = self.getUploadDisplayForDocument(documentId);
					if (event.type === 'exception' && !self.isSFSystemError(event.message)) {
						$uploadDisplay.append(self.generateErrorMarkup(documentId, config.messages.error_upload));
						self.hideProgressBar(documentId);
						self.enableUploadButtons();
						self.rollbackDocument(self.getObjectContextId(documentId), {id: documentId});
					} else {
						$uploadDisplay.append(self.generateSuccessMarkup());
						setTimeout(function(){ window.location.reload(); },2000);
					}
				}
			);
		};

		self.isSFSystemError = function(message) {
			if (message.indexOf('System Error') != -1 && message.indexOf(SYSTEM_ERROR_NO_PLATFORM_LICENSE) != -1) {
				return true;
			}
			return false;
		};

		self.handleFilesAdded = function(e, documentId, attachmentId, documentStoreIndexId) {
			var file = e.target.files[0];

			if (file == null) {
				// Handle event in some browsers where a file is clicked but the dialog is cancelled
				console.log('No file selected.');
				return;
			}

			self.clearUploadDisplay(documentId);

			// update UI for upload
			self.disableUploadButtons();
			jQuery('#' + documentId + '_name').text(file.name);
			self.showProgressBar(documentId);

			if(file.size > config.maxFileSize){
				self.generateErrorMarkup(documentId, config.messages.error_size);
				self.hideProgressBar(documentId);
				self.enableUploadButtons();
				return false;
			}

			var extensionAllowed = false;
			for(var i = 0; i < config.uploadConfig.allowedFileExtensions.length; i++){
				var extension = config.uploadConfig.allowedFileExtensions[i];
				if(file.name.indexOf(extension, file.name.length - extension.length) !== -1){
					extensionAllowed = true;
					break;
				}
			}

			if (config.uploadConfig.allowedFileExtensions.length > 0 && !extensionAllowed){
				self.generateErrorMarkup(documentId, config.messages.error_extension);
				self.hideProgressBar(documentId);
				self.enableUploadButtons();
				return false;
			}

			// Upload using apex:inputFile
			jQuery(submitAllDocumentsSelector).prop('disabled', true);
			self.uploadFileToDocumentStore(documentId, attachmentId, file, e.target.result);

			return true;
		};

		self.getConfig = function(){
			return config;
		};

		self.clearUploadDisplay = function(documentId) {
			var $footer = jQuery('#' + documentId + '_footer');
			$footer.removeClass('portal-success');
			$footer.removeClass('portal-failure');
			self.showMessage(documentId, '');
		};

		self.prepareFileUpload = function(){
			var acceptList = [];
			for(var i = 0; i < config.uploadConfig.allowedFileExtensions; i++){
				acceptList.push({
					title: i,
					extension: config.uploadConfig.allowedFileExtensions[i]
				});
			}

			jQuery(document.getElementById(config.fileElements.currentFile)).change(function(event) {
				var documentId = document.getElementById(config.fileElements.currentDocId).value;
				var attachmentId = document.getElementById(config.fileElements.currentAttachmentId).value;
				self.handleFilesAdded(event, documentId, attachmentId);
			});

			jQuery('.upload-trigger').click(function(event) {
				var documentId = jQuery(event.target).attr('id');
				var attachmentId = jQuery(event.target).attr('data-attachment');
				document.getElementById(config.fileElements.currentDocId).value = documentId;
				document.getElementById(config.fileElements.currentAttachmentId).value = attachmentId;
				jQuery(document.getElementById(config.fileElements.currentFile)).trigger('click');
			});
		};

		self.downloadAttachment = function(url){
			window.open(url);
		};

		self.initUI = function(){
			jQuery('[data-toggle="tooltip"]').tooltip();

			// init click event for download
			jQuery(downloadTriggerSelector).on('click', function(e){
				e.preventDefault();
				var url = config.uploadConfig.sitePrefix + jQuery(this).attr('data-url');
				self.downloadAttachment(url);
			});

			// init click event for submit all documents
			jQuery(submitAllDocumentsSelector).on('click', function(e){
				e.preventDefault();
				self.submitAllDocuments();
			});

			var canSubmitDocuments = jQuery('.populatedDocumentId').length > 0;
			jQuery(submitAllDocumentsSelector).prop('disabled', !canSubmitDocuments);

			// Set initial footer state for all placeholders
			jQuery('.upload-trigger').each(function(index) {
				var documentId = jQuery(this).attr('id');
				if (jQuery('#' + documentId + '_rejectionReason').length > 0) {
					// Document is rejected
					jQuery(this).text(config.messages.button_replace);
					self.generateErrorMarkup(documentId);
				}
				else if (jQuery.trim(jQuery('#' + documentId + '_name').html()).length > 0) {
					// Document has been uploaded already
					jQuery(this).text(config.messages.button_replace);
					self.generateSuccessMarkup(documentId);
				}
			});

			//disable upload
			if(!config.uploadConfig.canUpload) {
				jQuery.each(jQuery(uploadTriggerSelector), function(){
					self.disableUploadButtons();
					self.generateErrorMarkup(this.id, config.messages.error_locked);
				});
			}
		};

		self.init = function(options){
			jQuery.extend(true, config, options);
			self.initUI();
			self.prepareFileUpload();
		};

		self.submitAllDocuments = function() {
			var documentIds = [];
			jQuery('.populatedDocumentId').each(function(index) {
				documentIds.push(jQuery(this).val());
			});
			self.submitDocuments(documentIds);
		};

		self.submitDocuments = function(documentIds) {
			Visualforce.remoting.Manager.invokeAction(
				config.remoteActions.submitDocuments,
				config.uploadConfig.recordId,
				documentIds,
				function(result, event) {
					if (event.status) {
						window.location.reload();
					} else {
						console.error(event);
					}
				},
				{
					escape: false,
					buffer: false
				}
			);
		};

		self.isInReview = function(documentId) {
			return jQuery('#' + documentId + '_reviewStatus').val() == STATUS_REVIEW;
		};

		self.upload = function(doc, attachmentId, file, rawFile, successCallback, failureCallback, progressCallback) {
			var contentParams;
			var blobField;

			if (config.uploadConfig.objectType == 'ContentVersion') {
				// Content Document
				contentParams = {
					Origin: 'C',
					PathOnClient: file.name,
					Title: file.name
				};
				blobField = 'VersionData';

				if (attachmentId) {
					contentParams.ContentDocumentId = attachmentId;
					contentParams.ReasonForChange = 'New Version';

					Visualforce.remoting.Manager.invokeAction(
						config.remoteActions.takeOwnershipOfDocument,
						attachmentId,
						function() {
							self.createBlob(file, contentParams, blobField, successCallback, failureCallback, progressCallback);
						}
					);
				}
				else {
					self.createBlob(file, contentParams, blobField, successCallback, failureCallback, progressCallback);
				}
			}
			else {
				// Attachment
				contentParams = {
					'ParentId': doc.documentStoreId,
					'Name': file.name,
					'ContentType': file.type
				};
				blobField = 'Body';

				self.createBlob(file, contentParams, blobField, successCallback, failureCallback, progressCallback);
			}


		};

		self.createBlob = function(file, contentParams, blobField, successCallback, failureCallback, progressCallback) {
			var forcetkClient = new forcetk.Client();
			forcetkClient.setSessionToken(config.sfdcSessionId, null, config.sitePrefix);
			forcetkClient.proxyUrl = null;
			forcetkClient.createBlob(
				config.uploadConfig.objectType,
				contentParams,
				file.name,
				blobField,
				file,
				successCallback,
				failureCallback,
				null,
				progressCallback
			);
		};

		return self;
	};
	Portal.FileUploader = Portal.FileUploader || new FileUploader();
})();