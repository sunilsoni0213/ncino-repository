@IsTest
public with sharing class AResponseNormalizerTest {

	@IsTest
	private static void buildProcessedMap_wrapperMapPreservesValues() {
		Map<String, Object> bag1 = new Map<String, Object>{'🥑' => '😀', '🥕' => '😡'};
		Map<String, Object> bag2 = new Map<String, Object>{'🥖' => '😍'};

		Test.startTest();
		Map<String, Object> outputMap = new ResponseNormalizerMock().buildProcessedMap(bag1, bag2);
		Test.stopTest();

		Map<String, Object> rawResponseMap = (Map<String, Object>) outputMap.get(AResponseNormalizer.KEY_RAW_RESPONSE);
		Map<String, Object> normalizedMap = (Map<String, Object>) outputMap.get(AResponseNormalizer.KEY_RESPONSE);

		System.assertNotEquals(null, rawResponseMap);
		System.assertNotEquals(null, normalizedMap);
		System.assertEquals((String) rawResponseMap.get('🥑'), '😀');
		System.assertEquals((String) rawResponseMap.get('🥕'), '😡');
		System.assertEquals((String) normalizedMap.get('🥖'), '😍');
	}

	@IsTest
	private static void deserialize_shouldAcceptWellFormedJSON() {
		String validJson = JSON.serialize(new Map<String, Object>{'🥑' => '😀', '🥕' => '😡'});

		Test.startTest();
		Map<String, Object> outputMap = new ResponseNormalizerMock().deserialize(validJson);
		Test.stopTest();

		System.assertNotEquals(null, outputMap);
		System.assertEquals('😀', (String) outputMap.get('🥑'));
		System.assertEquals('😡', (String) outputMap.get('🥕'));
	}

	@IsTest
	private static void deserialize_malformedJSON_throwsExceptionWithDetails() {
		String badJson = '{\"myKey\":\"myValue\"';

		Map<String, Object> outputMap;
		String exceptionString;
		Test.startTest();
		try {
			outputMap = new ResponseNormalizerMock().deserialize(badJson);
			System.assert(false, 'Malformed JSON should not be transformed');
		} catch (Exception ex) {
			exceptionString = ex.getMessage();
		}
		Test.stopTest();

		System.assertEquals(null, outputMap);
		System.assertNotEquals(null, exceptionString);
		System.assertEquals(true, exceptionString.contains('Unable to interpret received response. Received:'));
	}

	private class ResponseNormalizerMock extends AResponseNormalizer {
		public override String process(nFUSE.AMiddlewareMessage message) {
			return null;
		}
	}
}