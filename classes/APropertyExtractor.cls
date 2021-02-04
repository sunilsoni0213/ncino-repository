public virtual with sharing class APropertyExtractor {
	@TestVisible
	protected String buildExceptionMessage(String baseMessage, List<String> details) {
		String message = baseMessage;
		for (String detail : details) {
			detail = detail.toUpperCase().replaceAll('_', ' ');
			message = message + DELIMITER + detail;
		}
		return message;
	}

	protected void validateProperty(String propertyValue, List<String> details) {
		if (String.isEmpty(propertyValue)) {
			throw new XException(buildExceptionMessage(X_MISSING_REQUIRED_DATA, details));
		}
	}

	protected void validateProperty(Map<String, Object> propertyValue, List<String> details) {
		if (propertyValue == null) {
			throw new XException(buildExceptionMessage(X_MISSING_REQUIRED_DATA, details));
		}
	}

	protected void validateProperty(List<Map<String, Object>> propertyValue, List<String> details) {
		if (propertyValue == null || propertyValue.size() == 0) {
			throw new XException(buildExceptionMessage(X_MISSING_REQUIRED_DATA, details));
		}
	}

	protected void validateProperty(Object propertyValue, List<String> details) {
		if (propertyValue == null) {
			throw new XException(buildExceptionMessage(X_MISSING_REQUIRED_DATA, details));
		}
	}

	protected void validateProperty(List<Object> propertyValue, List<String> details) {
		if (propertyValue == null || propertyValue.size() == 0) {
			throw new XException(buildExceptionMessage(X_MISSING_REQUIRED_DATA, details));
		}
	}

	protected String getMapValueAsString(Object value) {
		if (value == null) {
			return '';
		}
		return String.valueOf(value);
	}

	protected String getMapValueAsString(Map<String, Object> obj) {
		if (obj == null || obj.get(KEY_VALUE) == null) {
			return '';
		}
		return String.valueOf(obj.get(KEY_VALUE));
	}

	protected List<Object> getMapValueAsObjectList(Object value) {
		if (value == null) {
			return new List<Object>();
		}
		return (List<Object>) value;
	}

	protected Map<String, Object> getMapValueAsMapObject(Object value) {
		if (value == null) {
			return new Map<String, Object>();
		}
		return (Map<String, Object>) value;
	}

	private class XException extends Exception {}

	@TestVisible
	private static final String
		DELIMITER = ': ',
		KEY_VALUE = 'value',
		X_MISSING_REQUIRED_DATA = 'Missing Required Data';
}