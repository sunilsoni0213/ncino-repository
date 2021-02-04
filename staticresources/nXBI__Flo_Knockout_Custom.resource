(function() {
	ko.bindingHandlers.safeText = {
		update: function(element, valueAccessor, allBindingsAccessor) {
			var options = ko.utils.unwrapObservable(valueAccessor());
			var value = ko.utils.unwrapObservable(options.value);
			var property = ko.utils.unwrapObservable(options.property);
			var fallback = ko.utils.unwrapObservable(options.default) || "";

			var text = value ? (options.property ? value[property] : value) : fallback;

			ko.bindingHandlers.text.update(element, function() { return text; });
		}
	};

	ko.bindingHandlers.safeDateText = {
		update: function(element, valueAccessor, allBindingsAccessor){
			var dateOptions = allBindingsAccessor().dateOptions || {};
			dateOptions = _.extend({
				'default': null,
				'separator': '/',
				'property': null
			}, dateOptions);

			var value = ko.utils.unwrapObservable(valueAccessor());
			var property = ko.utils.unwrapObservable(dateOptions.property);
			var fallback = ko.utils.unwrapObservable(dateOptions.default) || "";
			var text = null;

			if (!_.isEmpty(property) && !_.isEmpty(value)) {
				text = (value[property] && typeof value[property] === 'function') ? LifeCycle.getFormattedDate(value[property](), dateOptions['default']) : fallback;
			} 
			else {
				text = value ? LifeCycle.getFormattedDate(value, dateOptions['default']) : fallback;
			}

			ko.bindingHandlers.text.update(element, function() { return text; });
		}
	};
})();
