(function(registrationApp){
	var ViewModel = function(event, app){
		app.log('register viewModel event callback executing');
		app.ViewModel = function(data){
			var self = this;
			
			var defaultData = {
				section: ''
			};
			if(data != undefined){
				_.extend(defaultData, data);
			}
			app.mapFromJS(defaultData, app.getMapping(), self);
			
			self.hoverSectionToggle = function(data){
				self.section.isHovered(!self.section.isHovered());
				return true;
			};
			self.renderSectionToggle = function(data){
				self.section.isRendered(!self.section.isRendered());
				return true;
			};
			
			self.setLoanId = function(vm, loanId){
				vm.section.loanId(loanId);
				return vm;
			};
			
			
			app.log('Underwriting Global Analysis ViewModel instantiated.');
			return self;
		}
		app.log('Underwriting Global Analysis ViewModel initialized.');
	};
	if(LifeCycle.UnderwritingGlobal == undefined){
		LifeCycle.UnderwritingGlobal = {};
	}
	if(LifeCycle.UnderwritingGlobal.ViewModel == undefined){
		LifeCycle.UnderwritingGlobal.ViewModel = ViewModel;
	}
})(LifeCycle.RegistrationApp);