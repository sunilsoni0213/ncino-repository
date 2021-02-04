var StagingAreaResource = function(){
	var self = this;
};

StagingAreaResource.processSingleFileDrop = function (currentFile, allowedExtensions, stagingAreaComponent) {
	var fileName = currentFile.name + '';
	var fileNameWithoutExtension = fileName.replace(/\.[^\.]+$/, '');
	var fileExtension = fileName.substr(fileName.lastIndexOf('.') + 1).toLowerCase();
	if (!StagingArea.isDuplicateFile(fileName)) {
		if (allowedExtensions != null &&
			allowedExtensions.length > 0 &&
			allowedExtensions.indexOf(fileExtension) < 0) {

			var extensionsString = '';
			allowedExtensions.forEach(function(index){
				if(extensionsString !== ''){
					extensionsString += ', ' + index;
				} else {
					extensionsString += index;
				}
			});
			alert('Only these file types are allowed: ' + extensionsString);
			return;
		}
		else if(currentFile.size <= FileUpload.MAX_FILE_SIZE) {
			StagingArea.createNewDocumentFn(fileName, function(documentData) {
				documentData = ($.isArray(documentData) && documentData.length > 0) ?  documentData[0] : {};
				var documentId = $.trim(documentData.id);
				var docType = documentData.docType;
				if (documentId !== '') {
					createNonStagedItem(fileName, documentId);
					FileUpload.uploadSelectedFile(currentFile, fileNameWithoutExtension, docType, documentId, $.noop);
				}
			});
		} else {
			alert(fileName + ' exceeds the maximum file size (' + FileUpload.MAX_FILE_SIZE_DISPLAY + ') and cannot be uploaded');
		}
	} else {
		stagingAreaComponent.getStagedFileByName(fileName).effect('highlight', { color: '#D3F3D9' }, 3000);
	}
};