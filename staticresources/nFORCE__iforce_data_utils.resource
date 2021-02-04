(function () {
	/**
	 * @param app
	 * @constructor
	 * @class IForceUtils
	 * @memberOf LifeCycle.IForceData
	 */
	var IForceUtils = function (app) {
		this.app = app;

		this.defaultKoMappingCache = {};
		this.defaultMappedPropertiesCache = {};
		this.readOnlyCache = {};
		this.propertyToTypeCache = {};
	};

	// ==============================================================
	// Data Manipulation / Mapping Utilities
	// ==============================================================
	/**
	 * Returns the __ko_mapping__ for the object model type.
	 * Utilizes a cache based on the type for performance.
	 *
	 * @param {(IForceKO|IForceJS)} obj
	 * @return {*}
	 */
	IForceUtils.prototype.getDefaultKOMappingForObject = function (obj) {
		var type = ko.unwrap(obj.apexType);
		if (!type) {
			return {};
		}

		if (this.defaultKoMappingCache[type]) {
			return this.defaultKoMappingCache[type];
		}

		var mapping = this.getMappingForObj(obj);
		if (mapping.create) {
			var instance = mapping.create({data: {apexType: type}, useViewModelPlugin: false});
			if (!instance.__ko_mapping__) {
				return {};
			}

			var koMapping = instance.__ko_mapping__;
			this.defaultKoMappingCache[type] = koMapping;
			return koMapping;
		} else {
			return {};
		}
	};

	/**
	 * Returns the default mapped properties for the object model type.
	 * Utilizes a cache based on the type for performance.
	 *
	 * @param {(IForceKO|IForceJS)} obj
	 * @return {*}
	 */
	IForceUtils.prototype.getDefaultMappedPropertiesForObject = function (obj) {
		var type = ko.unwrap(obj.apexType);
		if (!type) {
			return {};
		}

		if (this.defaultMappedPropertiesCache[type]) {
			return this.defaultMappedPropertiesCache[type];
		}

		var koMapping = this.getDefaultKOMappingForObject(obj);
		if (koMapping.mappedProperties) {
			this.defaultMappedPropertiesCache[type] = koMapping.mappedProperties;
			return koMapping.mappedProperties;
		} else {
			return {};
		}
	};

	/**
	 * Returns the utils app's Knockout mappings for the object's type.
	 *
	 * @param {(IForceKO|IForceJS)} obj
	 * @return {*}
	 */
	IForceUtils.prototype.getMappingForObj = function (obj) {
		if (!obj || !ko.unwrap(obj.apexType)) {
			return null;
		}

		var property = this.getPropertyForType(ko.unwrap(obj.apexType));
		return this.app.getMapping()[property];
	};

	/**
	 * Manually add __ko_mapping__
	 *
	 * @param {IForceKO} mappedObj
	 * @param {IForceJS} [unmappedObj] - Use pre-mapped object to determine original set of properties
	 */
	IForceUtils.prototype.addKOMappings = function (mappedObj, unmappedObj) {
		// Apply default mapping if not present
		if (!mappedObj.__ko_mapping__) {
			mappedObj.__ko_mapping__ = jQuery.extend(true, {}, this.getDefaultKOMappingForObject(mappedObj));
		}

		if (!mappedObj.__ko_mapping__.copiedProperties) {
			mappedObj.__ko_mapping__.copiedProperties = {};
		}

		if (
			!mappedObj.__ko_mapping__.mappedProperties ||
			JSON.stringify(mappedObj.__ko_mapping__.mappedProperties) == '{}'
		) {
			var defaultProps = this.getDefaultMappedPropertiesForObject(mappedObj);
			mappedObj.__ko_mapping__.mappedProperties = jQuery.extend(true, {}, defaultProps);
		}

		if (!mappedObj.__ko_mapping__.ignore) {
			mappedObj.__ko_mapping__.ignore = [];
		}

		/** @type {_.List<string>} */
		var customIgnores = [
			'__changeTracking',
			'__cached',
			'__shallow',
			'__height',
			'__depth',
			'__path',
			'__placeholder'
		];
		mappedObj.__ko_mapping__.ignore = _.union(
			/** @type {_.List<string>} */mappedObj.__ko_mapping__.ignore,
			customIgnores
		);

		if (unmappedObj) {
			var mappedProps = mappedObj.__ko_mapping__.mappedProperties;

			// Ensure extra properties are present in mappedProperties
			for (var unmappedProp in unmappedObj) {
				if (
					unmappedObj.hasOwnProperty(unmappedProp) &&
					!mappedProps.hasOwnProperty(unmappedProp)
				) {
					mappedProps[unmappedProp] = true;
				}
			}
		}
	};

	/**
	 * Generate a new KO model from the JS.
	 * Automatically sets/adds to __ko_mapping__
	 *
	 * @param {IForceJS} obj
	 * @param {boolean} useMappingPlugin
	 * @return {(IForceKO|null)}
	 */
	IForceUtils.prototype.constructModel = function (obj, useMappingPlugin) {
		if (!obj) {
			return null;
		}

		var useViewModelPlugin = !useMappingPlugin;

		var mapping = this.getMappingForObj(obj);
		if (mapping && mapping.create) {
			var modelObj = mapping.create({data: obj, useViewModelPlugin: useViewModelPlugin});
			this.addKOMappings(modelObj, obj);
			return modelObj;
		} else {
			return null;
		}
	};

	/**
	 * Construct a KO model from JS using minimal mapping.
	 * Uses a cache of bare models that are used as templates for quicker mapping.
	 *
	 * @param {IForceJS} clone
	 * @return {IForceKO}
	 */
	IForceUtils.prototype.constructReadOnly = function (clone) {
		var construct = {};
		var mapped = null;
		if (!this.readOnlyCache[clone.apexType]) {
			var mapping = this.getMappingForObj(clone);
			mapped = mapping.create({data: {}, useViewModelPlugin: true});
			this.readOnlyCache[clone.apexType] = mapped;
		} else {
			mapped = this.readOnlyCache[clone.apexType];
		}

		for (var prop in clone) {
			if (clone.hasOwnProperty(prop)) {
				var val = clone[prop];
				if (typeof val != 'object' || val === null) {
					construct[prop] = ko.observable(val);
				} else if (val instanceof Array) {
					construct[prop] = ko.observableArray(val);
				} else {
					construct[prop] = val;
				}
			}
		}

		for (var mappedProp in mapped) {
			if (mapped.hasOwnProperty(mappedProp) && !construct.hasOwnProperty(mappedProp)) {
				var mappedVal = mapped[mappedProp];

				if (typeof mappedVal == 'function' && !ko.isObservable(mappedVal) && !ko.isComputed(mappedVal)) {
					construct[mappedProp] = mappedVal;
				} else if (ko.isObservable(mappedVal) && !ko.isComputed(mappedVal)) {
					if (mappedVal() instanceof Array) {
						if (!mappedVal().length) {
							construct[mappedProp] = ko.observableArray();
						} else {
							construct[mappedProp] = ko.observableArray(mappedVal().slice(0));
						}
					} else {
						construct[mappedProp] = ko.observable(mappedVal());
					}
				}
			}
		}

		return construct;
	};

	/**
	 * Adds change tracking utilities to a KO model.
	 *
	 * @param {IForceKO} mappedObj
	 */
	IForceUtils.prototype.trackChanges = function (mappedObj) {

		if (mappedObj.__changeTracking) {
			return;
		}

		for (var prop in mappedObj) {
			if (
				mappedObj.hasOwnProperty(prop) &&
				ko.isObservable(mappedObj[prop]) &&
				IForceUtils._hierarchyProperties.indexOf(prop) == -1
			) {
				// Non-children observable
				var observable = mappedObj[prop];
				this.addChangeTrackingToObservable(observable);
			}
		}

		mappedObj.__changeTracking = {
			isTrackingChanges: false
		};

		mappedObj.__changeTracking.markClean = function () {
			for (var prop in mappedObj) {
				if (
					mappedObj.hasOwnProperty(prop) &&
					ko.isObservable(mappedObj[prop]) &&
					IForceUtils._hierarchyProperties.indexOf(prop) == -1
				) {
					var observable = mappedObj[prop];
					if (observable.__changeTracking.isDirty()) {
						observable.__changeTracking.markClean();
					}
				}
			}
		};

		mappedObj.__changeTracking.isDirty = function () {
			if (!mappedObj.__changeTracking.isTrackingChanges) {
				return false;
			}

			for (var prop in mappedObj) {
				if (
					mappedObj.hasOwnProperty(prop) &&
					ko.isObservable(mappedObj[prop]) &&
					IForceUtils._hierarchyProperties.indexOf(prop) == -1
				) {
					var observable = mappedObj[prop];
					if (observable.__changeTracking.isDirty()) {
						return true;
					}
				}
			}

			return false;
		};

		mappedObj.__changeTracking.isTrackingChanges = true;
	};

	/**
	 * Adds change tracking to a single observable
	 * @param {KnockoutObservable<any>} observable
	 */
	IForceUtils.prototype.addChangeTrackingToObservable = function (observable) {
		var _this = this;

		if (observable.__changeTracking) {
			return;
		}

		observable.__changeTracking = {
			isTrackingChanges: false,
			savedState: null
		};

		observable.__changeTracking.saveState = function () {
			observable.__changeTracking.savedState = JSON.stringify(ko.toJS(observable), function (key, value) {
				if (_this.isModelObject(value)) {
					// Will be included as separate iForce
					return;
				}

				return value;
			});
		};

		observable.__changeTracking.markClean = function () {
			observable.__changeTracking.saveState();
		};

		observable.__changeTracking.isDirty = function () {
			if (!observable.__changeTracking.isTrackingChanges) {
				return false;
			}

			var newClone = JSON.stringify(ko.toJS(observable), function (key, value) {
				if (_this.isModelObject(value)) {
					// Will be included as separate iForce
					return;
				}

				return value;
			});

			return newClone != observable.__changeTracking.savedState;
		};

		observable.__changeTracking.saveState();
		observable.__changeTracking.isTrackingChanges = true;
	};

	// ==============================================================
	// Loader Utilities
	// ==============================================================
	/**
	 *
	 * @return {*}
	 */
	IForceUtils.prototype.getIForceProvider = function () {
		if (LifeCycle.IForceData.IForceKoNgProxy) {
			return LifeCycle.IForceData.IForceKoNgProxy
		} else if (LifeCycle.Service) {
			return LifeCycle.Service;
		} else {
			return LifeCycle;
		}
	};

	// ==============================================================
	// Cache Management Utilities
	// ==============================================================
	/**
	 * Determines whether an object is mergable with another based on type.
	 *
	 * @param {IForceKO} baseObj
	 * @param {(IForceJS|IForceKO)} mergeObj
	 * @return {boolean}
	 */
	IForceUtils.prototype.areObjectsMergeable = function (baseObj, mergeObj) {
		if (!baseObj || !mergeObj) {
			return false;
		}

		if (!ko.isObservable(baseObj.recordId)) {
			return false;
		}

		var baseObjType = baseObj.apexType();
		var mergeObjType = ko.unwrap(mergeObj.apexType);

		return this.areTypesMergeable(baseObjType, mergeObjType);
	};

	/**
	 * Specify KO mapping properties that correspond to the same base type
	 *
	 * @static
	 * @property
	 * @type {Object<string,string>}
	 * @private
	 */
	IForceUtils._inheritenceOverrides = {
		borrower: 'involvement',
		guarantor: 'involvement',
		relatedEntity: 'involvement',
		underwritingBundleTemplate: 'underwritingBundle',
		spreadStatementTemplate: 'spreadStatement'
	};
	/**
	 * Determines whether two Apex types are mergeable (same or inherited)
	 * Uses corresponding KO mapping property for type to determine mergeability.
	 *
	 * @param {string} type1
	 * @param {string} type2
	 * @return {boolean}
	 */
	IForceUtils.prototype.areTypesMergeable = function (type1, type2) {
		var type1Property = this.getPropertyForType(type1);
		var type2Property = this.getPropertyForType(type2);
		if (IForceUtils._inheritenceOverrides[type1Property]) {
			type1Property = IForceUtils._inheritenceOverrides[type1Property];
		}

		if (IForceUtils._inheritenceOverrides[type2Property]) {
			type2Property = IForceUtils._inheritenceOverrides[type2Property];
		}

		return (type1Property == type2Property);
	};

	/**
	 * Returns a new shallow placeholder that represents an unloaded relationship
	 *
	 * @param {(IForceJS|IForceKO)} obj
	 * @return {IForceKO}
	 */
	IForceUtils.prototype.generateRelationshipPlaceholder = function (obj) {
		return {
			apexType: ko.observable(ko.unwrap(obj.apexType)),
			recordId: ko.observable(ko.unwrap(obj.recordId))
		};
	};

	/**
	 *
	 * @param {(IForceJS|IForceKO)} obj
	 * @return {IForceKO}
	 */
	IForceUtils.prototype.generateMergeableClone = function (obj) {
		var clone = {};
		clone.__shallow = true;
		for (var prop in obj) {
			if (obj.hasOwnProperty(prop)) {
				var val = obj[prop];
				var _val = ko.unwrap(obj[prop]);
				if (_val && _val.apexType && !_val.recordId) {
					continue;
				}

				if (
					!this.isModelObject(_val) &&
					!this.isChildrenProperty(prop, _val)
				) {
					clone[prop] = val;
				} else if (this.isModelObject(val)) {
					clone[prop] = this.generateRelationshipPlaceholder(val);
				} else if (_val instanceof Array) {
					if (this.isChildrenProperty(prop, val)) {
						clone[prop] = [];
					} else {
						var shallowValues = [];
						for (var i = 0; i < _val.length; i++) {
							var pointer = this.generateMergeableClone(_val[i]);
							if (pointer) {
								shallowValues.push(pointer);
							}
						}

						clone[prop] = shallowValues;
					}
				}
			}
		}

		return clone;
	};

	/**
	 * @deprecated
	 * @param jsObjs
	 * @param _topLevelObjects
	 * @param parentObj
	 * @return {*}
	 */
	IForceUtils.prototype.flattenObjects = function (jsObjs, _topLevelObjects, parentObj) {

		var topLevelObjects = _topLevelObjects;
		if (!_topLevelObjects) {
			topLevelObjects = [];
		}

		function _topLevel (jsObj) {
			for (var i = 0; i < topLevelObjects.length; i++) {
				var topLevelObject = topLevelObjects[i];
				if (_18Id(topLevelObject.recordId) == _18Id(jsObj.recordId)) {
					return topLevelObject;
				}
			}

			return null;
		}

		function _flattenObject (jsObj) {
			for (var prop in jsObj) {
				if (jsObj.hasOwnProperty(prop)) {
					var val = jsObj[prop];
					if (this.isChildrenProperty(prop, val)) {
						//this.flattenObjects(val, topLevelObjects, jsObj);

						// Break parent->child relationships
						jsObj[prop] = [];
					}
				}
			}
		}

		function _mergeObjects (target, source) {
			for (var prop in source) {
				if (
					source.hasOwnProperty(prop)
				) {
					if (!target.hasOwnProperty(prop)) {
						target[prop] = source[prop];
					} else if (typeof target[prop] == 'object') {
						_mergeObjects(target[prop], source[prop]);
					} else {
						if (!target[prop] && source[prop]) {
							target[prop] = source[prop];
						}
					}
				}
			}
		}

		for (var i = 0; i < jsObjs.length; i++) {
			var jsObj = jsObjs[i];
			if (!jsObj || !jsObj.recordId || !jsObj.apexType) {
				// Not a cacheable object
				// Drop
				continue;
			}

			_flattenObject(jsObj, parentObj);

			if (_topLevel(jsObj)) {
				// Already flattened
				// Set any missing properties and move on
				var existing = _topLevel(jsObj);
				_mergeObjects(existing, jsObj);
				continue;
			}

			topLevelObjects.push(jsObj);

			// topLevelIds.push(jsObj.recordId);

			if (parentObj) {
				// for (var c = 0; c < val.length; c++) {
				// 	var child = val[c];
				// 	// var flattenedChild = _flattenObject(val, parentObj);
				// 	// topLevelIds.push.apply(topLevelObjects, flattenedChild.recordId);
				// 	// topLevelObjects.push.apply(topLevelObjects, flattenedChild);

				// Ensure child has reference back to parent for later joining
				var hasBackReference = false;
				for (var prop in jsObj) {
					if (jsObj.hasOwnProperty(prop)) {
						var val = jsObj[prop];
						if (val && typeof val == 'object') {
							if (val.recordId && _18Id(val.recordId) == _18Id(parentObj.recordId)) {
								hasBackReference = true;
							}
						}
					}
				}

				if (!hasBackReference) {
					// Add back reference
					var backReferenceProperty = this.getChildParentProperty(parentObj);
					jsObj[backReferenceProperty] = {
						recordId: parentObj.recordId,
						apexType: parentObj.apexType
					};
				}

				// }
			}

			// var cachedObject = _cacheObject(jsObj, [], jsObjs);
			// // cacheChain.push(cachedObject.recordId());
			// cachedObjects.push(cachedObject);
		}

		return topLevelObjects;
	};

	/**
	 * Returns whether or not there is a registered mapping for the object type.
	 *
	 * @param {(IForceJS|IForceKO)} obj
	 * @return {boolean}
	 */
	IForceUtils.prototype.isModelObject = function (obj) {
		if (!obj) {
			return false;
		}

		return !!this.getMappingForObj(obj);
	};

	// Merge object into another object
	/**
	 * Updates a target object with new data from the obj.
	 *
	 * @param {IForceKO} target
	 * @param {(IForceJS|IForceKO)} obj
	 * @param {boolean} shallow - Have relationships been removed already
	 * @param {boolean} isPrepared - Obj pre-mapped-to-JS or not. False if obj is KO. True if obj is plain JS.
	 * @return {IForceKO}
	 */
	IForceUtils.prototype.safeMerge = function (target, obj, shallow, isPrepared) {
		if (!this.areObjectsMergeable(target, obj)) {
			throw 'Tried to merge incompatible objects';
		}

		if (this.isPlaceholder(obj)) {
			return target;
		}

		var customMapping = {};
		var mapping = this.app.getMapping();
		for (var prop in mapping) {
			if (mapping.hasOwnProperty(prop)) {
				customMapping[prop] = mapping[prop];
			}
		}

		customMapping = jQuery.extend(true, {}, this.app.getMapping());

		var _this = this;
		customMapping.update = function (arg) {
			var mergeObj = arg.data;
			var target = arg.target;

			var changeObj = {};

			for (var prop in mergeObj) {
				if (mergeObj.hasOwnProperty(prop)) {
					var val = mergeObj[prop];
					var _val = ko.unwrap(val);

					// Don't overwrite with undefined
					if (_val === undefined || _.isEmpty(_val)) {
						continue;
					}

					// Check if mergeable property
					if (
						ko.unwrap(target[prop]) != _val &&
						(
							!target[prop] ||
							!target[prop].__changeTracking ||
							!target[prop].__changeTracking.isDirty()
						) && (
							prop != 'isRelationshipPointer' || _val === false
						) && (
							prop != 'isLoaded' || _val === true
						) && (
							prop != 'isSaved' || _val === true
						)
					) {
						if (_this.isPlaceholder(val) && _.isEmpty(ko.unwrap(val.recordId))) {
							// Don't Use Empty Placeholders
							continue;
						}

						if (!_this.isModelObject(_val)) {
							// Ignore if model obj. The relationship should already be set up
							if (ko.isObservable(target[prop])) {
								changeObj[prop] = target[prop](val);
							} else {
								changeObj[prop] = (
									target[prop] = val
								);
							}
						}
					}
				}
			}

			return changeObj;
		};

		// ko.viewmodel.updateFromModel(target, mergeClone);
		// var merged = target;
		var mergeClone;
		if (isPrepared) {
			mergeClone = obj;
		} else {
			if (shallow) {
				mergeClone = this.app.mapToJS(this.generateMergeableClone(obj));
			} else {
				mergeClone = this.app.mapToJS(obj);
			}
		}

		var merged = this.app.mapFromJS(mergeClone, this.app.getMapping(), target);
		this.addKOMappings(merged);

		return merged;
	};

	// Upsert object into a target. Set property, merge property, push array, or merge array item
	/**
	 * Merge an object into an array or object.
	 * If the object is already present in the target, merge the obj with the existing item in the target.
	 *
	 * @param {(Array|KnockoutObservableArray<any>|Object)} _target
	 * @param {IForceKO} obj
	 */
	IForceUtils.prototype.mergeInto = function (_target, obj) {
		var target = ko.unwrap(_target);
		var id = obj.recordId();
		var lookupKey = ko.unwrap(obj.lookupKey);
		if (!id || !_18Id(id)) {
			return;
		}

		if (!target || typeof target != 'object') {
			return;
		}

		function _findInTarget () {
			if (target instanceof Array) {
				for (var i = 0; i < target.length; i++) {
					var targetItem = target[i];
					var targetId = ko.unwrap(targetItem.recordId());
					var targetLookupKey = ko.unwrap(targetItem.lookupKey);
					if (_18Id(targetId) == _18Id(id) || ((lookupKey == targetLookupKey) && !_.isEmpty(lookupKey))) {
						return i;
					}
				}

				return false;
			} else {
				return _18Id(id);
			}
		}

		var targetIndex = _findInTarget();
		var targetObj;
		if (targetIndex || targetIndex === 0) {
			targetObj = ko.unwrap(target)[targetIndex];
		}

		if (targetObj) {
			if (targetObj == obj) {
				return;
			}

			// Merge if mapped, overwrite if not
			if (ko.isObservable(targetObj.recordId)) {
				this.safeMerge(targetObj, obj, true);
			} else {
				target[targetIndex] = obj;
			}
		} else {
			// Push
			if (target instanceof Array) {
				_target.push(obj);
				if (obj.hasOwnProperty('rowNumber')) {
					_target.sort(function (a, b) {
						if (ko.unwrap(a.rowNumber) < ko.unwrap(b.rowNumber)) {
							return -1;
						} else if (ko.unwrap(a.rowNumber) > ko.unwrap(b.rowNumber)) {
							return 1;
						}

						return 0;
					});
				}
			} else {
				target[_18Id(id)] = obj;
			}
		}
	};

	/**
	 * Returns whether or not an object will be cached as part of the same batch or not.
	 *
	 * @param {IForceJS} jsObj
	 * @param {Array<IForceKO>} cacheChain
	 * @param {Array<IForceKO>} topLevelObjects
	 * @return {boolean}
	 */
	IForceUtils.prototype.willCache = function (jsObj, cacheChain, topLevelObjects) {
		if (
			!(cacheChain instanceof Array) ||
			!(topLevelObjects instanceof Array)
		) {
			return false;
		}

		if (!cacheChain.length) {
			// is top level
			return false;
		}

		for (var i = 0; i < topLevelObjects.length; i++) {
			var topLevelObject = topLevelObjects[i];
			if (_18Id(topLevelObject.recordId) == _18Id(jsObj.recordId)) {
				return true;
			}
		}

		return false;
	};

	/**
	 * Determines whether or not an object is a placeholder, or a fully loaded object.
	 *
	 * @param {(IForceJS|IForceKO)} obj
	 * @return {boolean}
	 */
	IForceUtils.prototype.isPlaceholder = function (obj) {
		if (ko.unwrap(obj.__placeholder)) {
			return true;
		}

		if (ko.unwrap(obj.isRelationshipPointer)) {
			return true;
		}

		var realProps = [];
		for (var prop in obj) {
			if (obj.hasOwnProperty(prop)) {
				if (prop.indexOf('_') !== 0) {
					var _val = ko.unwrap(obj[prop]);
					if (_val !== null && _val !== undefined) {
						realProps.push(prop);
					}
				}
			}
		}

		if (realProps.length == 2) {
			if (realProps.indexOf('apexType') != -1 && realProps.indexOf('recordId') != -1) {
				return true;
			}
		}

		return false;
	};

	// ==============================================================
	// Data Graph Utilities
	// ==============================================================
	// Is the 'lowest' member of a hierarchy being cached
	/**
	 * Returns true if object has no child objects.
	 *
	 * @param {(IForceKO|IForceJS)} obj
	 * @return {boolean}
	 */
	IForceUtils.prototype.isTailObject = function (obj) {
		return !this.hasNonEmptyChildrenProperty(obj);
	};

	/**
	 * Checks if object has any children properties with objects present.
	 *
	 * @param {(IForceKO|IForceJS)} obj
	 * @return {boolean}
	 */
	IForceUtils.prototype.hasNonEmptyChildrenProperty = function (obj) {
		if (!obj) {
			return false;
		}

		var has = false;
		for (var prop in obj) {
			if (obj.hasOwnProperty(prop)) {
				var val = ko.unwrap(obj[prop]);
				if (this.isChildrenProperty(prop, val)) {
					if (val.length) {
						has = true;
					}
				}
			}
		}

		return has;
	};

	/**
	 * Checks if a property represents a child relationship.
	 * Based on whether or not the registered mappings contain a property mapping for the property key.
	 * If not it also checks the value's items (must be an array) for any that are model objects as a fallback.
	 *
	 * @param {string} property
	 * @param {*} _value
	 * @return {boolean}
	 */
	IForceUtils.prototype.isChildrenProperty = function (property, _value) {
		var value = ko.unwrap(_value);
		if (
			typeof property != 'string' ||
			typeof value != 'object' ||
			!(value instanceof Array)
		) {
			return false;
		}

		if (this.getTypeForProperty(property)) {
			return true;
		}

		for (var i = 0; i < value.length; i++) {
			var arrayItem = value[i];
			if (this.isModelObject(arrayItem)) {
				return true;
			}
		}

		return false;
	};

	/**
	 * Determines the mapped Apex type for the property key.
	 * Uses a cache for performance.
	 *
	 * @param {string} property
	 * @return {string}
	 */
	IForceUtils.prototype.getTypeForProperty = function (property) {
		if (this.propertyToTypeCache[property]) {
			return this.propertyToTypeCache[property];
		}

		if (
			this.app.getMapping()[property] &&
			this.app.getMapping()[property].create &&
			this.app.getMapping()[property].create({data: {}, useViewModelPlugin: true}).apexType
		) {
			var type = this.app.getMapping()[property].create({data: {}, useViewModelPlugin: true}).apexType();

			// Cache and return
			this.propertyToTypeCache[property] = type;
			return type;
		} else {
			return null;
		}
	};

	/**
	 * Determines the KO mapping property key for the Apex type.
	 * @param {string} type
	 * @return {string}
	 */
	IForceUtils.prototype.getPropertyForType = function (type) {
		var namespace = (this.app.NAMESPACE_PREFIX) ? this.app.NAMESPACE_PREFIX : '';
		type = namespace + this.getApexType(type);
		return this.app.getTypesMap()[type];
	};

	/**
	 * Strips the Apex namespace.
	 *
	 * @param {string} namespacedType
	 * @return {string}
	 */
	IForceUtils.prototype.getApexType = function (namespacedType) {
		if (typeof namespacedType != 'string') {
			return null;
		}

		return ko.unwrap(namespacedType).substring(namespacedType.indexOf('.') + 1);
	};

	/**
	 *
	 * @param {(IForceKO|IForceJS)} object
	 * @param {string} expectedType
	 * @param {boolean} includeNamespace
	 * @return {boolean}
	 */
	IForceUtils.prototype.isType = function (object, expectedType, includeNamespace) {
		if (!object || !object.apexType) {
			return (expectedType == 'undefined' || expectedType == 'null');
		}

		var type = ko.unwrap(object.apexType);
		if (!includeNamespace) {
			type = this.getApexType(type);
		}

		return (type.toLowerCase() == expectedType.toLowerCase());
	};

	IForceUtils._hierarchyProperties = [
		'bundle',
		'bundles',
		'statements',
		'statement',
		'periods',
		'recordTotals',
		'recordTotal',
		'periodTotals',
		'records',
		'record',
		'recordValues',
		'period'
	];

	/**
	 * @deprecated
	 * @private
	 */
	IForceUtils._parentChildrenPropertyMap = {
		spreadStatement: 'statements',
		spreadStatementPeriod: 'periods',
		spreadStatementRecordTotal: 'recordTotals',
		spreadStatementPeriodTotal: 'periodTotals',
		spreadStatementRecord: 'records',
		spreadStatementRecordValue: 'recordValues'
	};
	/**
	 * @deprecated
	 * @param obj
	 * @return {*}
	 */
	IForceUtils.prototype.getParentChildrenProperty = function (obj) {
		if (!obj || !ko.unwrap(obj.apexType)) {
			return null;
		}

		var property = this.getPropertyForType(ko.unwrap(obj.apexType));
		return IForceUtils._parentChildrenPropertyMap[property];
	};

	/**
	 * @deprecated
	 * @private
	 */
	IForceUtils._childParentPropertyMap = {
		underwritingBundle: 'bundle',
		spreadStatement: 'statement',
		spreadStatementPeriod: 'period',
		spreadStatementRecordTotal: 'recordTotal',
		spreadStatementPeriodTotal: 'periodTotal',
		spreadStatementRecord: 'record',
		spreadStatementRecordValue: 'recordValue'
	};
	/**
	 * @deprecated
	 * @param obj
	 * @return {*}
	 */
	IForceUtils.prototype.getChildParentProperty = function (obj) {
		if (!obj || !ko.unwrap(obj.apexType)) {
			return null;
		}

		var property = this.getPropertyForType(ko.unwrap(obj.apexType));
		var custom = IForceUtils._childParentPropertyMap[property];
		if (custom) {
			return custom;
		}

		return property;
	};

	/**
	 * @deprecated
	 * @private
	 */
	IForceUtils._parentPropertyMap = {
		spreadStatement: 'bundle',
		spreadStatementPeriod: 'statement',
		spreadStatementRecordTotal: 'statement',
		spreadStatementPeriodTotal: 'recordTotal',
		spreadStatementRecord: 'recordTotal',
		spreadStatementRecordValue: 'record'
	};
	/**
	 * @deprecated
	 * @param obj
	 * @return {*}
	 */
	IForceUtils.prototype.getParentProperty = function (obj) {
		if (!obj || !ko.unwrap(obj.apexType)) {
			return null;
		}

		var property = this.getPropertyForType(ko.unwrap(obj.apexType));
		return IForceUtils._parentPropertyMap[property];
	};

	/**
	 * Formats a percentage for use in the cache download display.
	 *
	 * @param {number} value
	 * @param {number} decimal
	 * @return {string}
	 */
	IForceUtils.prototype.formatPercentageForDisplay = function (value, decimal) {
		if (typeof decimal == 'undefined') {
			decimal = 2;
		}

		if (!_.isUndefined(value) && !isNaN(value)) {
			var iValue = (Math.abs(value) * 100).toFixed(decimal);
			return value < 0 ? '(' + iValue + ')' : iValue;
		}

		return '' + 0.00;
	};

	/**
	 * Formats number of seconds into mm:ss
	 *
	 * @param {number} seconds
	 * @return {string}
	 */
	IForceUtils.prototype.formatETAForDisplay = function (seconds) {
		if (isNaN(seconds)) {
			return seconds;
		}

		var minutes = Math.floor(seconds / 60);
		var secondsLeftover = seconds % 60;
		var str = '';
		if (minutes > 0) {
			str += minutes.toFixed(0) + 'm ';
		}

		str += secondsLeftover.toFixed(0);
		if (!secondsLeftover) {
			str += '0';
		}

		str += 's';

		return str;
	};

	/**
	 * Injects a model registration catcher into the RegistrationApp
	 * @static
	 * @method
	 * @param {LifeCycleApp} _targetApp
	 * @private
	 */
	IForceUtils._registerModelCatchall = function (_targetApp) {
		// Keep unmodified copy of each set of models registered globally on this app
		if (!window.LifeCycle) {
			throw 'LifeCycle App Not Defined';
		}

		if (!LifeCycle.RegistrationApp) {
			console.error('Can\'t create model registration catch-all for Cache without RegistrationApp');
			return;
		}

		var _registerModels = LifeCycle.RegistrationApp.registerModels;
		LifeCycle.RegistrationApp.registerModels = function (appId, callback) {
			_registerModels(appId, callback);

			var existingAppPropertyValues = {};
			for (var prop in _targetApp) {
				if (_targetApp.hasOwnProperty(prop)) {
					existingAppPropertyValues[prop] = _targetApp[prop];
				}
			}

			var existingAppMappings = {};
			for (var mappingProp in _targetApp.mapping) {
				if (_targetApp.mapping.hasOwnProperty(mappingProp)) {
					existingAppMappings[mappingProp] = _targetApp.mapping[mappingProp];
				}
			}

			if (callback) {
				callback(null, _targetApp);
			}

			function _createHandler (old) {
				if (old.__injected) {
					return old;
				}

				var fun = function (options) {
					if (options) {
						if (options.data && typeof options.data == 'object') {
							return old.apply(old, arguments);
						} else {
							return ko.observable(options.data);
						}
					} else {
						return ko.observable();
					}
				};

				fun.__injected = true;
				if (IForceUtils.ORIGINAL_FUNCTION) {
					fun[IForceUtils.ORIGINAL_FUNCTION] = old;
				}

				return fun;
			}

			for (var mappingKey in _targetApp.mapping) {
				if (_targetApp.mapping.hasOwnProperty(mappingKey)) {
					var mapping = _targetApp.mapping[mappingKey];
					if (typeof mapping.create == 'function' && !mapping.create.__injected) {
						mapping.create = _createHandler(mapping.create);
					}

					if (typeof mapping.update == 'function' && !mapping.update.__injected) {
						mapping.update = _createHandler(mapping.update);
					}
				}
			}

			for (var oldProp in existingAppPropertyValues) {
				if (existingAppPropertyValues.hasOwnProperty(oldProp)) {
					var _oldVal = existingAppPropertyValues[oldProp];
					var _newVal = _targetApp[oldProp];

					if (!_oldVal) {
						_oldVal = '';
					}

					if (!_newVal) {
						_newVal = '';
					}

					if (
						_oldVal.toString().replace(/\s/g, '').toLowerCase() !=
						_newVal.toString().replace(/\s/g, '').toLowerCase()
					) {
						console.warn(
							'IForceCache: Potential KO mapping collision. Model: this.app.' +
							oldProp +
							' may be defined inconsistently'
						);
					}
				}
			}

			for (var oldMappingProp in existingAppMappings) {
				if (existingAppMappings.hasOwnProperty(oldMappingProp)) {
					var _oldPropVal = existingAppMappings[oldMappingProp];
					var _newPropVal = _targetApp.mapping[oldMappingProp];

					if (_oldPropVal instanceof Array || _newPropVal instanceof Array) {
						continue;
					}

					if (!_oldPropVal || typeof _oldPropVal != 'object') {
						_oldPropVal = {};
					}

					if (!_newPropVal || typeof _newPropVal != 'object') {
						_newPropVal = {};
					}

					for (var mapperKey in _oldPropVal) {
						if (_oldPropVal.hasOwnProperty(mapperKey)) {
							var oldMapper = _oldPropVal[mapperKey];
							var newMapper = _newPropVal[mapperKey];

							if (!oldMapper) {
								oldMapper = '';
							}

							if (!newMapper) {
								newMapper = '';
							}

							if (oldMapper.__original) {
								oldMapper = oldMapper.__original;
							}

							if (newMapper.__original) {
								newMapper = newMapper.__original;
							}

							if (
								oldMapper.toString().replace(/\s/g, '').toLowerCase() !=
								newMapper.toString().replace(/\s/g, '').toLowerCase()
							) {
								console.warn(
									'IForceCache: Potential KO mapping collision. Property Mapping: \'' +
									oldMappingProp + '\': {' +
									' \'' + mapperKey + '\': ... ' +
									'} may be defined inconsistently'
								);
							}
						}
					}
				}
			}
		};
	};

	if ('Symbol' in window) {
		IForceUtils.ORIGINAL_FUNCTION = Symbol('OG Function');
	}

	if (!LifeCycle.IForceData) {
		LifeCycle.IForceData = {};
	}

	LifeCycle.IForceData.IForceUtils = LifeCycle.IForceData.IForceUtils || IForceUtils;
})();
(function () {
	/**
	 * @param app
	 * @param utils
	 * @constructor
	 * @class LiteForceUtils
	 */
	var LiteForceUtils = function (app, utils) {
		this.app = app;
		this.utils = utils;
	};

	/**
	 * @interface ISObjectContainer
	 * aka LiteForce. Intermediate format in between server-side sObjects and client-side IForces.
	 * Contains the sObject as well as some accompanying metadata required for mapping.
	 *
	 * @property {SObject} obj
	 * @property {String} type
	 * @property {Object<String, Array<String>>} relationshipProperties
	 */

	/**
	 * Performs mapFromDb on multiple objects.
	 * @param {Array<ISObjectContainer>} sObjectContainers
	 * @return {Array<IForceJS>}
	 */
	LiteForceUtils.prototype.translateLiteForces = function (sObjectContainers) {
		var jsForces = [];

		for (var i = 0; i < sObjectContainers.length; i++) {
			/**
			 * @type ISObjectContainer
			 */
			var jsForce = this.mapFromDb(sObjectContainers[i]);
			if (!jsForce) {
				continue;
			}

			jsForces.push(jsForce);
		}

		return jsForces;
	};

	/**
	 * AForce.mapFromDb equivalent for LiteForces
	 *
	 * @param {ISObjectContainer} sObjectContainer - The raw LiteForce / SObjectContainer
	 * @return {IForceJS} a mapped IForce-compatible JSON object
	 */
	LiteForceUtils.prototype.mapFromDb = function (sObjectContainer) {
		if (!sObjectContainer) {
			return null;
		}

		var sObjectType = sObjectContainer.type;

		var apexType = this.getApexTypeForSObjectType(sObjectType);
		if (!apexType) {
			console.error('Unknown type: ' + sObjectType);
			return null;
		}

		var objectMappingNamespace = this.getNamespace(this.getSObjectTypeForApexType(apexType));
		var translatedProperties = (LiteForceUtils.sObjectFieldTranslations[this.stripNamespace(apexType)] || {});
		var renameProperties = _.union(
			LiteForceUtils.COMMON_MAPPING._renameProperties,
			(translatedProperties._renameProperties || [])
		);
		var jsToSObjectRenames = {};
		for (var i = 0; i < renameProperties.length; i++) {
			var renamePair = renameProperties[i];
			jsToSObjectRenames[renamePair.js] = renamePair.sObject;
		}

		var sObject = sObjectContainer.obj;

		/** @type IForceJS */
		var jsForce = {
			apexType: apexType,
			isRelationshipPointer: false
		};

		var strippedSObjectType = this.stripNamespace(sObjectType);
		var relationshipExclusions = LiteForceUtils.sObjectRelationshipExclusions[strippedSObjectType];
		
		var possibleProperties = {};
		for (var field in sObject) {
			if (sObject.hasOwnProperty(field)) {
				var properties = this.getJSPropertyNamesForSObjectField(field, sObjectContainer, apexType, true);
				for (var i = 0; i < properties.length; i++) {
					var property = properties[i];
					possibleProperties[property] = (possibleProperties[property] || []);
					possibleProperties[property].push(field);
				}
			}
		}
		
		for (var jsPropertyName in possibleProperties) {
			if (possibleProperties.hasOwnProperty(jsPropertyName) && !this.shouldOmitJSProperty(apexType, jsPropertyName)) {
				// Choose field for property
				var sObjectField = undefined;
				if (jsToSObjectRenames[jsPropertyName]) {
					sObjectField = jsToSObjectRenames[jsPropertyName];
					
					// Rename properties belong to object namespace unless otherwise specified
					if (objectMappingNamespace && !this.getNamespace(sObjectField) && sObjectField.indexOf('__') != -1) {
						sObjectField = objectMappingNamespace + '__' + sObjectField;
					}
				} else {
					var matches = this.getSObjectFieldNamesForJSProperty(jsPropertyName, sObjectContainer, jsForce);
					if (!matches.length) {
						continue;
					} else if (matches.length == 1) {
						sObjectField = matches[0];
					} else {
						for (var j = 0; j < matches.length; j++) {
							var match = matches[j];
							if (match.indexOf('__') == -1 || this.getNamespace(match) == objectMappingNamespace) {
								sObjectField = match;
								break;
							}
						}
						
						if (!sObjectField) {
							throw new Error(
								'LiteForce Translation: Multiple sObject fields map to the JS property ' + jsPropertyName +
								'. Check the LiteForce mapping for ' + apexType + ' (' + sObjectType + ')'
							);
						}
					}
				}
				
				if (!(sObjectField in sObject)) {
					continue;
				}
				
				// Determine value
				var strippedField = this.stripNamespace(sObjectField);
				var value = undefined;
				if (
					this.isSObjectRelationship(sObjectContainer, sObjectField) &&
					(
						!relationshipExclusions ||
						relationshipExclusions.indexOf(strippedField) == -1
					)
				) {
					var id18 = _18Id(sObject[sObjectField]);
					if (id18 == sObject[sObjectField]) {
						var typeName = this.getApexTypeForSObjectRelationship(sObjectContainer, sObjectField);
						value = this.generateLiteForceRelationshipPointer(id18, typeName);
					} else {
						value = sObject[sObjectField];
					}
				} else {
					value = sObject[sObjectField];
				}
				
				// Set value
				jsForce[jsPropertyName] = value;
				if (value && value.isRelationshipPointer) {
					if (!jsForce.recordId && sObject.Id) {
						jsForce.recordId = sObject.Id;
					}

					this.cacheTargetToSourceRelationship(value, jsForce, jsPropertyName);
				}
			}
		}

		// Null-initialize missing persisted relationships
		for (var k = 0; k < sObjectContainer.relationshipProperties.length; k++) {
			var relationshipField = sObjectContainer.relationshipProperties[k];
			var relationshipPropertyNames = this.getJSPropertyNamesForSObjectField(relationshipField);
			for (var m = 0; m < relationshipPropertyNames.length; m++) {
				var relationshipPropertyName = relationshipPropertyNames[m];
				if (!jsForce[relationshipPropertyName]) {
					jsForce[relationshipPropertyName] = null;
				}
			}
		}
		
		var keepJSProperties = (translatedProperties._keepJSProperties || []);
		for (var k = 0; k < keepJSProperties.length; k++) {
			var keepJSProperty = keepJSProperties[k];
			if (!(keepJSProperty in jsForce)) {
				jsForce[keepJSProperty] = undefined;
			}
		}


		this.applyFromDbTranslations(sObjectContainer, jsForce);

		if (sObject.Id) {
			this._cacheContainer(sObjectContainer);
		}

		return jsForce;
	};

	/**
	 * AForce.mapToDb equivalent for LiteForces
	 * @param {IForceJS} jsForce - The ko.toJS'd IForce JSON object
	 * @returns {ISObjectContainer} a saveLiteForce ready JSON object
	 */
	LiteForceUtils.prototype.mapToDb = function (jsForce) {
		var sObjectContainer;

		var existingContainer = LiteForceUtils.LITEFORCE_CACHE[jsForce.recordId];
		if (existingContainer) {
			sObjectContainer = existingContainer;
		} else {
			sObjectContainer = {
				type: null,
				obj: {},
				relationshipProperties: {}
			};

			sObjectContainer.type = this.getSObjectTypeForApexType(jsForce.apexType);
		}

		var mappedProperties = {};
		var translatedProperties = this.getLiteForceMappingForApexType(jsForce.apexType);
		for (var jsPropertyName in jsForce) {
			if (jsForce.hasOwnProperty(jsPropertyName)) {
				if (
					LiteForceUtils.jsOnlyProperties.indexOf(jsPropertyName) != -1 ||
					(
						// client-side fields should not be sent back
						translatedProperties[jsPropertyName] &&
						(
							translatedProperties._keepJSProperties.indexOf(jsPropertyName) === -1 ||
							!translatedProperties._renameProperties.some(function (x) { return x.js === jsPropertyName; })
						)
					)
				) {
					continue;
				}

				var value = jsForce[jsPropertyName];
				if (value && typeof value == 'object') {
					if (value.apexType && value.recordId) {
						value = value.recordId;
					} else {
						continue;
					}
				}

				var sObjectFields = this.getSObjectFieldNamesForJSProperty(jsPropertyName, existingContainer, jsForce);
				for (var i = 0; i < sObjectFields.length; i++) {
					var sObjectField = sObjectFields[i];
					if (this.shouldOmitSObjectField(jsForce.apexType, sObjectField)) {
						continue;
					}

					if (mappedProperties[sObjectField] && mappedProperties[sObjectField] != jsPropertyName) {
						throw new Error(
							'LiteForce Translation: Multiple JS properties map to the sObject field ' + jsPropertyName +
							'. Check the LiteForce mapping for ' + jsForce.apexType
						);
					}

					mappedProperties[sObjectField] = jsPropertyName;
					sObjectContainer.obj[sObjectField] = value === undefined ? null : value;
				}
			}
		}

		this.applyToDbTranslations(sObjectContainer, jsForce);

		return sObjectContainer;
	};

	/**
	 * @private
	 * @param {ISObjectContainer} sObjectContainer
	 */
	LiteForceUtils.prototype._cacheContainer = function (sObjectContainer) {
		var sObject = sObjectContainer.obj;
		var data = (LiteForceUtils.LITEFORCE_CACHE[sObject.Id] || (LiteForceUtils.LITEFORCE_CACHE[sObject.Id] = {
			obj: {},
			type: sObjectContainer.type,
			relationshipProperties: {}
		}));

		_.extend(data.obj, sObject);
		_.extend(data.relationshipProperties, sObjectContainer.relationshipProperties);
	};
	/**
	 * Returns the JS-sObject field translations for the object type
	 * @param {string} apexType
	 * @return {LiteForceMapping}
	 */
	LiteForceUtils.prototype.getLiteForceMappingForApexType = function (apexType) {
		return (LiteForceUtils.sObjectFieldTranslations[this.stripNamespace(apexType)] || {});
	};

	/**
	 * Checks whether the first item in the array is a LiteForce
	 * @param {Array<(ISObjectContainer|IForceJS)>} results
	 * @return {boolean}
	 */
	LiteForceUtils.prototype.hasLiteForces = function (results) {
		return (
			results instanceof Array &&
			results.length &&
			results[0].obj &&
			results[0].type
		);
	};

	LiteForceUtils.sObjectNamespaceCache = {
		Screen_Section__c: [],
		Widget__c: []
	};

	/**
	 * Helps keep track of the intended namespace for client-side created objects
	 * @param {string} sObjectType
	 */
	LiteForceUtils.prototype.cacheSObjectNamespace = function (sObjectType) {
		var namespace = this.getNamespace(sObjectType);
		var namespaceCache = LiteForceUtils.sObjectNamespaceCache[this.stripNamespace(sObjectType)];
		if (!namespaceCache) {
			LiteForceUtils.sObjectNamespaceCache[this.stripNamespace(sObjectType)] = [namespace];
		} else if (namespaceCache.indexOf(namespace) == -1) {
			namespaceCache.push(namespace);
		}
	};

	/**
	 * @interface SObject
	 * Generic client-side sObject interface.
	 * @property {string} Id
	 * @property {string} Name
	 */

	/**
	 * Get LifeCycle Apex Class Name for sObject Type
	 *
	 * @param {string} sObjectType - Namespaced, or Un-Namespaced sObject Type
	 * @return {(string|undefined)} - Fully namespaced LifeCycle Apex type for sObject type
	 */
	LiteForceUtils.prototype.getApexTypeForSObjectType = function (sObjectType) {
		this.cacheSObjectNamespace(sObjectType);
		var type = this.stripNamespace(sObjectType);

		var apexType;
		var fqSObjectTypes = [];
		for (var fqSObjectType in LiteForceUtils.sObjectTypeMapping) {
			if (LiteForceUtils.sObjectTypeMapping.hasOwnProperty(fqSObjectType) && this.stripNamespace(fqSObjectType) == type) {
				fqSObjectTypes.push(fqSObjectType);
			}
		}

		if (fqSObjectTypes.length > 1 && this.stripNamespace(sObjectType) != sObjectType) {
			fqSObjectTypes[0] = fqSObjectTypes.filter(function (fqSObjectType) {
				return fqSObjectType == sObjectType;
			})[0];
		}

		if (!apexType) {
			apexType = LiteForceUtils.sObjectTypeMapping[fqSObjectTypes[0]];
		}

		if (!apexType) {
			apexType = this.stripNamespace(sObjectType).split('__').shift();
			var separates = apexType.split('_');

			apexType = 'c.';
			for (var i = 0; i < separates.length; i++) {
				var part = separates[i];
				apexType += part.charAt(0).toUpperCase() + part.substring(1);
			}
		}

		return apexType;
	};

	/**
	 * Returns the first matching sObject type (un-namespaced) for an Apex type.
	 * Will check for exact matches first (with c. or any other namespace) followed by a namespaceless comparison.
	 *
	 * @param {string} apexType
	 * @returns {string} the sObject type
	 */
	LiteForceUtils.prototype.getSObjectTypeForApexType = function (apexType) {
		for (var key in LiteForceUtils.sObjectTypeMapping) {
			if (LiteForceUtils.sObjectTypeMapping.hasOwnProperty(key)) {
				var value = LiteForceUtils.sObjectTypeMapping[key];
				if (value == apexType) {
					return key;
				}
			}
		}

		for (var key2 in LiteForceUtils.sObjectTypeMapping) {
			if (LiteForceUtils.sObjectTypeMapping.hasOwnProperty(key2)) {
				var value2 = LiteForceUtils.sObjectTypeMapping[key2];
				if (this.stripNamespace(value2) == this.stripNamespace(apexType)) {
					return key2;
				}
			}
		}

		var sObjectType = this.stripNamespace(apexType);
		var separates = sObjectType.split(/(?=[A-Z])/);

		sObjectType = '';
		for (var j = 0; j < separates.length; j++) {
			var part = separates[j];
			sObjectType += part.charAt(0).toUpperCase() + part.substring(1) + '_';
		}

		if (this.getNamespace(apexType) && this.getNamespace(apexType) != 'c') {
			sObjectType = this.getNamespace(apexType) + '__' + sObjectType;
		}

		return sObjectType + '_c';
	};

	LiteForceUtils.prototype.getNamespacedSObjectField = function (sObject, unNamespacedFieldName) {
		var match;
		if (unNamespacedFieldName in sObject) {
			return sObject[unNamespacedFieldName];
		}

		for (var field in sObject) {
			if (sObject.hasOwnProperty(field)) {
				if (this.stripNamespace(field) == unNamespacedFieldName) {
					if (match) {
						throw new Error(
							'LiteForce sObject field name collision. ' + unNamespacedFieldName +
							' corresponds to both ' + match + ' and ' + field + '. ' +
							'getNamespacedSObjectField can not be used with ' + unNamespacedFieldName + '. ' +
							'Alternatively, iterate over the sObject fields explicitly'
						);
					}

					match = field;
				}
			}
		}

		return sObject[match];
	};

	/**
	 * Returns an un-namespaced thing. Either by __ or .
	 *
	 * @param {string} thingName
	 * @return {string}
	 */
	LiteForceUtils.prototype.stripNamespace = function (thingName) {
		var existing = this.strippedNamespaceCache[thingName];
		if (existing) {
			return existing;
		}

		if (typeof thingName != 'string') {
			return thingName;
		}

		var originalName = thingName;
		var fieldPieces;
		if (thingName.indexOf('__') != -1) {
			fieldPieces = thingName.split('__');
			if (fieldPieces.length == 3) {
				thingName = fieldPieces.slice(1).join('__');
			}
		} else if (thingName.indexOf('.') != -1) {
			fieldPieces = thingName.split('.');
			if (fieldPieces.length >= 2) {
				thingName = fieldPieces.slice(1).join('.');
			}
		}

		this.strippedNamespaceCache[originalName] = thingName;
		return thingName;
	};

	LiteForceUtils.prototype.strippedNamespaceCache = {};

	/**
	 * Returns the namespace of a thing. Either by __ or .
	 *
	 * @param {string} thingName
	 * @return {string}
	 */
	LiteForceUtils.prototype.getNamespace = function (thingName) {
		var fieldPieces;
		if (thingName.indexOf('__') != -1) {
			fieldPieces = thingName.split('__');
			if (fieldPieces.length == 3) {
				return fieldPieces[0];
			} else {
				return '';
			}
		} else if (thingName.indexOf('.') != -1) {
			fieldPieces = thingName.split('.');
			if (fieldPieces.length >= 2) {
				return fieldPieces[0];
			} else {
				return '';
			}
		}
	};

	/**
	 * Returns a comparable for a field name based on whether or not the Type Mapping for the SObjectType is namespaced
	 * or not
	 * @param fieldName
	 * @param objectMappingNamespace
	 * @return {*}
	 */
	LiteForceUtils.prototype.getFieldMatcher = function (fieldName, objectMappingNamespace) {
		if (objectMappingNamespace) {
			return fieldName;
		}

		return this.stripNamespace(fieldName);
	};


	/**
	 * Returns whether a potentially un-namespaced field name can be considered a match for a field.
	 *
	 * @param testField
	 * @param fieldName
	 * @param objectMappingNamespace
	 * @return {boolean}
	 */
	LiteForceUtils.prototype.isField = function (testField, fieldName, objectMappingNamespace) {
		if (objectMappingNamespace || this.isNamespacedName(testField)) {
			return testField == fieldName;
		}

		return testField == this.stripNamespace(fieldName);
	};

	/**
	 * Returns a comparable for a field name based on whether or not the Type Mapping for the SObjectType is namespaced or not
	 * @param fieldName
	 * @param mappingSObjectType
	 * @return {*}
	 */
	LiteForceUtils.prototype.getFieldMatcher = function (fieldName, mappingSObjectType) {
		if (mappingSObjectType) {
			return fieldName;
		}
		
		return this.stripNamespace(fieldName);
	};
	
	/**
	 * Get the JS property name for the sObject's field name
	 *
	 * @param {string} field
	 * @param {ISObjectContainer} sObjectContainer
	 * @param {string} [apexType]
	 * @param {boolean} [disableCollisionDetect] Optionally, do not attempt to prevent collisions by returning empty results
	 * @return {Array<string>}
	 */
	LiteForceUtils.prototype.getJSPropertyNamesForSObjectField = function (field, sObjectContainer, apexType, disableCollisionDetect) {
		var apexType = (apexType || this.getApexTypeForSObjectType(sObjectContainer.type));
		var objectMappingNamespace = this.getNamespace(this.getSObjectTypeForApexType(apexType));
		var translatedProperties = (LiteForceUtils.sObjectFieldTranslations[this.stripNamespace(apexType)] || {});
		var renameMatches = [];
		var renameProperties = _.union(
			(translatedProperties._renameProperties || []),
			LiteForceUtils.COMMON_MAPPING._renameProperties
		);
		for (var i = 0; i < renameProperties.length; i++) {
			var renamePair = renameProperties[i];
			var sObjectTest = renamePair.sObject;

			if (objectMappingNamespace && !this.getNamespace(sObjectTest) && sObjectTest.indexOf('__') != -1) {
				sObjectTest = objectMappingNamespace + '__' + sObjectTest;
			}

			if (!disableCollisionDetect && this.stripNamespace(sObjectTest) == this.stripNamespace(field)) {
				if (!this.isField(sObjectTest, field, objectMappingNamespace)) {
					continue;
				}
			}

			if (sObjectTest == field || sObjectTest == this.getFieldMatcher(field, objectMappingNamespace)) {
				renameMatches.push(renamePair.js);
			}
		}

		if (renameMatches.length) {
			return renameMatches;
		}


		if (!disableCollisionDetect && objectMappingNamespace && field.indexOf('__c') != -1 && objectMappingNamespace != this.getNamespace(field)) {
			return [];
		}

		var jsPropertyName = this.stripNamespace(field).split('__').shift();
		var separates = jsPropertyName.split('_');

		jsPropertyName = '';
		for (var i = 0; i < separates.length; i++) {
			var part = separates[i];
			jsPropertyName += part.charAt(0).toUpperCase() + part.substring(1);
		}

		return [jsPropertyName.charAt(0).toLowerCase() + jsPropertyName.substring(1)];
	};

	/**
	 * Get the sObject field name for the JS object's property name
	 *
	 * @param {string} property - IForceJS property name
	 * @param {ISObjectContainer} [sObjectContainer] - Optional original sObjectContainer to get exact field name
	 * @param {IForceJS} jsForce - The non-KO JS IForce
	 * @return {Array<string>} sObject field name (un-namespaced if sObject container is omitted)
	 */
	LiteForceUtils.prototype.getSObjectFieldNamesForJSProperty = function (property, sObjectContainer, jsForce) {
		switch (property) {
			case 'recordId':
				return ['Id'];
			case 'name':
				return ['Name'];
			default:
		}

		if (sObjectContainer) {
			var existingFields = [];
			for (var existingField in sObjectContainer.obj) {
				if (sObjectContainer.obj.hasOwnProperty(existingField)) {
					var transformedNames = this.getJSPropertyNamesForSObjectField(existingField, sObjectContainer);
					if (!transformedNames.length) {
						transformedNames = this.getJSPropertyNamesForSObjectField(existingField, sObjectContainer, undefined, true);
					}

					if (transformedNames.indexOf(property) != -1) {
						existingFields.push(existingField);
					}
				}
			}

			if (existingFields.length) {
				return existingFields;
			}
		}

		var apexType = jsForce.apexType;
		var sObjectType = this.getSObjectTypeForApexType(apexType);
		var objectNamespace = this.getNamespace(sObjectType);
		var translatedProperties = (LiteForceUtils.sObjectFieldTranslations[this.stripNamespace(apexType)] || {});
		var renameMatches = [];
		var renameProperties = _.union(
			(translatedProperties._renameProperties || []),
			LiteForceUtils.COMMON_MAPPING._renameProperties
		);

		for (var i = 0; i < renameProperties.length; i++) {
			var renamePair = renameProperties[i];
			if (renamePair.js == property) {
				renameMatches.push(renamePair.sObject);
			}
		}

		if (renameMatches.length) {
			return renameMatches;
		}

		var sObjectField = this.stripNamespace(property);
		var separates = sObjectField.split(/(?=[A-Z])/);

		sObjectField = '';
		for (var j = 0; j < separates.length; j++) {
			var part = separates[j];
			sObjectField += part.charAt(0).toUpperCase() + part.substring(1) + '_';
		}

		return [sObjectField + '_c'];
	};

	/**
	 * Apply mapFromDb logic client-side
	 *
	 * @param {ISObjectContainer} sObjectContainer
	 * @param {IForceJS} jsForce
	 */
	LiteForceUtils.prototype.applyFromDbTranslations = function (sObjectContainer, jsForce) {
		var apexType = this.utils.getApexType(this.getApexTypeForSObjectType(sObjectContainer.type));
		var translatedProperties = LiteForceUtils.sObjectFieldTranslations[this.stripNamespace(apexType)];
		if (translatedProperties) {

			this.addMappingUtilities(sObjectContainer.obj);
			for (var translatedProperty in translatedProperties) {
				if (
					translatedProperties.hasOwnProperty(translatedProperty) &&
					translatedProperty != '_deleteJSProperties' &&
					translatedProperty != '_deleteSObjectFields' &&
					translatedProperty != '_targetToSourceRelationships' &&
					translatedProperty != '_renameProperties' &&
					translatedProperty != '_keepJSProperties' &&
					translatedProperty != '_keepSObjectFields'
				) {
					var translator = translatedProperties[translatedProperty];
					if (translatedProperty.charAt(0) != translatedProperty.toLowerCase().charAt(0)) {
						// not a fromDb translation
						continue;
					}

					if (typeof translator != 'function') {
						console.error('SObject to JS Translator (' + translatedProperty + ') must be a function');
						continue;
					}

					jsForce[translatedProperty] = translator(sObjectContainer.obj, this);
				}
			}

			this.removeMappingUtilities(sObjectContainer.obj);
		}
	};

	/**
	 * Apply mapToDb logic client-side
	 *
	 * @param {ISObjectContainer} sObjectContainer
	 * @param {IForceJS} jsForce
	 */
	LiteForceUtils.prototype.applyToDbTranslations = function (sObjectContainer, jsForce) {
		var apexType = jsForce.apexType;
		var translatedProperties = LiteForceUtils.sObjectFieldTranslations[this.stripNamespace(apexType)];
		if (translatedProperties) {
			for (var translatedProperty in translatedProperties) {
				if (
					translatedProperties.hasOwnProperty(translatedProperty) &&
					translatedProperty != '_deleteJSProperties' &&
					translatedProperty != '_deleteSObjectFields' &&
					translatedProperty != '_targetToSourceRelationships' &&
					translatedProperty != '_renameProperties' &&
					translatedProperty != '_keepJSProperties' &&
					translatedProperty != '_keepSObjectFields'
				) {
					var translator = translatedProperties[translatedProperty] || translatedProperties[this.stripNamespace(translatedProperty)];
					if (translatedProperty.charAt(0) != translatedProperty.toUpperCase().charAt(0)) {
						// not a toDb translation
						continue;
					}

					if (typeof translator != 'function') {
						console.error('JS to SObject Translator (' + translatedProperty + ') must be a function');
						continue;
					}

					sObjectContainer.obj[translatedProperty] = translator(jsForce, this);
				}
			}
		}
	};

	/**
	 *
	 * @param {ISObjectContainer} sObjectContainer
	 * @param {string} sObjectField
	 * @return {boolean}
	 */
	LiteForceUtils.prototype.isSObjectRelationship = function (sObjectContainer, sObjectField) {
		var relationshipName = sObjectField.replace('__c', '__r');
		return sObjectContainer.relationshipProperties[relationshipName];
	};

	/**
	 *
	 * @param {ISObjectContainer} sObjectContainer
	 * @param {string} sObjectField
	 * @return {string}
	 */
	LiteForceUtils.prototype.getApexTypeForSObjectRelationship = function (sObjectContainer, sObjectField) {
		var relationshipName = sObjectField.replace('__c', '__r');
		var relationshipSObjectTypes = sObjectContainer.relationshipProperties[relationshipName];
		var typeName = null;

		if (relationshipSObjectTypes && relationshipSObjectTypes.length) {
			var i = 0;
			do {
				var sObjectType = relationshipSObjectTypes[i];
				typeName = this.getApexTypeForSObjectType(sObjectType);
				i++;
			} while (!typeName && i < relationshipSObjectTypes.length);
		}

		return typeName;
	};

	/**
	 * Keep track of the target-to-source edge to auto-generate the target-to-source direction later
	 *
	 * @param {IForceJS} target - The one of the one-to-many
	 * @param {IForceJS} source - A many of the one-to-many
	 * @param {string} sourceToTargetPropertyName - the name of the relationship property pointing from a many to the
	 *     one
	 */
	LiteForceUtils.prototype.cacheTargetToSourceRelationship = function (target, source, sourceToTargetPropertyName) {
		if (!target.recordId || !source.recordId) {
			return;
		}

		var targetInfo = LiteForceUtils.RELATIONSHIP_CACHE[target.recordId];
		if (!targetInfo) {
			targetInfo = LiteForceUtils.RELATIONSHIP_CACHE[target.recordId] = {};
		}

		var targetToSourcePropertyName = this.getTargetToSourcePropertyName(target.apexType, source.apexType, sourceToTargetPropertyName);
		if (!targetToSourcePropertyName) {
			return;
		}

		var relationship = this.getTargetToSourceRelationshipMetadata(target.apexType, targetToSourcePropertyName);
		if (!relationship) {
			return;
		}

		var relatedIds = targetInfo[targetToSourcePropertyName];
		if (relationship.isOneToOne) {
			targetInfo[targetToSourcePropertyName] = source.recordId;
		} else {
			if (!Array.isArray(relatedIds)) {
				relatedIds = targetInfo[targetToSourcePropertyName] = [];
			}

			if (relatedIds.indexOf(source.recordId) == -1) {
				relatedIds.push(source.recordId);
			}
		}
	};

	/**
	 * Remove a target-to-source edge
	 *
	 * @param {IForceJS} target - The one of the one-to-many
	 * @param {IForceJS} source - A many of the one-to-many
	 * @param {string} sourceToTargetPropertyName - the name of the relationship property pointing from a many to the
	 *     one
	 */
	LiteForceUtils.prototype.uncacheTargetToSourceRelationship = function (target, source, sourceToTargetPropertyName) {
		if (!target.recordId || !source.recordId) {
			return;
		}

		var targetInfo = LiteForceUtils.RELATIONSHIP_CACHE[target.recordId];
		if (!targetInfo) {
			targetInfo = LiteForceUtils.RELATIONSHIP_CACHE[target.recordId] = {};
		}

		var targetToSourcePropertyName = this.getTargetToSourcePropertyName(target.apexType, source.apexType, sourceToTargetPropertyName);
		if (!targetToSourcePropertyName) {
			return;
		}

		var relationship = this.getTargetToSourceRelationshipMetadata(target.apexType, targetToSourcePropertyName);
		if (!relationship) {
			return;
		}

		var relatedIds = targetInfo[targetToSourcePropertyName];
		if (relationship.isOneToOne && targetInfo[targetToSourcePropertyName] == source.recordId) {
			targetInfo[targetToSourcePropertyName] = null;
		} else if (Array.isArray(relatedIds)) {
			var index = relatedIds.indexOf(source.recordId);
			if (index != -1) {
				relatedIds.splice(index, 1);
			}
		}
	};

	/**
	 * Determine the name of the property where the array of many lives on the one.
	 * Uses the relationship mappings in the type mapping, or attempts to guess based on naming conventions.
	 *
	 * @param {string} targetApexType - The apex type of the one of the one-to-many
	 * @param {string} sourceApexType - The apex type of a many of the one-to-many
	 * @param {string} sourceToTargetPropertyName - the name of the relationship property pointing from a many to the
	 *     one
	 * @return {string}
	 */
	LiteForceUtils.prototype.getTargetToSourcePropertyName = function (targetApexType, sourceApexType, sourceToTargetPropertyName) {
		targetApexType = this.stripNamespace(targetApexType);
		sourceApexType = this.stripNamespace(sourceApexType);

		var cacheHash = targetApexType + ' <- ' + sourceApexType + '.' + sourceToTargetPropertyName;
		if (this.targetToSourcePropertyNameCache[cacheHash]) {
			return this.targetToSourcePropertyNameCache[cacheHash];
		}

		var mapping = LiteForceUtils.sObjectFieldTranslations[targetApexType];
		if (!mapping || !mapping._targetToSourceRelationships) {
			return null;
		} else {
			var relationships = mapping._targetToSourceRelationships;
			for (var i = 0; i < relationships.length; i++) {
				var relationship = relationships[i];
				var sourceSObjectType = relationship.sourceType;
				var mappingSourceApexType = this.stripNamespace(this.getApexTypeForSObjectType(sourceSObjectType));

				if (mappingSourceApexType != sourceApexType) {
					continue;
				}

				var mappingSourceToTargetFieldName = relationship.sourceToTargetFieldName;
				var mappingSourceToTargetProperties = this.getJSPropertyNamesForSObjectField(
					mappingSourceToTargetFieldName,
					null,
					sourceApexType
				);

				if (
					mappingSourceToTargetProperties.length == 1 &&
					mappingSourceToTargetProperties[0] == sourceToTargetPropertyName
				) {
					this.targetToSourcePropertyNameCache[cacheHash] = relationship.targetToSourcePropertyName;
				} else if (mappingSourceToTargetProperties.length > 1) {
					console.error(
						'Multiple possible source-to-target relationship names found. Check mapping for ' +
						targetApexType +
						': _targetToSourceRelationships: [{ targetToSourcePropertyName: ' +
						relationship.targetToSourcePropertyName +
						' }]' +
						'. Source type: ' + sourceApexType + '.' + mappingSourceToTargetProperties + ' -> ' + targetApexType
					);

					break;
				}
			}
		}

		return this.targetToSourcePropertyNameCache[cacheHash];
	};
	LiteForceUtils.prototype.targetToSourcePropertyNameCache = {};

	/**
	 * Determine the name of the JS property in a relationship that is the non-persisted side (master or target of
	 * lookup) Uses the relationship mappings in the type mapping
	 *
	 * @param {string} targetApexType - The apex type of the non-persisted side of the relationship
	 * @param {string} sourceApexType - The apex type of the persisted side of the relationship
	 * @param {string} targetToSourcePropertyName - the name of the relationship array/property pointing from the
	 *     target to the source
	 * @return {string}
	 */
	LiteForceUtils.prototype.getSourceToTargetPropertyName = function (targetApexType, sourceApexType, targetToSourcePropertyName) {
		targetApexType = this.stripNamespace(targetApexType);
		sourceApexType = this.stripNamespace(sourceApexType);

		var cacheHash = targetApexType + '.' + targetToSourcePropertyName + ' -> ' + sourceApexType;
		if (this.sourceToTargetPropertyNameCache[cacheHash]) {
			return this.sourceToTargetPropertyNameCache[cacheHash];
		}

		var relationship = this.getTargetToSourceRelationshipMetadata(targetApexType, targetToSourcePropertyName);
		if (!relationship) {
			return null;
		}

		var sourceToTargetFieldName = relationship.sourceToTargetFieldName;
		var mappingSourceToTargetProperty = this.getJSPropertyNamesForSObjectField(
			sourceToTargetFieldName,
			null,
			sourceApexType
		);
		if (mappingSourceToTargetProperty.length == 1) {
			this.sourceToTargetPropertyNameCache[cacheHash] = mappingSourceToTargetProperty[0];
		} else {
			if (mappingSourceToTargetProperty.length > 1) {
				console.error(
					'Multiple possible source-to-target relationship names found. Check mapping for ' +
					targetApexType +
					': _targetToSourceRelationships: [{ targetToSourcePropertyName: ' +
					relationship.targetToSourcePropertyName +
					' }]' +
					'. Source type: ' + sourceApexType + '.' + mappingSourceToTargetProperty + ' -> ' + targetApexType);
			}

			return null;
		}

		return this.sourceToTargetPropertyNameCache[cacheHash];
	};
	LiteForceUtils.prototype.sourceToTargetPropertyNameCache = {};

	/**
	 * Returns all of the one-to-many array metadata for the type
	 * @param {string} targetApexType
	 * @return {object<string, LiteForceTargetToSourceRelationshipMetadata>}
	 */
	LiteForceUtils.prototype.getAllTargetToSourceRelationshipMetadata = function (targetApexType) {
		targetApexType = this.stripNamespace(targetApexType);
		if (this.targetToSourceRelationshipMetadataCache[targetApexType]) {
			return this.targetToSourceRelationshipMetadataCache[targetApexType];
		}

		var mapping = LiteForceUtils.sObjectFieldTranslations[targetApexType];
		if (!mapping || !mapping._targetToSourceRelationships) {
			return null;
		} else {
			this.targetToSourceRelationshipMetadataCache[targetApexType] = (this.targetToSourceRelationshipMetadataCache[targetApexType] || {});

			var relationships = mapping._targetToSourceRelationships;
			for (var i = 0; i < relationships.length; i++) {
				var relationship = relationships[i];
				this.targetToSourceRelationshipMetadataCache[targetApexType][relationship.targetToSourcePropertyName] = relationship;
			}
		}

		return this.targetToSourceRelationshipMetadataCache[targetApexType];
	};
	LiteForceUtils.prototype.targetToSourceRelationshipMetadataCache = {};

	/**
	 *
	 * @param {string} targetApexType
	 * @param {string} relationshipPropertyName
	 * @return {LiteForceTargetToSourceRelationshipMetadata}
	 */
	LiteForceUtils.prototype.getTargetToSourceRelationshipMetadata = function (targetApexType, relationshipPropertyName) {
		var relationships = this.getAllTargetToSourceRelationshipMetadata(targetApexType);
		if (relationships) {
			return relationships[relationshipPropertyName];
		}
	};

	/**
	 * Returns a relationship pointer for use in translating a LiteForce
	 * @param {string} id18
	 * @param {string} typeName
	 * @return {IForceJS}
	 */
	LiteForceUtils.prototype.generateLiteForceRelationshipPointer = function (id18, typeName) {
		return {
			apexType: typeName,
			recordId: id18,
			isRelationshipPointer: true
		};
	};

	/**
	 * Determine whether or not the LiteForceMapping specifies omitting JS properties.
	 *
	 * @param {string} apexType - The JS object's corresponding Apex-ish Type
	 * @param {string} jsPropertyName - The name of the property belonging to the generated JS object
	 * @return {boolean}
	 */
	LiteForceUtils.prototype.shouldOmitJSProperty = function (apexType, jsPropertyName) {
		var translatedProperties = LiteForceUtils.sObjectFieldTranslations[this.stripNamespace(apexType)];
		if (!translatedProperties) {
			return false;
		}

		var deleteProperties = _.union(
			(translatedProperties._deleteJSProperties || []),
			LiteForceUtils.COMMON_MAPPING._deleteJSProperties
		);
		var keepProperties = _.union(
			(translatedProperties._keepJSProperties || []),
			LiteForceUtils.COMMON_MAPPING._keepJSProperties
		);

		if (deleteProperties.indexOf(jsPropertyName) != -1) {
			return true;
		}

		return (
			translatedProperties._keepJSProperties instanceof Array &&
			keepProperties.indexOf(jsPropertyName) == -1
		);
	};

	/**
	 * Determine whether or not the LiteForceMapping specifies omitting sObject fields.
	 *
	 * @param {string} apexType - The JS object's corresponding Apex-ish Type
	 * @param {string} sObjectFieldName - The name of the field belonging to the generated sObject
	 * @return {boolean}
	 */
	LiteForceUtils.prototype.shouldOmitSObjectField = function (apexType, sObjectFieldName) {
		var translatedProperties = LiteForceUtils.sObjectFieldTranslations[this.stripNamespace(apexType)];
		if (!translatedProperties) {
			return false;
		}

		var deleteProperties = _.union(
			(translatedProperties._deleteSObjectFields || []),
			LiteForceUtils.COMMON_MAPPING._deleteSObjectFields
		);
		var keepProperties = _.union(
			(translatedProperties._keepSObjectFields || []),
			LiteForceUtils.COMMON_MAPPING._keepSObjectFields
		);

		if (deleteProperties.indexOf(sObjectFieldName) != -1) {
			return true;
		}

		return (
			translatedProperties._keepSObjectFields instanceof Array &&
			keepProperties.indexOf(sObjectFieldName) == -1
		);
	};

	LiteForceUtils.prototype.addMappingUtilities = function (sObject) {
		var _this = this;
		sObject.get = function (field) { return _this.getNamespacedSObjectField(sObject, field); };
	};

	LiteForceUtils.prototype.removeMappingUtilities = function (sObject) {
		delete sObject.get;
	};

		/**
		 * Returns Boolean whether or not the name of sObject or field is namespaced
		 *
		 * @param {string} name
		 * @return {boolean}
		 */
		LiteForceUtils.prototype.isNamespacedName = function (name) {
				return (name.indexOf('__c') == -1 || name != this.stripNamespace(name));
		};


		/**
		 * Returns Boolean whether or not any of the fields on an object are namespaced
		 *
		 * @param {ISObject} sObject
		 * @return {boolean}
		 */
		LiteForceUtils.prototype.areAllFieldsNamespaced = function (sObject) {
				for (var field in sObject) {
						if (sObject.hasOwnProperty(field) && !this.isNamespacedName(field)) {
										return false;
						}
				}
				return true;
		};

		/**
		 * Returns Boolean if all fields and objectType is namespaced
		 *
		 * @param {ISObjectContainer} sObjectContainer
		 * @return {boolean}
		 */
		LiteForceUtils.prototype.isObjectAndFieldsFullyNamespaced = function (sObjectContainer) {
				return (this.isNamespacedName(sObjectContainer.type) && this.areAllFieldsNamespaced(sObjectContainer.obj));
		};

	/**
	 * Gets all of the current mappedFromDb fields as an object with their parent sObjectTypes as keys
	 *
	 * @param {string} [namespace] Optionally add an arbitrary namespace to all un-namespaced __c fields and types
	 * @return {Object<string, Array<string>>}
	 */
	LiteForceUtils.prototype.getCurrentTypedFieldList = function (namespace) {
		var typeMappings = LiteForceUtils.sObjectTypeMapping;
		var sObjectTypes = Object.keys(typeMappings);

		var typedList = {};

		for (var i = 0; i < sObjectTypes.length; i++) {
			var sObjectType = sObjectTypes[i];
			var apexType = typeMappings[sObjectType];
			var mapping = this.getLiteForceMappingForApexType(apexType);
			if (!mapping || !mapping._keepJSProperties) {
				continue;
			}

			var fields = ['Id', 'Name'];

			var jsForce = {
				apexType: apexType,
				recordId: null,
				name: null
			};

			sObjectContainer = {
				type: apexType,
				obj: jsForce,
				relationshipProperties: {}
			};

			var conjoinedPropertyList = mapping._keepJSProperties.concat(LiteForceUtils.COMMON_MAPPING._keepJSProperties);

			for (var j = 0; j < conjoinedPropertyList.length; j++) {
				this.getSObjectFieldNamesForJSProperty(conjoinedPropertyList[j], sObjectContainer, jsForce).forEach(
					function(fieldName){
						fields.push(fieldName);
					}
				);
			}

			(mapping._keepSObjectFields || []).forEach(function(property){
					fields.push(property);
			});

			if (
				namespace &&
				sObjectType.indexOf('__c') !== -1 &&
				!this.getNamespace(sObjectType)
			) {
				sObjectType = namespace + '__' + sObjectType;
			}
			typedList[sObjectType] = fields;
		}

		return typedList;
	};

	LiteForceUtils.LITEFORCE_CACHE = {};

	LiteForceUtils.RELATIONSHIP_CACHE = {};

	/**
	 * Never map these JS properties back to sObject fields
	 * @type {Array<string>}
	 */
	LiteForceUtils.jsOnlyProperties = [
		'apexType',
		'isRelationshipPointer',
		'lastModifiedDate'
	];

	/**
	 * Base mapping for all objects
	 * @type {LiteForceMapping}
	 */
	LiteForceUtils.COMMON_MAPPING = {
		_renameProperties: [
			{ sObject: 'Id', js: 'recordId' },
			{ sObject: 'lookupKey__c', js: 'lookupKey' },
			{ sObject: 'CreatedById', js: 'createdById' },
			{ sObject: 'CreatedDate', js: 'createdDate' },
			{ sObject: 'CurrencyIsoCode', js: 'currencyIsoCode' },
			{ sObject: 'IsDeleted', js: 'isDeleted' },
			{ sObject: 'LastModifiedById', js: 'lastModifiedById' },
			{ sObject: 'LastModifiedDate', js: 'lastModifiedDate' },
			{ sObject: 'LastReferencedDate', js: 'lastReferencedDate' },
			{ sObject: 'LastViewedDate', js: 'lastViewedDate' },
			{ sObject: 'OwnerId', js: 'ownerId' },
			{ sObject: 'SystemModstamp', js: 'systemModstamp' }
		],
		_deleteSObjectFields: [
			'CreatedById',
			'CreatedDate',
			'IsDeleted',
			'LastModifiedById',
			'LastModifiedDate',
			'LastReferencedDate',
			'LastViewedDate',
			'OwnerId',
			'SystemModstamp',
			'Disabled__c',
			'Is_Loaded__c',
			'Is_Saved__c',
			'Is_L_L_C_B_I__c',
			'Id__c',
			'Saved__c',
			'__placeholder__c'
		],
		_keepSObjectFields: [
			'Id',
			'Name'
		],
		_keepJSProperties: [
			'apexType',
			'currencyIsoCode',
			'name',
			'lookupKey',
			'recordId',
			'isRelationshipPointer',
			'lastModifiedDate'
		]
	};

	/**
	 * Map of un-namespaced sObject Type names to their client side representations (Apex-like names)
	 * If the Apex-like name corresponds to the sObject Type name (after un-underscoring, and camel-casing)
	 * this is not necessary.
	 *
	 * Use namespaces if desired. Can be used to avoid API name collisions. Otherwise namespaces can be inferred.
	 *
	 * For example:
	 * Some_Object__c <> SomeObject would not need a type mapping
	 *
	 * @type {Object<string, string>}
	 */
	LiteForceUtils.sObjectTypeMapping = {
		Account: 'c.LifeCycleAccount',
		nFORCE__Screen_Section__c: 'c.LifeCycleScreenSection',
		nFORCE__Widget__c: 'c.LifeCycleWidget'
	};

	/**
	 * Skip translating these relationships. Do not use namespaces on the object type key
	 *
	 * @type {Object<String, Array<String>>}
	 */
	LiteForceUtils.sObjectRelationshipExclusions = {
		Spread_Statement_Period__c: ['Analyst__c', 'Statement_Id__c']
	};

	/**
	 * @typedef {Object} LiteForceRenameMapping
	 * @property {string} sObject - The Un-Namespaced sObject field name
	 * @property {string} js - The JS property name
	 */

	/**
	 * @typedef {Object} LiteForceMapping
	 * @property {Array<LiteForceRenameMapping>} _renameProperties - Mismatched sObject field - js property names
	 * @property {Array<string>} _deleteJSProperties - Explicitly delete mapped JS properties during mapFromDb
	 * @property {Array<string>} _deleteSObjectFields - Explicitly omit generated sObject fields during mapToDb
	 * @property {Array<string>} _keepJSProperties - If defined, determines the only properties allowed on the js
	 *     object
	 * @property {Array<string>} _keepSObjectFields - If defined, determines the only properties allowed on the sObject
	 * @property {Array<LiteForceTargetToSourceRelationshipMetadata>} _targetToSourceRelationships - Relationships to
	 *     artificially generate on the client side
	 */

	/**
	 * @typedef {Object} LiteForceTargetToSourceRelationshipMetadata
	 * @property {string} targetToSourcePropertyName - Name of the JS relationship property that will be generated
	 *     containing the objects that have the persisted side pointing to this object
	 * @property {string} sourceType - sObject type of the object that has the persisted side of the relationship
	 * @property {string} sourceToTargetFieldName - Persisted sObject relationship field name
	 * @property {boolean} isOneToOne - one-to-one if true, one-to-many if false, determines if a [] or a null will be
	 *     placed on the property
	 */

	/**
	 * Performs 'mapFromDb/mapToDb' like functionality for fields that do not map one-to-one.
	 *
	 * The keys of this Object are the de-namespaced versions of the values of the {@link
	 * LiteForceUtils.sObjectTypeMapping}
	 *
	 * If all field names and types correspond one-to-one between sObject and JS, the mapping can be as simple as:
	 * 		TypeName: {}
	 *
	 * Most sObject Fields can be mapped to and from their IForce equivalent automatically, using de-namespacing,
	 * de-underscoring, and camel-casing (and vice versa for mapToDb).
	 *
	 * _renameProperties can be used if a different name is needed in JS.
	 *
	 * Optionally, include a _deleteJSProperties array to specify properties unneeded after mapping
	 * Or inversely, you can include a _keepJSProperties to filter all other properties before the Knockout mapping
	 * stage The _keepJSProperties array should mirror the JSON property names of the expected IForce.
	 *
	 * Translations should be in the format: (LiteForceMapping)
	 *  {
	 *  	NamespacelessApexType: {
	 *  		javascriptPropertyName: function (sObject, utils) {
	 *  			<map from db logic> // You can use either the 'best guess' JS or the raw sObject to do mapping
	 *  			// TIP: use sObject.get('Namespaced_Or_Unnamespaced_Field_Name__c') to get a reference to the field
	 * you want
	 *  		},
	 *  		Un_Namespaced_SObject_Field_Name__c: function (IForceJS, utils) {
	 *  			<map to db logic> // Use the javascript object to map back to an sObject field
	 * 	 		},
	 *  		_renameProperties: [
	 *  			{ sObject: 'Namespaced_Or_Unnamespaced_Field_Name__c', js: 'desiredJSPropertyName' },
	 *  			...
	 *  		],
	 *			_targetToSourceRelationships: [
	 *				{
	 *					targetToSourcePropertyName: 'relationshipName',
	 *					sourceType: 'Namespaced_Or_Unnamespaced_Type__c',
	 *					sourceToTargetFieldName: 'Namespaced_Or_Unnamespaced_Field__c',
	 *					isOneToOne: false
	 *				}
	 *			],
	 *  		_deleteJSProperties: ['account'], // Will delete any unwanted auto-mapped JS properties
	 *  		_deleteSObjectFields: ['account'], // Will prevent accidental saves on specified sObject fields
	 *  		_keepJSProperties: ['relationship'] // If defined, only these properties will be mapped during
	 * mapFromDb
	 *  		_keepSObjectfields: ['relationship'] // If defined, only these properties will be mapped during mapToDb
	 *  	}
	 *  }
	 *
	 * @type {Object<string, LiteForceMapping>}
	 * @public
	 */
	LiteForceUtils.sObjectFieldTranslations = {
		CovenantMgmt: {
			_renameProperties: [
				{ sObject: 'Next_Evaluation_Date__c', js: 'nextEvalDate' }
			]
		}
	};

	if (!LifeCycle.IForceData) {
		LifeCycle.IForceData = {};
	}

	LifeCycle.IForceData.LiteForceUtils = LifeCycle.IForceData.LiteForceUtils || LiteForceUtils;
})();
