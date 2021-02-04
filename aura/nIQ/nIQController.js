({
    init:function(component, event, helper) {
        var str = 'https://' + window.location.hostname + '/apex/niqBotDemo';
        component.set("v.url", str);
    },
})