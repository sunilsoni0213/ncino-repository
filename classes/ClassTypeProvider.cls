global virtual with sharing class ClassTypeProvider extends nFORCE.ClassTypeProvider {
	public override Type forName(String className) {
		return Type.forName(className);
	}

	public override Type forName(String packageName, String className) {
		return Type.forName(packageName, className);
	}

	public override String serialize(Object o) {
		return JSON.serialize(o);
	}

	public override Object deserialize(String jsonString, Type apexType) {
		return JSON.deserialize(jsonString, apexType);
	}

	public override Object newInstance(Type apexType) {
		return apexType.newInstance();
	}

	public virtual override Object createStub(Type parentType, StubProvider stubProvider) {
		Type targetType = this.getStubSubType(parentType);
		return Test.createStub(targetType, stubProvider);
	}

	private Type getStubSubType(Type sourceType) {
		if (packageStubSubs == null) {
			packageStubSubs = new Map<Type, Type>{};
		}
		Type targetType = packageStubSubs.get(sourceType);
		return targetType != null ? targetType : sourceType;
	}

	private static Map<Type, Type> packageStubSubs;
}