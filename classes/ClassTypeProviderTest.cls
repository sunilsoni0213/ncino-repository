@isTest
public with sharing class ClassTypeProviderTest {
	@IsTest
	public static void shouldResolveClassType() {
		ClassTypeProvider provider = new ClassTypeProvider();

		Type classType = ClassTypeProviderTest.class;
		String className = classType.getName();
		Account account1 = new Account(Name = 'TestClassTypeProvider1');

		System.assertEquals(classType, provider.forName(className));
		System.assertEquals(classType, provider.forName('', className));
		System.assertEquals(classType, provider.forName(nFORCE.Utility.getNamespacePrefix(className, ''), 'ClassTypeProviderTest'));
		System.assertEquals(account1, provider.deserialize(provider.serialize(account1), Account.class));
		System.assert(provider.newInstance(classType) instanceof ClassTypeProviderTest);
	}
}