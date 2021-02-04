var DocMan = (DocMan) ? DocMan : {};
(function(){
	var BotwS3FileStore = function(config) {
		var AWS_REGION = 'us-east-1';
		var ACCESS_KEY = 'AKIAJSBCPFIOL3JPQ3IQ';
		var SECRET_KEY = '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'; 
		var CONTEXT_OBJECT_HEADER= 'x-amz-meta-context-obj';
		var S3_STORAGE_NAME = 'S3';

		var self = this;
		self.associatedObjectId = null;
		self.bucketName = null;
		self.bucket = null;
		self.endpointName = null;
		self.searchName = null;
		self.userId = null;
		self.endpoint = null;
		self.tin = null;
		self.objectName = null;
		self.loanName = null;
		self.accountName = null;
		self.product = null;
		self.fileTypeMap = null;
		_.extend(self, config);

		AWS.config.update({
			accessKeyId : ACCESS_KEY,
			secretAccessKey : SECRET_KEY,
			region : AWS_REGION
		});
		self.endpoint = new AWS.Endpoint(self.endpointName);
		self.bucket = new AWS.S3({
			endpoint : self.endpoint,
			params : {Bucket : self.bucketName},
			httpOptions: {timeout: 240000}
		});

		function base64ToBlob(base64file, fileType){
			var byteCharacters = atob(base64file);
			var byteNumbers = new Array(byteCharacters.length);
			for (var i = 0; i < byteCharacters.length; i++) {
				byteNumbers[i] = byteCharacters.charCodeAt(i);
			}
			var byteArray = new Uint8Array(byteNumbers);
			return new Blob([byteArray.buffer], {type: fileType});
		}

		self.uploadDocument = function(fileWrapper, successCallback, failureCallback){
			var fileType = self.fileTypeMap[fileWrapper.type];
			var blob = base64ToBlob(fileWrapper.base64file, fileWrapper.type);
			var fileKey = fileWrapper.file.name;
			var docType = fileWrapper.filename;
			docType = docType.substr(0, docType.lastIndexOf('.'));
			var params = {
				Key : fileKey,
				ContentType : fileWrapper.type,
				ContentLength : fileWrapper.file.size,
				Body : blob,
				Metadata : {'BusinessName' : self.loanName,
							'RelationshipName' : self.accountName,
							'UniqueIdentifier' : fileWrapper.docStoreId,
							'TIN' : self.tin,
							'DocumentCategory' : fileWrapper.docType,
							'DocumentType' : docType,
							'FileExtensionType' : fileType,
							'DocumentSubCategory' : fileWrapper.docType,
							'ProductorAccountType' : self.product,
							'ObligorNumber' : '',
							'DealerNumber' : '',
							'CustomerNumber' : '',
							'Guarantors' : '',
							'DocumentDescription' : '',
							'AddedByUserID' : self.userId,
				}
			};
			self.bucket.putObject(params, function (err, data) {
				if(err){
					console.log('could not upload file to S3');
					console.log(err);
					if(_.isFunction(successCallback)){
						failureCallback.apply(this, [fileWrapper]);
					}
				} else {
					console.log('successCallback = ' + JSON.stringify(successCallback));
					fileWrapper.externalId = fileKey;
					if(_.isFunction(successCallback)){
						successCallback.apply(this, [fileWrapper]);
					}
				}
			});
		};

		self.setDocumentMetadata = function(fileWrapper, successCallback) {
			DocMan.updateMetadataExternalFile(
				self.associatedObjectId,
				JSON.stringify({
					documentId : fileWrapper.documentId,
					name : fileWrapper.file.name,
					type : fileWrapper.type,
					size : fileWrapper.file.size,
					docStoreId : fileWrapper.docStoreId,
					externalId : fileWrapper.documentId + '/' + fileWrapper.file.name,
					storageType : S3_STORAGE_NAME,
					isDeleted : false,
					filenetDocId : null
				}),
				function(data) {
					if(_.isFunction(successCallback)){
						successCallback.apply(this, [data]);
					}
				},
				DocMan.failure
			);
		};

		self.retrieveFiles = function() {
			var params = {Prefix : self.associatedObjectId + '/',};
			self.bucket.listObjects(params, function(err, data){
				if(err){
					console.log('could not load objects from S3');
					console.log(err);
				} else {
					console.log(data.Contents.length + ' items from S3');
					console.log(data);
				}
			});
		};

		self.downloadDocument = function(documentId) {
			DocMan.getDocument(
				self.associatedObjectId,
				documentId,
				function(data) {
					if (data.filenetDocId !== undefined && data.filenetDocId !== null && $.trim(data.filenetDocId) !== '') {
						var params = {Key : data.filenetDocId};
						self.bucket.getObject(params, function(err, url){
							if(err){
								console.log('could not get download url');
								console.log(err);
							} else {
								var file = new Blob([url.Body], {type: url.Metadata.mimetype});
								var fileURL = URL.createObjectURL(file);
								window.open(fileURL);
							}
						});
					} else {
						console.log('no associated Document Id has been returned');
					}
				},
				DocMan.failure
			);
		};

		self.searchDocumentIds = function(successCallback){
			var paramString = '?';
			var searchParams = {
				'bucket' : self.bucketName,
				'tin' : self.tin
			};
			for (var key in searchParams){
				paramString = paramString + '&' + key + '=' + searchParams[key];
			};
			var results = searchExternalDocumentIds(paramString);
			if(results != null){
				DocMan.retrieveExternalDocumentIds(
					self.associatedObjectId,
					results,
					null,
					function(data) { 
						if(_.isFunction(successCallback)){
							successCallback.apply(this, [data]);
						}
					},
					DocMan.failure
				);
			}
		};

		self.init = function() {
			self.getFileTypeExtensionMap();
			if(self.tin != null){
				self.tin = self.tin.replace('-','');
			}
			self.searchDocumentIds();
			return self;
		};

		self.getFileTypeExtensionMap = function(){
			DocMan.retrieveMimeTypeShort(
				function(data){
					self.fileTypeMap = data;
				},
				DocMan.failure
			);
		};

		function searchExternalDocumentIds(paramString){
			var url = self.bucket.endpoint.href + '/' + self.searchName + paramString;
			var httpReq = new XMLHttpRequest();
			var results = null;
			httpReq.open('GET', url, false);
			httpReq.setRequestHeader("Content-type","application/xml");
			httpReq.send(null);
			if(httpReq.status == 200) {
				results = JSON.stringify(httpReq.responseText);
				results = JSON.parse(results);
				results = JSON.stringify(results).replace(/\<\?xml.+\?\>|\"/g, '');
				results = JSON.stringify(results).replace(/(\r\n|\\n|\r|\\|\n|\s+)/g,'').trim();
			}
			else {
				console.log('search request failed');
			}
			return results;
		};

		self.deleteDocument = function(documentId, successCallback){
			DocMan.getDocument(
				self.associatedObjectId,
				documentId,
				function(data) {
					if (data.externalId !== undefined && data.externalId !== null && $.trim(data.externalId) !== '') {
						var params = {Key : data.externalId};
						self.bucket.deleteObject(params, function(err, data){
							if(err){
								console.log('could not delete file from S3');
								console.log(err);
							} else {
								if(_.isFunction(successCallback)){
									successCallback.apply(this, [data]);
								}
							}
						});
					}
				},
				DocMan.failure
			);
		};

		return self;
	};
	if(!DocMan.BotwS3FileStore){
		DocMan.BotwS3FileStore = BotwS3FileStore;
	}
})();
