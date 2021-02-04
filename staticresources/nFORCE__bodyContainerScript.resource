var appIndex = window.location.search.indexOf('app=') + 4;
var newApp = window.location.search.substring(
	appIndex,
	window.location.search.indexOf('&', appIndex)
);
Messenger.publish(LifeCycle.Topics.REFRESH_SECONDARY_NAVIGATION, newApp);
Messenger.publish(LifeCycle.Topics.REFRESH_TERTIARY_NAVIGATION, newApp);

var div = document.getElementsByClassName('body-content')[0];
var config = { attributes: true, childList: true, subtree: true };
var observer = new MutationObserver(function () {
	var body = document.body,
		html = document.documentElement;

	var height = Math.max(body.scrollHeight, body.offsetHeight,
		html.clientHeight, html.scrollHeight, html.offsetHeight);

	Messenger.publish('Content:Resize', height);
});
observer.observe(div, config);