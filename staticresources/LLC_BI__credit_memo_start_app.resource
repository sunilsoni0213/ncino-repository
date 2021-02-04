(function(registrationApp){
	var App = function(){
		var self = this;
		self.register = function(appName, appData){
			registrationApp.registerExtension(function(event, registrationApp){
				registrationApp.registerAppName(appName);
				(function(app){
					app.preRun = function(data){
						return (appData != undefined ? appData : data);
					};
					app.postRun = function(vm){
						setTimeout(function(){
							vm.load();
							jQuery('body, head').on('mouseenter', '.iconTooltip', function(){
								var elIcon = jQuery(this);
								var el = elIcon.siblings('.contentTooltip');
								el
									.css({top: '-10000px', left:'0px', position: 'fixed', visibility: 'visible'})
									.show(0, function(){
										setTimeout(function(){
											var tooltipH = parseInt(el.height(), 10);
											var tooltipW = parseInt(el.width(), 10);
											var tooltipPLeft = parseInt(elIcon.position().left, 10);
											var tooltipOLeft = parseInt(elIcon.offset().left, 10);
											var iconH = parseInt(elIcon.height(), 10);
											var iconW = parseInt(elIcon.width(), 10);
											var iconPTop = parseInt(elIcon.position().top, 10);
											var iconOTop = parseInt(elIcon.offset().top, 10);
											var topPos = iconOTop + iconPTop  - ((tooltipH - iconH) / 2) - 4;
											var leftPos = tooltipPLeft + tooltipOLeft - tooltipW - iconW - 4;
											el.css({
												top: topPos + 'px',
												left: leftPos + 'px',
												visibility: 'visible'
											});
										}, 100);
									});
							});
							jQuery('body, head').on('mouseleave', '.iconTooltip', function(){
								jQuery(this).siblings('.contentTooltip').hide();
							});
						}, 1000);
						return true;
					};
				})(registrationApp.registeredApps[appName]);
				registrationApp.log('CreditMemo.Start ' + appName + ' App initialized.');
			});
			registrationApp.registerModels(appName, LifeCycle.CreditMemo.Models);
			registrationApp.registerModels(appName, LifeCycle.Screen.Models);
			registrationApp.registerViewModel(appName, LifeCycle.CreditMemo.Start.ViewModel);
		};
		return self;
	};
	if(LifeCycle.CreditMemo == undefined){
		LifeCycle.CreditMemo = {};
	}
	if(LifeCycle.CreditMemo.Start == undefined){
		LifeCycle.CreditMemo.Start = {};
	}
	if(LifeCycle.CreditMemo.Start.App == undefined){
		LifeCycle.CreditMemo.Start.App = App;
	}
})(LifeCycle.RegistrationApp);