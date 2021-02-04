/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class BeanRegistry {
    global void deregisterBean(String uniqueName) {

    }
    global void deregisterBean(nFORCE.BeanDefinition bd) {

    }
    global virtual void deregisterBean(String uniqueName, Boolean isDelete) {

    }
    global virtual void deregisterBean(nFORCE.BeanDefinition bd, Boolean isDelete) {

    }
    global virtual String generateUniqueBeanName(System.Type superType, String beanFunction) {
        return null;
    }
    global static nFORCE.BeanRegistry getInstance() {
        return null;
    }
    global Boolean isRegistered(String uniqueName) {
        return null;
    }
    global Boolean isRegistered(String uniqueName, Boolean isActive) {
        return null;
    }
    global Boolean isRegistered(nFORCE.BeanDefinition bd, Boolean isActive) {
        return null;
    }
    global void reactivateBean(String uniqueName) {

    }
    global void registerBean(nFORCE.BeanDefinition bd) {

    }
    global void registerBean(String uniqueName, System.Type classType) {

    }
    global void registerBean(nFORCE.BeanDefinition bd, nFORCE.ILifeCycleDataProvider dataProvider) {

    }
    global void registerBean(String uniqueName, System.Type contractType, System.Type classType) {

    }
    global void registerBean(String uniqueName, System.Type classType, nFORCE.ILifeCycleDataProvider dataProvider) {

    }
    global void registerBean(String uniqueName, System.Type contractType, System.Type classType, Boolean forceReregistration) {

    }
    global void registerBean(String uniqueName, System.Type contractType, System.Type classType, nFORCE.ILifeCycleDataProvider dataProvider) {

    }
    global virtual void registerBean(String uniqueName, System.Type contractType, System.Type classType, Boolean forceReregistration, nFORCE.ILifeCycleDataProvider dataProvider) {

    }
    global virtual void registerBean(String uniqueName, System.Type classType, Map<String,Object> params) {

    }
    global virtual void registerBean(String uniqueName, System.Type classType, Map<String,Object> params, nFORCE.ILifeCycleDataProvider dataProvider) {

    }
    global virtual void registerBean(String uniqueName, System.Type contractType, System.Type classType, Map<String,Object> params) {

    }
    global virtual void registerBean(String uniqueName, System.Type contractType, System.Type classType, Map<String,Object> params, Boolean forceReregistration) {

    }
    global void registerBean(String uniqueName, System.Type contractType, System.Type classType, Map<String,Object> params, Boolean forceReregistration, nFORCE.ILifeCycleDataProvider dataProvider) {

    }
    global virtual void registerBean(String uniqueName, System.Type contractType, System.Type classType, Map<String,Object> params, nFORCE.ILifeCycleDataProvider dataProvider) {

    }
global class XClassTypeIsNullException extends Exception {
}
global class XNameAlreadyRegisteredException extends Exception {
}
}
