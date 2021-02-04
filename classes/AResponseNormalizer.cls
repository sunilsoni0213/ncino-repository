public abstract class AResponseNormalizer {
	public abstract String process(nFUSE.AMiddlewareMessage message);

	@TestVisible
	protected virtual Map<String, Object> buildProcessedMap(
		Map<String, Object> rawResponseMap,
		Map<String, Object> normalizedMap
	) {
		return new Map<String, Object>{
			KEY_RAW_RESPONSE => rawResponseMap,
			KEY_RESPONSE => normalizedMap
		};
	}

	@TestVisible
	protected virtual Map<String, Object> deserialize(String rawResponse) {
		try {
			return (Map<String, Object>) JSON.deserializeUntyped(rawResponse);
		} catch (Exception ex) {
			throw new XResponseException(
				String.format(
					X_UNABLE_TO_INTERPRET_RESPONSE,
					new List<String>{rawResponse, ex.getMessage()}
				)
			);
		}
	}

	public class XResponseException extends Exception {}

	@TestVisible
	private static final String
		KEY_RESPONSE = 'response',
		KEY_RAW_RESPONSE = 'raw_response',
		X_UNABLE_TO_INTERPRET_RESPONSE = 'Unable to interpret received response. Received: {0} | Exception: {1}';
}