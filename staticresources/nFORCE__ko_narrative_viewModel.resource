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
				var remotingOptions = {buffer:false, escape: false};
				self.retrieve(self.screenSection, function(arguments){
				
					self.retrieve(self.screenSection.widget, function(arguments){
						
						_retrieveRenderedView(callback);
						
					}, remotingOptions);

				}, remotingOptions);
			};

			self.retrieve = function(data, success, remotingOptions) {
				LifeCycle.Service.retrieveIForce(
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
					_retrieveRenderedView(function(){
						_.each(CKEDITOR.instances, function(instance) {
							if (instance.element.getId() == self.screenSection.recordId() 
								&& instance.checkDirty()) {
								var cont = confirm(LifeCycle.msgs.msg_ck_save_prompt);
								if (!cont) {
									self.isEditing(true);
								} 
							}
						});
					});
				} else {
					_.each(CKEDITOR.instances, function(instance) {
						setTimeout(function () {
							CKEDITOR.config.height = 601;
							instance.height=601;

							var containerElement = instance.container.$;

							var contentElement = containerElement.querySelector('.cke_contents');
							var frameElement = containerElement.querySelector('.cke_contents > iframe');

							instance.focus();
							frameElement.style.width = '100%';

							contentElement.style.height = '601px';
							setTimeout(function () {
								contentElement.style.height = '600px';
								instance.focus();
							}, 50);
							instance.resize('100%', '601');
							instance.focus();
						}, 50);
					});
				}
			});

			function _retrieveRenderedView(callback) {
				LifeCycle.Service.retrieveAttachment(
					self.screenSection.recordId(),
					LifeCycle.msgs.msg_rendered_view_filename,
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
						callback.apply()
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
