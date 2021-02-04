/**
 * Unmanaged Apex controller developed for Sales to support custom "skip" functionality
 * @author Dan Wuensch
 */
global class OnlineIDVerificationController {
	@RemoteAction
    global static String retrieveUI(String appName, Id applicationId) {
        return nPORTAL.OnlineFormController.retrieveUI(appName, applicationId);
    }
    
    @RemoteAction
    global static String skipForm(String routeData, String applicationId) {
        return nPORTAL.OnlineFormController.skipForm(routeData, applicationId);
    }
}