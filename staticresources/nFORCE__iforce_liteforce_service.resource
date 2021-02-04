(function () {
	/**
	 * SalesForce CRUD service that can work in place of or along side the LifeCycle framework.
	 * Performs all mapTo/FromDb logic client-side instead of server-side.
	 * &nbsp;
	 *
	 * Utilizes LiteForces (sObjectContainers) as an intermediate format between sObjects and client-side IForces.
	 * See {@link ISObjectContainer}
	 * &nbsp;
	 *
	 * In most cases, this service can be used in place of LifeCycle.Service / LifeCycle.BorrowerTree without
	 * any additional modification.
	 * In some cases adding custom mapTo/From logic is required. For this,
	 * See {@link LifeCycle.IForceData.LiteForceUtils.sObjectTypeMapping sObject Type Mapping}
	 * and {@link LifeCycle.IForceData.LiteForceUtils.sObjectFieldTranslations sObject Field Translations} for details
	 * on how to add custom mapping logic.
	 * &nbsp;
	 *
	 * There is also an Angular service available in the spreads-force repo that leverages Promises
	 * and provides a few additional utilities.
	 * &nbsp;
	 *
	 * @class LiteForceService
	 * @constructor
	 * @memberOf LifeCycle
	 */
	var LiteForceService = function () {};
	
	/**
	 * Use to jimmy a temporary dev namespace into pre-sfdx packages. Do not include double underscore suffix
	 *
	 * Syntax: { "Dev_Namespace": "Packaged_Namespace" }
	 *
	 * Use '' as the dev namespace if there is no namespace in the org.
	 *
	 * Can commit here if permanent.
	 * But you'd usually just want to add at runtime via LifeCycle.LiteForceService.REMAP_NAMESPACES
	 * if just a temporary dev org namespace.
	 *
	 * @type {[*]}
	 */
	LiteForceService.REMAP_NAMESPACES = {
	};
	
	/**
	 * Allows jimmying in a dev namespace for pre-sfdx packages when loading from server
	 * @param sObjectContainer
	 * @param utils
	 */
	LiteForceService.remapNamespacesFromDb = function (sObjectContainer, utils) {
		for (var dev in LiteForceService.REMAP_NAMESPACES) {
			if (!LiteForceService.REMAP_NAMESPACES.hasOwnProperty(dev)) {
				continue;
			}
			
			if (dev.length) { dev = dev + '__'; }
			
			var packaged = LiteForceService.REMAP_NAMESPACES[dev] + '__';
			
			if (utils.getNamespace(sObjectContainer.type) === dev && sObjectContainer.type.indexOf('__c') != -1) {
				sObjectContainer.type = packaged + utils.stripNamespace(sObjectContainer.type);
			}
			
			for (var prop in sObjectContainer.obj) {
				if (sObjectContainer.obj.hasOwnProperty(prop)) {
					if (utils.getNamespace(prop) == dev && (prop.indexOf('__c') != -1 || prop.indexOf('__r') != -1)) {
						var newProp = packaged + utils.stripNamespace(prop);
						sObjectContainer.obj[newProp] = sObjectContainer.obj[prop];
						delete sObjectContainer.obj[prop];
					}
				}
			}
			
			for (var relProp in sObjectContainer.relationshipProperties) {
				if (sObjectContainer.relationshipProperties.hasOwnProperty(relProp)) {
					if (utils.getNamespace(relProp) == dev && (relProp.indexOf('__c') != -1 || relProp.indexOf('__r') != -1)) {
						var info = sObjectContainer.relationshipProperties[relProp];
						var newRelProp = packaged + utils.stripNamespace(relProp);
						sObjectContainer.relationshipProperties[newRelProp] = sObjectContainer.relationshipProperties[relProp];
						delete sObjectContainer.relationshipProperties[relProp];
						
						sObjectContainer.relationshipProperties[newRelProp] = info.map(function (relName) {
							if (utils.getNamespace(relName) == dev && (
								relName.indexOf('__c') != -1 || relName.indexOf('__r') != -1
							)) {
								relName = packaged + utils.stripNamespace(relName);
							}
							
							return relName;
						});
					}
				}
			}
		}
	};
	
	/**
	 * Allows jimmying in a dev namespace for pre-sfdx packages when saving to server
	 * @param sObjectContainer
	 * @param utils
	 */
	LiteForceService.remapNamespacesToDb = function (sObjectContainer, utils) {
		for (var dev in LiteForceService.REMAP_NAMESPACES) {
			if (!LiteForceService.REMAP_NAMESPACES.hasOwnProperty(dev)) {
				continue;
			}
			
			if (dev.length) { dev = dev + '__'; }

			var packaged = LiteForceService.REMAP_NAMESPACES[dev] + '__';
			
			if (utils.getNamespace(sObjectContainer.type) === packaged && sObjectContainer.type.indexOf('__c') != -1) {
				sObjectContainer.type = dev + utils.stripNamespace(sObjectContainer.type);
			}
			
			for (var prop in sObjectContainer.obj) {
				if (sObjectContainer.obj.hasOwnProperty(prop)) {
					if (utils.getNamespace(prop) == packaged && (prop.indexOf('__c') != -1 || prop.indexOf('__r') != -1)) {
						var newProp = dev + utils.stripNamespace(prop);
						sObjectContainer.obj[newProp] = sObjectContainer.obj[prop];
						delete sObjectContainer.obj[prop];
					}
				}
			}
		}
	};
	
	/**
	 * Shortcut for one IForce. See {@link LifeCycle.LiteForceService.retrieveIForces}
	 *
	 * @param {Object} [objToMergeInto] - Placeholder to match RemotingTemplate format
	 * @param {string} recordId - sObject Id
	 * @param {function(result: IForceJS): void} success - Callback to be called with mappedFromDb IForce
	 * @param {function(error): void} [failure]
	 * @param [remotingOptions]
	 * @param {boolean} [bBlockUI = false]
	 * @param {LifeCycle.IForceData.LiteForceUtils} [liteForceUtils = LifeCycle.IForceCache._liteForceUtils]
	 * @param {boolean} [disableMichUltraForces = false] - Disables selective SELECT field filtering
	 * @param {string} [arbitraryNamespace] - Optionally pass an arbitrary namespace to getCurrentTypedFieldList
	 * @return {*}
	 */
	LiteForceService.retrieveIForce = function (
		objToMergeInto,
		recordId,
		success,
		failure,
		remotingOptions,
		bBlockUI,
		liteForceUtils,
		disableMichUltraForces,
		arbitraryNamespace
	) {
		liteForceUtils = (liteForceUtils || LiteForceService._getLiteForceUtils());
		
		return LiteForceService.retrieveIForces([objToMergeInto], [recordId], function (results) {
			if (results.length) {
				success(results[0]);
			} else {
				failure(null);
			}
		}, failure, remotingOptions, bBlockUI, liteForceUtils, disableMichUltraForces, arbitraryNamespace);
	};
	
	/**
	 * Retrieves IForces using the LiteForceService client-side mapFromDb logic.
	 *
	 * @param {Array} [arrayToMergeInto] - Placeholder to match RemotingTemplate format
	 * @param {Array<string>} recordIds - sObject Ids
	 * @param {function(result: Array<IForceJS>): void} success - Callback to be called with mappedFromDb IForces
	 * @param {function(error): void} [failure]
	 * @param [remotingOptions]
	 * @param {boolean} [bBlockUI = false]
	 * @param {LifeCycle.IForceData.LiteForceUtils} [liteForceUtils = LifeCycle.IForceCache._liteForceUtils]
	 * @param {boolean} [disableMichUltraForces = false] - Disables selective SELECT field filtering
	 * @param {string} [arbitraryNamespace] - Optionally pass an arbitrary namespace to getCurrentTypedFieldList
	 * @return {*}
	 */
	LiteForceService.retrieveIForces = function (
		arrayToMergeInto,
		recordIds,
		success,
		failure,
		remotingOptions,
		bBlockUI,
		liteForceUtils,
		disableMichUltraForces,
		arbitraryNamespace
	) {
		liteForceUtils = (liteForceUtils || LiteForceService._getLiteForceUtils());
		
		var typedFieldList;
		if (!disableMichUltraForces) {
			typedFieldList = liteForceUtils.getCurrentTypedFieldList(arbitraryNamespace);
		}
		
		return LifeCycle.LiteForceServiceFunctions.retrieveLiteForces(arrayToMergeInto, recordIds, function (results) {
			var forces = [];
			
			results = results.map(function (result) { LiteForceService.remapNamespacesFromDb(result, liteForceUtils); return result; });
			
			if (results) {
				forces = liteForceUtils.translateLiteForces(results);
			}
			
			success(forces);
		}, failure, remotingOptions, bBlockUI, typedFieldList);
	};
	
	/**
	 * Shortcut for one IForce. See {@link LifeCycle.LiteForceService.saveIForces}
	 *
	 * @param {(IForceJS|IForceKO)} force - Knockout or pure JS IForce to save
	 * @param {function(savedForces: IForceJS): void} success - Saved JS IForce
	 * @param {function(error): void} [failure]
	 * @param [remotingOptions]
	 * @param {boolean} [bBlockUI = false]
	 * @param {LifeCycle.IForceData.LiteForceUtils} [liteForceUtils = LifeCycle.IForceCache._liteForceUtils]
	 */
	LiteForceService.saveIForce = function (
		force,
		success,
		failure,
		remotingOptions,
		bBlockUI,
		liteForceUtils
	) {
		return LiteForceService.saveIForces([force], function (forces) {
			if (forces.length) {
				success(forces[0]);
			} else {
				failure(null);
			}
		}, failure, remotingOptions, bBlockUI, liteForceUtils);
	};
	
	/**
	 * Save mapped Knockout IForces or plain JS IForces.
	 * If Knockout, mapToJS will use the optimized mapper.
	 *
	 * @param {Array<(IForceJS|IForceKO)>} forces - Knockout or pure JS IForces to save
	 * @param {function(savedForces: Array<IForceJS>): void} success - Saved JS IForces
	 * @param {function(error): void} [failure]
	 * @param [remotingOptions]
	 * @param {boolean} [bBlockUI = false]
	 * @param {LifeCycle.IForceData.LiteForceUtils} [liteForceUtils = LifeCycle.IForceCache._liteForceUtils]
	 */
	LiteForceService.saveIForces = function (
		forces,
		success,
		failure,
		remotingOptions,
		bBlockUI,
		liteForceUtils
	) {
		liteForceUtils = (liteForceUtils || LiteForceService._getLiteForceUtils());
		
		var sObjects = [];
		var unNamespacedSObjects = [];
		for (var i = 0; i < forces.length; i++) {
			var force = forces[i];
			force = liteForceUtils.app.mapToJS(force, {useOptimizedMapper: true, maxDepth: 0});
			
			var sObjectContainer = liteForceUtils.mapToDb(force);
			LiteForceService.remapNamespacesToDb(sObjectContainer, liteForceUtils);
			var sObject = sObjectContainer.obj;
			var sObjectType = sObjectContainer.type;
			
			if (liteForceUtils.isObjectAndFieldsFullyNamespaced(sObjectContainer)) {
				sObjects.push(sObject);
			} else {
				sObject.sobjectType = sObjectType;
				unNamespacedSObjects.push(sObject);
			}
		}
		
		var allForces = [];
		var inFlight = 0;
		
		function _saveSome (service, objects) {
			inFlight++;
			service(
				{},
				objects,
				function (updatedSObjectContainers) {
					inFlight--;
					for (var i = 0; i < updatedSObjectContainers.length; i++) {
						var updatedSObjectContainer = updatedSObjectContainers[i];
						var force = liteForceUtils.mapFromDb(updatedSObjectContainer);
						allForces.push(force);
					}
					
					if (!inFlight) {
						_done();
					}
				},
				failure,
				remotingOptions,
				bBlockUI
			);
		}
		
		if (sObjects.length) {
			_saveSome(LifeCycle.LiteForceServiceFunctions.saveSObjects, sObjects);
		}
		
		if (unNamespacedSObjects.length) {
			_saveSome(LifeCycle.LiteForceServiceFunctions.saveUnNamespacedSObjects, unNamespacedSObjects);
		}
		
		if (!sObjects.length && !unNamespacedSObjects.length) {
			_done();
		}
		
		function _done () {
			success(allForces);
		}
	};
	
	/**
	 * Shortcut for one IForce. See {@link LifeCycle.LiteForceService.deleteIForces}
	 *
	 * @param {(IForceJS|IForceKO)} force - Knockout or pure JS IForce to delete
	 * @param {function(): void} success - Deletion callback
	 * @param {function(error): void} [failure]
	 * @param [remotingOptions]
	 * @param {boolean} [bBlockUI = false]
	 * @param {LifeCycle.IForceData.LiteForceUtils} [liteForceUtils = LifeCycle.IForceCache._liteForceUtils]
	 */
	LiteForceService.deleteIForce = function (
		force,
		success,
		failure,
		remotingOptions,
		bBlockUI,
		liteForceUtils
	) {
		return LiteForceService.deleteIForces([force], function () {
			success();
		}, failure, remotingOptions, bBlockUI, liteForceUtils);
	};
	
	/**
	 * Delete mapped Knockout IForces or plain JS IForces.
	 * If Knockout, mapToJS will use the optimized mapper.
	 *
	 * @param {Array<(IForceJS|IForceKO)>} forces - Knockout or pure JS IForces to delete
	 * @param {function(): void} success - Deletion callback
	 * @param {function(error): void} [failure]
	 * @param [remotingOptions]
	 * @param {boolean} [bBlockUI = false]
	 * @param {LifeCycle.IForceData.LiteForceUtils} [liteForceUtils = LifeCycle.IForceCache._liteForceUtils]
	 */
	LiteForceService.deleteIForces = function (
		forces,
		success,
		failure,
		remotingOptions,
		bBlockUI,
		liteForceUtils
	) {
		liteForceUtils = (liteForceUtils || LiteForceService._getLiteForceUtils());
		
		var sObjects = [];
		for (var i = 0; i < forces.length; i++) {
			var force = forces[i];
			if (force.__ko_mapping__) {
				force = liteForceUtils.app.mapToJS(force, {useOptimizedMapper: true, maxDepth: 0});
			}
			
			var sObjectContainer = liteForceUtils.mapToDb(force);
			var sObject = sObjectContainer.obj;
			for (var prop in sObject) {
				if (sObject.hasOwnProperty(prop)) {
					if (prop != 'Id' && prop != 'sobjectType') {
						delete sObject[prop];
					}
				}
			}
			
			sObjects.push(sObject);
		}
		
		return LifeCycle.LiteForceServiceFunctions.deleteSObjects(
			[],
			sObjects,
			success,
			failure,
			remotingOptions,
			bBlockUI
		);
	};
	
	/**
	 * Returns an instance of LiteForceUtils for mapping
	 * @return {LifeCycle.IForceData.LiteForceUtils}
	 * @private
	 */
	LiteForceService._getLiteForceUtils = function () {
		return (LifeCycle.IForceCache._liteForceUtils || LiteForceService._createLiteForceUtils());
	};
	
	/**
	 * Returns a new instance of LiteForceUtils if needed.
	 * @return {LifeCycle.IForceData.LiteForceUtils}
	 * @private
	 */
	LiteForceService._createLiteForceUtils = function () {
		var app = new LifeCycle.App();
		var utils = new LifeCycle.IForceData.IForceUtils(app);
		return new LifeCycle.IForceData.LiteForceUtils(app, utils);
	};
	
	LifeCycle.LiteForceService = LiteForceService;
})();

