(function(){
	var ViewModel = function(event, app){
		app.ViewModel = function(data){
			var self = this;
			self.app = app;
			var defaultData = {
				availableMapSources: ko.observableArray(),
				selectedMapSources: ko.observableArray(),
				currentMapSources: ko.observableArray(),
				mapMarkers: ko.observableArray(),
				mapClusters: ko.observableArray(),
				getAllMapSourcesRemoteAction: null,
				loadMapSourcesRemoteAction: null,
				getMapSourceResultsRemoteAction: null,
				marker1Url: null,
				marker2Url: null,
				marker3Url: null,
				noMapSourceSelectedMessage: '',
				portfolioMap: null,
				defaultMapSourceTimeout: 300000,
				defaultMapSourcePollInterval: 1000,
				propertySeparator: ": ",
				endOfLineMarkup: "<br />",
				mapCanvasElement: "map-canvas",
				mapSourcePolling: 0,
				isLoading: false
			};
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);

			self.load = function(){
				self.getAllMapSources();
			}

			self.loadMap = function(){
				// Create the map component on load.
				self.portfolioMap = self.createMap();
				self.infoWindow = self.createInfoWindow();
			}

			self.getAllMapSources = function(){
				try{
					LifeCycle.blockUI();
					self.isLoading(true);

					self.remoteCall(
						self.getAllMapSourcesRemoteAction(),
						undefined,
						function(result, event){
							if (event.status) {
								var mappedResult = app.mapFromJS(result, app.getMapping(), mappedResult);
								_.each(mappedResult.mapSources(), function(mapSource){
									self.availableMapSources.push(mapSource);
								});
							} else {
								// TODO: Handle bad status
								LifeCycle.unblockUI();
								self.isLoading(false);
							}
						});
				}catch(e){
					// TODO: Handle exception thrown
					LifeCycle.unblockUI();
					self.isLoading(false);
				}
			}

			self.loadSelectedMapSources = function(){
				return self.loadMapSources(
					self.loadMapSourcesRemoteAction(),
					self.selectedMapSources());
			}

			self.reloadCurrentMapSources = function(){
				return self.loadMapSources(
					self.loadMapSourcesRemoteAction(),
					self.currentMapSources());
			}

			self.loadMapSources = function(remoteMethod, mapSources){
				try{
					LifeCycle.blockUI();
					self.isLoading(true);
					if(_.isEmpty(mapSources) || _.isUndefined(mapSources)){
						self.isLoading(false);
						LifeCycle.unblockUI();
						return;
					}

					self.remoteCall(
						remoteMethod,
						app.mapToJS(mapSources),
						function(result, event){
							if (event.status) {

								self.clearMapSources();

								var mappedResult = app.mapFromJS(result, app.getMapping(), mappedResult);
								_.each(mappedResult.mapSources(), function(mapSource){
									// Map the result and add it to the list of current map sources.
									self.currentMapSources.push(mapSource);

									// Initiate polling for the map source.
									self.mapSourcePolling = 0;
									setTimeout(function(){
											self.pollMapSource(mapSource)},
										self.defaultMapSourcePollInterval());
								});
							} else {
								// TODO: Handle bad status
								LifeCycle.unblockUI();
								self.isLoading(false);
							}
						});
				}catch(e){
					// TODO: Handle exception thrown
					LifeCycle.unblockUI();
					self.isLoading(false);
				}
			}

			self.pollMapSource = function(mapSource){
				var success = function(result, event){
					if (event.status) {
						var mappedResult = app.mapFromJS(result, app.getMapping(), mappedResult).mapSources()[0];

						mappedResult.locations().sort(function(a,b){
							return (a.name().toUpperCase() < b.name().toUpperCase() ? -1 : 1);
						});

						self.mapSourcePolling += self.defaultMapSourcePollInterval();

						self.currentMapSources.removeAll();
						self.currentMapSources.push(mappedResult);

						if (!mappedResult.isLoading() && mappedResult.currentReportInstanceId() != ''){

							// Create a marker for each of its locations.
							_.each(mappedResult.locations(), function(location){
								var marker = self.createMarker(location);
								self.mapMarkers.push(marker);
							});

							// Add the cluster logic for each of the markers.
							self.createClusters(self.mapMarkers());
						} else if (self.mapSourcePolling < self.defaultMapSourceTimeout()) {
							// Set a timeout for the polling of the map source.
							setTimeout(function(){
									self.pollMapSource(mappedResult)},
								self.defaultMapSourcePollInterval());
						} else {
							// Notify the user that the map source has timed out.
							alert('The selected map source \'' + mapSource.label() + '\' timed out.')
						}
					} else {
						// TODO: Handle bad status
						LifeCycle.unblockUI();
						self.isLoading(false);
					}
				};

				try{
					// Make the remote call.
					self.remoteCall(
						self.getMapSourceResultsRemoteAction(),
						app.mapToJS(mapSource),
						success);
				}catch(e){
					// TODO: Handle exception thrown
					LifeCycle.unblockUI();
					self.isLoading(false);
				}
			}

			self.reloadPage = function(){
				window.location.reload();
			}

			self.clearMapSources = function(){
				self.clearMap();
				self.currentMapSources.removeAll();
			}

			self.clearMap = function(){
				// Pop each of the markers off and set the map to null to remove it.
				while (self.mapMarkers().length){
					self.mapMarkers().pop().setMap(null);
				}
				// Pop each of the map clusters and clear the markers from it to remove it completely.
				while (self.mapClusters().length){
					self.mapClusters().pop().clearMarkers();
				}
			}

			self.createMap = function(){
				var mapOptions = {
					minZoom: 2,
					zoom: 4,
					mapTypeId: google.maps.MapTypeId.ROADMAP,
					mapTypeControl: false,
					center: new google.maps.LatLng(38.9833, -97.4167)
				};

				var mapCanvas = jQuery("#" + self.mapCanvasElement());
				return new google.maps.Map(mapCanvas[0], mapOptions);
			};

			self.createInfoWindow = function(){
				// Get the info window from the map component.
				var infoWindow = new google.maps.InfoWindow();
				return infoWindow;
			}

			self.createMarker = function(location){
				var marker = new google.maps.Marker({
					position: new google.maps.LatLng(location.address.latitude(), location.address.longitude()),
					map: self.portfolioMap,
					title: location.name()});

				// Add a listener to activate the tooltip (aka info window) on click.
				google.maps.event.addListener(marker, 'click', function () {
					// Create the HTML text to be displayed on the tooltip.
					var vcardFormat =
						'<div class="vcard">' +
						'<strong>' +
						'<a class="fn" href="' + location.url() + '" target="_blank">{0}</a>' +
						'</strong>' + self.endOfLineMarkup() +
						'<span class="adr">' +
						'<span class="street-address">{1}</span>' + self.endOfLineMarkup() +
						'<span class="locality">{2}</span>, ' +
						'<abbr class="region">{3}</abbr> ' +
						'<span class="postal-code">{4}</span>' + self.endOfLineMarkup() +
						'<span class="country-name">{5}</span>' +
						'</span>' +
						'</div>';
					var propertyCount = 0;
					var tooltip = String.format(vcardFormat,
						location.name(),
						location.address.street(),
						location.address.city(),
						location.address.state(),
						location.address.zipCode(),
						location.address.country()) +
						self.endOfLineMarkup();
					_.each(location.propertyMap, function(value, key) {
						if (propertyCount < 5){
							tooltip += key + self.propertySeparator() + value() + self.endOfLineMarkup();
							propertyCount++;
						}
					});

					if (location.actions().length > 0){
						var actionHtml =
							'<div class="btn-group btn-group-xs">';

						_.each(location.actions(), function(action){
							var actionFormat =
								'<button ' +
								'type="button" ' +
								'class="btn btn-default btn-primary" ' +
								'onclick="location.href=\'{0}\'" ' +
								'value="{1}">' +
								'{1}' +
								'</button>';
							actionHtml += String.format(actionFormat,
								action.generatedUrl(),
								action.label());
						});

						actionHtml +=
							'</div>';

						tooltip += actionHtml;
					}

					self.infoWindow.setContent(tooltip);
					self.infoWindow.open(self.portfolioMap, marker);
				});

				return marker;
			};

			self.createClusters = function(markers){
				var mcOptions = {
					styles: [{
						textColor:'#FFFFFF',
						fontWeight:400,
						height: 53,
						url: self.marker1Url(),
						width: 53
					},
						{
							textColor:'#FFFFFF',
							fontWeight:400,
							height: 56,
							url: self.marker2Url(),
							width: 56
						},
						{
							textColor:'#FFFFFF',
							fontWeight:400,
							height: 65,
							url: self.marker3Url(),
							width: 66,
						}]}

				var markerCluster = new MarkerClusterer(self.portfolioMap, markers, mcOptions);

				google.maps.event.addListener(markerCluster, "clusterclick", function (cluster) {
					var markers = cluster.getMarkers();
					var bounds = new google.maps.LatLngBounds();
					_.each(markers, function(marker){
						bounds.extend(marker.getPosition());
					});
					self.portfolioMap.setCenter(bounds.getCenter(), self.portfolioMap.fitBounds(bounds));
				});

				self.mapClusters().push(markerCluster);
			};

			self.remoteCall = function(remoteCall, data, success, failure, remotingOptions){
				var defaultRemotingOptions = {
					escape: false
				};
				if(!_.isUndefined(remotingOptions)){
					_.extend(defaultRemotingOptions, remotingOptions);
				}
				if (data != undefined){
					Visualforce.remoting.Manager.invokeAction(
						remoteCall,
						data,
						function(result, event){
							app.performingAjax(false);
							if (event.status) {
								success.apply(this, [result, event]);
							}
							else {
								if(jQuery.isFunction(failure)){
									failure.apply(this, [result, event]);
								}
							}
						},
						defaultRemotingOptions
					);
				} else {
					Visualforce.remoting.Manager.invokeAction(
						remoteCall,
						function(result, event){
							app.performingAjax(false);
							if (event.status) {
								success.apply(this, [result, event]);
							}
							else {
								if(jQuery.isFunction(failure)){
									failure.apply(this, [result, event]);
								}
							}
						},
						defaultRemotingOptions
					);
				}
			}

			app.log('ViewModel instantiated.');
			return self;
		}
		app.log('ViewModel initialized.');
	};
	if(LifeCycle.Portfolio_Map.ViewModel == undefined){
		LifeCycle.Portfolio_Map.ViewModel = ViewModel;
	}
})();