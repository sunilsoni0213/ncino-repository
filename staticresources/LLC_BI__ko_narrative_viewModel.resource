(function(){
	var ViewModel = function(event, app){
		app.ViewModel = function(data){
			var self = this;
			self.app = app;
			var defaultData = {
				recordId: '',
				screenSection: '',
				renderedView: '',
				isEditing: false,
				isCollapsed: false
			};
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);

			self.load = function(callback){
				self.retrieve(self.screenSection, function(arguments){
				
					self.retrieve(self.screenSection.widget, function(arguments){
					
						callback.apply();
						_retrieveRenderedView();

					}, undefined);

				}, undefined);
			};

			self.retrieve = function(data, success, remotingOptions) {
				LifeCycle.BorrowerTree.retrieveIForce(
					data,
					data.recordId(),
					function(result, event) {
						app.mapFromJS(result, app.getMapping(), data);
						if (_.isFunction(success)) {
							success.apply(this, [arguments]);
						}
					},
					app.log.failure,
					remotingOptions,
					false
				);
			};

			self.isEditing.subscribe(function(newVal){
				if(!newVal) {
					_retrieveRenderedView();
					_.each(CKEDITOR.instances, function(instance) {
						if (instance.element.getId() == self.screenSection.recordId() 
							&& instance.checkDirty()) {
							var cont = confirm(msgs.msg_ck_save_prompt);
							if (!cont) {
								self.isEditing(true);
							} 
						}
					});
				}
			});

			function _retrieveRenderedView() {
				LifeCycle.Force.retrieveAttachment(
					self.screenSection.recordId(),
					msgs.msg_rendered_view_filename,
					function(data){
						if(data != null){
							var textData = jQuery('<textarea />').html(data.body).text();
							self.renderedView(textData);

							var markup = jQuery('<div>').html(textData);
							jQuery('.ko-narrative-loadable', markup).each(function () {
								var loadable = jQuery(this);

								var recordId = jQuery(loadable).attr('data-record');
								var namespace = jQuery(loadable).attr('data-ns');
								var paramsJSON = jQuery(loadable).attr('data-params');

								if (namespace && paramsJSON) {
									var params = {};
									try {
										params = JSON.parse(paramsJSON);
									} catch (e) {
										console.warn("Unable to deserialize in-narrative app params");
									} finally {
										app.publish(namespace + '.Init', params);
									}
								} else {
									console.warn("Encountered in-narrative app w/o required items");
								}
							});

						}
					},
					function(){}
				);
			}
			
			return self;
		};
	};
	if(LifeCycle.KO_Narrative == undefined){
		LifeCycle.KO_Narrative = {};
	}
	if(LifeCycle.KO_Narrative.ViewModel == undefined){
		LifeCycle.KO_Narrative.ViewModel = ViewModel;
	}
})();