/**
 * @typedef {Object} LifeCycle.LiteForceServiceFunctions
 * @property {
 * 	function(Object, string, function(ISObjectContainer): void, function(*): void, *, boolean,
 * 	Object<string, Array<string>>): void
 * } retrieveLiteForce
 *
 * @property {
 * 	function(Array, Array<string>, function(Array<ISObjectContainer>): void, function(*): void, *, boolean,
 * 	Object<string, Array<string>>): void
 * } retrieveLiteForces
 *
 * @property {
 * 	function(Object, SObject, function(ISObjectContainer): void, function(*): void, *, boolean): void
 * } saveSObjects
 *
 * @property {
 * 	function(Array, Array<SObject>, function(Array<ISObjectContainer>): void, function(*): void, *, boolean): void
 * } saveSObject
 *
 * @property {
 * 	function(Object, SObject, function(ISObjectContainer): void, function(*): void, *, boolean): void
 * } saveUnNamespacedSObjects
 *
 * @property {
 * 	function(Array, Array<SObject>, function(Array<ISObjectContainer>): void, function(*): void, *, boolean): void
 * } saveUnNamespacedSObject
 *
 * @property {
 * 	function(Object, SObject, function(): void, function(*): void, *, boolean): void
 * } deleteSObject
 *
 * @property {
 * 	function(Array, Array<SObject>, function(): void, function(*): void, *, boolean): void
 * } deleteSObjects
 *
 * @property {
 * 	function(Array, string, function(Array<ISObjectContainer>): void, function(*): void, *, boolean): void
 * } queryLiteForces
 *
 * @property {
 * 	function(Array, string, function(Array<string>): void, function(*): void, *, boolean): void
 * } queryIds
 */
