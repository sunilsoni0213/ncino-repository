@isTest
public with sharing class PackageDataInstallerTest {
	@isTest
	private static void shouldReturnPackageDataInstaller_onStart() {
		Test.startTest();
		PackageDataInstaller packageInstaller = new PackageDataInstaller();
		packageInstaller.start(null);
		packageInstaller.finish();
		Test.stopTest();

		System.assertEquals(PackageDataInstaller.class, packageInstaller.getPackageDataInstallerType());
	}

	@isTest
	private static void ShouldReturnClassTypeProviderFromBean() {
		PackageDataInstaller packageInstaller = new PackageDataInstaller();
		Test.startTest();
		packageInstaller.authorizeDependencyInjectionFramework();
		Test.stopTest();

		System.assert(nFORCE.BeanFactory.getInstance().getBeanByUniqueName(
			ClassTypeProvider.class.getName()) instanceof nFORCE.ClassTypeProvider);
	}
}