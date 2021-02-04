public with sharing class PackageDataInstaller extends nFORCE.APackageDataInstaller {
	public override Type getPackageDataInstallerType() {
		return PackageDataInstaller.class;
	}

	public override void start(InstallContext context) {
		authorizeDependencyInjectionFramework();
	}

	public override List<nFORCE.ALifeCycleDataProvider> getDataProviders() {
		return null;
	}

	public void authorizeDependencyInjectionFramework() {
		nFORCE.BeanRegistry.getInstance().registerBean(
			ClassTypeProvider.class.getName(),
			nFORCE.ClassTypeProvider.class,
			ClassTypeProvider.class,
			null,
			true
		);
	}
}