public with sharing class CreatePackageModel {
	public String name;
	public String status;
	public String language = 'en';
	public String emailMessage;
	public String type = 'PACKAGE';
	public List<Role> roles;
	public PackageCustomData data;
}