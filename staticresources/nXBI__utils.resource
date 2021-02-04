(function(){
	if(window.Utils == undefined){
		window.Utils = {
			TZ_OFFSET_MS: new Date().getTimezoneOffset() * 60000,
			convertGmtTimestampToLocalDate: function(timestamp){
				var td = new Date(timestamp);
				if (_.isUndefined(timestamp) || _.isNull(timestamp)){
					return null;
				}
				return new Date(td.getUTCFullYear(), td.getUTCMonth(), td.getUTCDate(), td.getUTCHours(), td.getUTCMinutes(), td.getUTCSeconds());
			},
			convertLocalDateToGmtTimestamp: function(localDate){
				return (_.isUndefined(localDate) || _.isNull(localDate))
						? null : localDate.getTime() - this.TZ_OFFSET_MS;
			},
			setupAjaxForBankr: function(){
				jQuery("#loading-modal").modal({
					backdrop: "static",
					keyboard: false,
					show: false
				});
			},
			blockUI: function(){
				jQuery("#loading-modal").modal("show");
			},
			unblockUI: function(){
				jQuery("#loading-modal").modal("hide");
			},
			resourceBundle: function(bundleUrl){
				var contents = '';

				try{
					jQuery.ajax(bundleUrl, { 
						async: false, 
						success: function(data){
							contents = data;
						}
					});
				}
				catch(error){}

				var aResourceMap = {};
				var lines = contents.split(/\r\n|\r|\n/);
				for(i=0;i<lines.length;i++){
					var aSplitVal = lines[i].split('=');
					var sKey = aSplitVal[0];
					var sVal = aSplitVal[1];
					aResourceMap[sKey]=sVal;
				}
				return aResourceMap;
			},
			extendBundles: function(existingBundle, newBundleUrl){
				return _.extend(existingBundle, Utils.resourceBundle(newBundleUrl));
			},
			setScaleString: function(intVal){
				if (isNaN(parseFloat(intVal)) || intVal == null || intVal == undefined){
					return "";
				}
				return parseFloat(intVal).toFixed(2).toString();
			}
		};
	}
	if(window.LifeCycle == undefined){
		window.LifeCycle = Utils;
	}
	if(window.LifeCycle.DataServices == undefined){
		window.LifeCycle.DataServices = {};
	}
}())