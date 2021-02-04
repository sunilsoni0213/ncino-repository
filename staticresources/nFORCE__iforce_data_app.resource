(function(){
	/*
	 * LifeCycle IForce Data Global Cache/App
	 *
	 * *******************************************************************************
	 * *                                                                             *
	 * *  TIP: Press Command+K,3 (or Command+K,Command+3) to make navigating easier  *
	 * *                                                                             *
	 * *******************************************************************************
	 */

	if (!LifeCycle.IForceData) {
		/**
		 * @class LifeCycle
		 */
		
		/**
		 * IForce Data utilities and classes namespace
		 * @class
		 * @type {{}}
		 */
		LifeCycle.IForceData = {};
	}

	if (!LifeCycle.IForceData.globalCache) {
		/**
		 * @type {LifeCycleApp}
		 */
		LifeCycle.IForceData._globalMappingApp = new LifeCycle.App();
		// Add catch-all hook into model registration process
		LifeCycle.IForceData.IForceUtils._registerModelCatchall(LifeCycle.IForceData._globalMappingApp);
		
		/**
		 * @type {LifeCycle.IForceData.IForceCache}
		 */
		LifeCycle.IForceData.globalCache = new LifeCycle.IForceData.IForceCache();


		// ==============================================================
		// Global message subscriptions
		// When available, it's cheaper to just use LifeCycle.IForceDataApp.(whatever)
		// ==============================================================
		LifeCycle.IForceData.enableSubscribes = true;

		var msgApp = LifeCycle.IForceData.globalCache._app;

		msgApp.subscribe('nFORCE.IForce_Data.Load_IForce', function (options) {
			if (LifeCycle.IForceData.enableSubscribes) {
				LifeCycle.IForceCache.loadIForceById(options.recordId, options, function (iForce) {
					sendLoadMessages([iForce], true);
				});
			}
		});
		msgApp.subscribe('nFORCE.IForce_Data.Load_IForces', function (options) {
			if (LifeCycle.IForceData.enableSubscribes) {
				LifeCycle.IForceCache.loadIForcesById(options.recordIds, options, function (iForces) {
					sendLoadMessages(iForces, true);
				});
			}
		});
		msgApp.subscribe('nFORCE.IForce_Data.Get_Cached_IForce', function (options) {
			if (LifeCycle.IForceData.enableSubscribes) {
				LifeCycle.IForceCache.getIForceById(options.recordId, options, function (iForce) {
					sendLoadMessages([iForce], false);
				});
			}
		});
		msgApp.subscribe('nFORCE.IForce_Data.Get_Cached_IForces', function (options) {
			if (LifeCycle.IForceData.enableSubscribes) {
				LifeCycle.IForceCache.getIForcesById(options.recordIds, options, function (iForces) {
					sendLoadMessages(iForces, false);
				});
			}
		});

		msgApp.publish('nFORCE.IForce_Data.Started');
	}

	// Global Cache Shortcut
	/** @type {LifeCycle.IForceData.IForceCache} */
	LifeCycle.IForceCache = LifeCycle.IForceData.globalCache;
	
	function sendLoadMessages (cachedIForces, fresh) {
		msgApp.publish('nFORCE.IForce_Data.Cached_IForces', cachedIForces);
		if (fresh) {
			msgApp.publish('nFORCE.IForce_Data.Loaded_IForces', cachedIForces);
		}

		_.each(cachedIForces, function (iForce) {
			if (LifeCycle.IForceCache._utils.isPlaceholder(iForce)) {
				return;
			}

			msgApp.publish('nFORCE.IForce_Data.Cached_IForce', iForce);

			if (fresh) {
				msgApp.publish('nFORCE.IForce_Data.Loaded_IForce', iForce);
			}
		});
	}
})();
