public with sharing class DocumentEncodeUtility {
	public static List<String> encodeDocument(Blob file, String boundary, String fileName, String mimeType) {
		String bodyEncoded = '';
		String last4Bytes = '';
		String footerEncoded = '';
		String headerPlusBodyEncoded = '';
		String headerEncoded = '';

		String contentDisposition = '\nContent-Disposition: form-data; name="file"; filename="' + fileName + '"';
		String contentType = '\nContent-Type: ' + mimeType;
		String header = '--' + boundary + contentDisposition + contentType;
		String footer = '--' + boundary + '--';

		headerEncoded = encodeString(header);
		bodyEncoded = EncodingUtil.base64Encode(file);

		last4Bytes = bodyEncoded.substring(bodyEncoded.length() - 4, bodyEncoded.length());
		if (last4Bytes.endsWith('==')) {
			last4Bytes = last4Bytes.substring(0, 2) + '0K';
			bodyEncoded = bodyEncoded.substring(0, bodyEncoded.length() - 4) + last4Bytes;
		} else if (last4Bytes.endsWith('=')) {
			last4Bytes = last4Bytes.substring(0, 3) + 'N';
			bodyEncoded = bodyEncoded.substring(0, bodyEncoded.length() - 4) + last4Bytes;
			footer = '\n' + footer;
		} else {
			footer = '\r\n' + footer;
		}
		footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
		headerPlusBodyEncoded = headerEncoded + bodyEncoded ;

		return new List<String>{headerPlusBodyEncoded, footerEncoded};
	}

	public static String encodeString(String stringToEncode) {
		String encodedString = EncodingUtil.base64Encode(Blob.valueOf(stringToEncode + LINE_BREAKS + LINE_BREAKS));
		while (encodedString.endsWith('=')) {
			stringToEncode += ' ';
			encodedString = EncodingUtil.base64Encode(Blob.valueOf(stringToEncode + LINE_BREAKS + LINE_BREAKS));
		}
		return encodedString;
	}

	public static String encodeContent(String content) {
		String contentEncoded = EncodingUtil.base64Encode(Blob.valueOf(content + LINE_BREAKS));
		String last4BytesForContent = contentEncoded.substring(contentEncoded.length() - 4, contentEncoded.length());
		if (contentEncoded.endsWith('==')) {
			last4BytesForContent = last4BytesForContent.substring(0, 2) + '0K';
			contentEncoded = contentEncoded.substring(0, contentEncoded.length() - 4) + last4BytesForContent;
		} else if (last4BytesForContent.endsWith('=')) {
			last4BytesForContent = last4BytesForContent.substring(0, 3) + 'N';
			contentEncoded = contentEncoded.substring(0, contentEncoded.length() - 4) + last4BytesForContent;
		}

		return contentEncoded;
	}

	public static final String LINE_BREAKS = '\r\n';
}