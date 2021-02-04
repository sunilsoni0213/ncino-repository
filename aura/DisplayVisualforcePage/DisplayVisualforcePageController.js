({
	doInit : function(component, event, helper) {
        var domain = window.location.href.split('.')[0].substring(8);
        var namespace = component.get("v.namespace");
		if (namespace === undefined) namespace = 'c';
		var pageName = component.get("v.pageName");
        var url = "https://" + domain + "--" + namespace + ".visualforce.com/apex/" + pageName
		component.set("v.pageURL", url);
	}
})