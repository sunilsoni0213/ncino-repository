(function() {
	ko.bindingHandlers.configureMetadata = {
		init: function(element, valueAccessor, allBindings, viewModel, bindingContext) {
			ko.bindingHandlers.visible.update(element, ko.observable(false));
			ko.bindingHandlers.attr.update(element, ko.observable({ href: '' }));
		},
		update: function(element, valueAccessor, allBindings, viewModel, bindingContext) {
			var destination = ko.unwrap(valueAccessor().destination);
			var parameters = ko.unwrap(valueAccessor().parameters);
			var prefix = ko.unwrap(valueAccessor().prefix);
			var lookupReference = prefix + '.Identifier';
			for (i = 0; i < parameters.length; i++) {
				parameters[i] = ko.unwrap(parameters[i]);
				lookupReference += '.' + parameters[i];
			}
			var localIdentifier = !sessionStorage ? null : sessionStorage.getItem(lookupReference);
			if (localIdentifier != null) {
				ko.bindingHandlers.configureMetadata.apply(element, destination, localIdentifier);
				return;
			}

			parameters.unshift(ko.unwrap(valueAccessor().endpoint));

			parameters.push(function(result, event) {
				if (event.status && result != null) {
					if (sessionStorage) {
						sessionStorage.setItem(lookupReference, result);
					}
					ko.bindingHandlers.configureMetadata.apply(element, destination, result);
				}
			});

			Visualforce.remoting.Manager.invokeAction.apply(Visualforce.remoting.Manager, parameters);
		},
		apply: function(element, destination, result) {
			ko.bindingHandlers.attr.update(element, ko.observable({
				href: destination.replace('{identifier}', result)
			}));
			ko.bindingHandlers.visible.update(element, ko.observable(true));
		}
	};
}())