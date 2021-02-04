var DocMan = (DocMan) ? DocMan : {};
(function(){
	var AmazonS3FileStore = function(config) {
		var AWS_REGION = 'us-east-1';
		var ACCESS_KEY = 'AKIAJSBCPFIOL3JPQ3IQ'; //TODO: handle auth for real
		var SECRET_KEY = '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'; //TODO: handle auth for real
		var CONTEXT_OBJECT_HEADER= 'x-amz-meta-context-obj';
		var S3_STORAGE_NAME = 'S3';

		var self = this;
		self.associatedObjectId = null;
		self.bucketName = null;
		self.bucket = null;
		self.endpointName = null;
		self.endpoint = null;
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
			httpOptions: {timeout: 120000}
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
			var blob = base64ToBlob(fileWrapper.base64file, fileWrapper.type);
			var fileKey = self.associatedObjectId + '/' + fileWrapper.file.name + '_' + moment().valueOf(); // append UNIX timestamp
			var params = {
				Key : fileKey,
				ContentType : fileWrapper.type,
				Body : blob,
				Metadata : {CONTEXT_OBJECT_HEADER : self.associatedObjectId}
			};

			self.bucket.upload(params, function (err, data) {
				if(err){
					console.log('could not upload file to S3');
					console.log(err);
					if(_.isFunction(successCallback)){
						failureCallback.apply(this, [fileWrapper]);
					}
				} else {
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
					externalId : fileWrapper.externalId,
					storageType : S3_STORAGE_NAME,
					isDeleted : false
				}),
				function(data) { // TODO: is it reasonable to expect all implementations to return this array?
					if(_.isFunction(successCallback)){
						successCallback.apply(this, [data]);
					}
				},
				DocMan.failure
			);
		};

		self.retrieveFiles = function() {
			var params = {Prefix : self.associatedObjectId + '/'};
			self.bucket.listObjects(params, function(err, data){
				if(err){
					console.log('could not load objects from S3');
					console.log(err);
				} else {
					console.log('loaded ' + data.Contents.length + ' items from S3');
					console.log(data);
				}
			});
		};

		self.downloadDocument = function(documentId) {
			DocMan.getDocument(
				self.associatedObjectId,
				documentId,
				function(data) {
					if (data.externalId !== undefined && data.externalId !== null && $.trim(data.externalId) !== '') {
						var params = {Key : data.externalId};
						self.bucket.getSignedUrl('getObject', params, function(err, url){
							if(err){
								console.log('could not get download url');
								console.log(err);
							} else {
								window.open(url);
							}
						});
					}
				},
				DocMan.failure
			);
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
	if(!DocMan.AmazonS3FileStore){
		DocMan.AmazonS3FileStore = AmazonS3FileStore;
	}
})();
