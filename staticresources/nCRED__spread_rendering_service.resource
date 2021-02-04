/**
 * @interface ISpreadsTableUpdate
 * @property {DataTable} table - the jQuery.dataTable instance/selector
 * @property {Array<Array<Object>>} data -  _aoDataMap for an fnRedraw, or null for an fnDraw
 */

/**
 * Render all the things (incrementally)
 *
 * @class
 * @memberOf LifeCycle
 * @param {string} statementId - The spread statement type/template id to be rendered
 * @param {LifeCycle.Comments.App} commentsApp - statement's comments app
 * @param {LifeCycle.SpreadNavigation.App} navApp - statement's navigation app
 * @constructor
 * @returns {SpreadRenderingService}
 */
var SpreadRenderingService = function (statementId, commentsApp, navApp) {
	statementId = _18Id(statementId);
	
	var allIds = SpreadRenderingService._instances.map(function (x) { return x.statementId; });
	var index = allIds.indexOf(statementId);
	if (index != -1) {
		return SpreadRenderingService._instances[index];
	}
	
	
	this.statementId = statementId;
	this.loadTime = null;
	this.renderTime = null;
	this.totalTime = null;
	
	/**
	 * @type {SpreadRenderingMode}
	 * @private
	 */
	this._renderMode = SpreadRenderingService.RENDER_MODE.DEFERRED;
	
	/**
	 *
	 * @type {(null|number)}
	 * @private
	 */
	this._deferTimeout = null;
	
	/**
	 *
	 * @type {Object<string, ISpreadsTableUpdate>} Collection of tables that need an fnRedraw after rendering is enabled
	 * @private
	 */
	this._queuedRedraws = {};
	
	SpreadRenderingService._instances.push(this);
	SpreadRenderingService._addScrollSubscriptions();
	
	/**
	 * @type {LifeCycle.Comments.App}
	 */
	this._commentsApp = commentsApp;
	
	/**
	 * @type {LifeCycle.SpreadNavigation.App}
	 */
	this._navApp = navApp;
};

/**
 * Process all draw requests immediately
 */
//noinspection JSUnusedGlobalSymbols
SpreadRenderingService.prototype.enableRendering = function () {
	this._renderMode = SpreadRenderingService.RENDER_MODE.IMMEDIATE;
};

/**
 * Process all in-view draw requests immediately, and queue the others
 */
SpreadRenderingService.prototype.deferHiddenRendering = function () {
	this._renderMode = SpreadRenderingService.RENDER_MODE.IN_VIEWPORT_ONLY;
};

/**
 * Do not process any draw requests until renderAll is called
 */
SpreadRenderingService.prototype.deferAllRendering = function () {
	this._renderMode = SpreadRenderingService.RENDER_MODE.DEFERRED;
};

/**
 * Start (or restart) deferring all draws
 *
 * @param {number} milliseconds - Time in milliseconds to defer drawing for
 * @param {string} [nextMode = SpreadRenderingService.RENDER_MODE.IN_VIEWPORT_ONLY] -
 * Mode to change to after timer expires
 */
SpreadRenderingService.prototype.startDeferredRenderingTimer = function (milliseconds, nextMode) {
	if (this._deferTimeout) {
		clearTimeout(this._deferTimeout);
	}
	
	this.deferAllRendering();
	
	if (!nextMode) {
		nextMode = SpreadRenderingService.RENDER_MODE.IN_VIEWPORT_ONLY;
	}
	
	var that = this;
	this._deferTimeout = setTimeout(function () {
		that._renderMode = nextMode;
		that.render();
	}, milliseconds);
};

/**
 * Request an fnDraw() on a datatable
 *
 * @param {DataTable} dataTable
 */
SpreadRenderingService.prototype.requestDraw = function (dataTable) {
	/**
	 * @type ISpreadsTableUpdate
	 */
	var tableUpdate = {
		table: dataTable,
		data: null
	};
	
	return this.requestRedraw(tableUpdate);
};

/**
 * Request a redraw of a table w/ new data
 *
 * @param {ISpreadsTableUpdate} tableUpdate - info about the draw request
 */
SpreadRenderingService.prototype.requestRedraw = function (tableUpdate) {
	
	var shouldQueue = (
		this._renderMode == SpreadRenderingService.RENDER_MODE.DEFERRED ||
		(
			this._renderMode == SpreadRenderingService.RENDER_MODE.IN_VIEWPORT_ONLY &&
			!SpreadRenderingService.isInViewport(jQuery(tableUpdate.table))
		)
	);
	
	if (shouldQueue) {
		this._queueDraw(tableUpdate);
	} else {
		var drawType = this._doDraw(tableUpdate);
		if (drawType == SpreadRenderingService.DRAW_TYPE.REDRAW) {
			this._resetStatement();
		}
	}
};

/**
 * Check to see if a table is queued to be drawn
 *
 * @param {string} statementId
 * @return {boolean}
 */
SpreadRenderingService.prototype.isQueued = function (statementId) {
	statementId = _18Id(statementId);
	return !!this._queuedRedraws[statementId];
};

/**
 * Defer a draw
 *
 * @param {ISpreadsTableUpdate} tableUpdate
 * @private
 */
SpreadRenderingService.prototype._queueDraw = function (tableUpdate) {
	var tableId = _18Id(jQuery(tableUpdate.table).attr('id'));
	if (this._queuedRedraws[tableId] && !tableUpdate.data) {
		return;
	}
	
	this._queuedRedraws[tableId] = tableUpdate;
};

/**
 * Perform a redraw or draw immediately
 *
 * @param {ISpreadsTableUpdate} tableUpdate
 * @return {SpreadRenderingDrawType} whether or not the draw was a redraw
 * @private
 */
SpreadRenderingService.prototype._doDraw = function (tableUpdate) {
	var table = jQuery(tableUpdate.table);
	var tableId = _18Id(table.attr('id'));
	if (
		this._isEditing() &&
		this._isCurrentTable(table)
	) {
		return SpreadRenderingService.DRAW_TYPE.NONE;
	}
	
	var preScroll = jQuery(document).scrollTop();
	var maxPreScroll = jQuery(document).height() - jQuery(window).height();
	var wasAtBottom = (
		jQuery(document).height() > jQuery(window).height() &&
		Math.abs(maxPreScroll - preScroll) < 50
	);
	
	var drawType;
	
	if (tableUpdate.data) {
		drawType = SpreadRenderingService.DRAW_TYPE.REDRAW;
		tableUpdate.table.fnClearTable();
		tableUpdate.table.fnAddData(tableUpdate.data);
	} else {
		drawType = SpreadRenderingService.DRAW_TYPE.DRAW;
		tableUpdate.table.fnDraw();
	}
	
	delete this._queuedRedraws[tableId];
	
	var postScroll = jQuery(document).scrollTop();
	var maxPostScroll = jQuery(document).height() - jQuery(window).height();
	var isAtBottom = Math.abs(maxPostScroll - postScroll) < 50;
	var scrollChanged = Math.abs(preScroll - postScroll) > 50;
	
	if (scrollChanged) {
		jQuery(document).scrollTop(preScroll);
	} else if (wasAtBottom && !isAtBottom) {
		jQuery(document).scrollTop(maxPostScroll);
	}
	
	return drawType;
};

/**
 * Returns whether or not the current selection is within the provided table
 * @param {(DataTable|JQuery)} table
 * @return {boolean}
 * @private
 */
SpreadRenderingService.prototype._isCurrentTable = function (table) {
	var tableId = _18Id(table.attr('id'));
	if (this._navApp && this._navApp.viewModel) {
		var snvm = this._navApp.viewModel;
		return (_18Id(snvm.tableId()) == _18Id(tableId));
	}
	console.warn('RenderingService: No navigation for statement');
	return false;
};

/**
 * Is a cell being edited
 * @return {boolean}
 * @private
 */
SpreadRenderingService.prototype._isEditing = function () {
	if (this._navApp && this._navApp.viewModel) {
		var snvm = this._navApp.viewModel;
		return snvm.editingCell();
	}
	console.warn('RenderingService: No navigation for statement');
	return false;
};

/**
 * Processes all in-view draws immediately regardless of the render mode
 */
SpreadRenderingService.prototype.renderVisibleImmediately = function () {
	var that = this;
	var anyRedraws = false;
	for (var key in this._queuedRedraws) {
		if (this._queuedRedraws.hasOwnProperty(key)) {
			var tableUpdate = this._queuedRedraws[key];
			var table = jQuery(tableUpdate.table);
			if (SpreadRenderingService.isInViewport(table)) {
				var drawType = that._doDraw(tableUpdate);
				anyRedraws = (anyRedraws || (drawType == SpreadRenderingService.DRAW_TYPE.REDRAW));
			}
		}
	}
	
	if (anyRedraws) {
		this._resetStatement();
	}
};

/**
 * Processes all draws immediately regardless of the render mode
 */
SpreadRenderingService.prototype.renderAllImmediately = function () {
	var that = this;
	var anyRedraws = false;
	for (var key in this._queuedRedraws) {
		if (this._queuedRedraws.hasOwnProperty(key)) {
			var tableUpdate = this._queuedRedraws[key];
			var drawType = that._doDraw(tableUpdate);
			anyRedraws = (anyRedraws || (drawType == SpreadRenderingService.DRAW_TYPE.REDRAW));
		}
	}
	
	if (anyRedraws) {
		this._resetStatement();
	}
};

/**
 * Render according to the current rendering mode
 */
SpreadRenderingService.prototype.render = function () {
	switch (this._renderMode) {
		case SpreadRenderingService.RENDER_MODE.IMMEDIATE:
			return this.renderAllImmediately();
		case SpreadRenderingService.RENDER_MODE.IN_VIEWPORT_ONLY:
			return this.renderVisibleImmediately();
		default:
			return;
	}
};

SpreadRenderingService.prototype.statementReady = function () {
	var then;
	var loadEnd;
	var renderEnd;
	
	
	if (typeof window['performance'] == 'object') {
		then = window['performance']['timing']['navigationStart'];
		loadEnd = Date.now();
		
		this.loadTime = (loadEnd - then);
		if (typeof window['ga'] == 'function') {
			window.ga(
				'send',
				'timing',
				'Spread Timing',
				'loadTime',
				this.loadTime,
				'Spreads Loading Timing (pre-rendering)'
			);
		}
	}
	
	this.renderVisibleImmediately();
	this.deferHiddenRendering();
	
	if (typeof window['performance'] == 'object') {
		renderEnd = Date.now();
		
		this.renderTime = (renderEnd - loadEnd);
		if (typeof window['ga'] == 'function') {
			window.ga('send', 'timing', 'Spread Timing', 'renderTime', this.renderTime, 'Spreads Rendering Timing');
		}
		
		this.totalTime = (renderEnd - then);
		if (typeof window['ga'] == 'function') {
			window.ga('send', 'timing', 'Spread Timing', 'totalTime', this.totalTime, 'Spreads Load + Render Timing');
		}
	}

	this._navApp.publish('SPREAD.Spreads.Statement_Ready', this.statementId);
};

/**
 * Perform reset logic required after a full redraw
 * @private
 */
SpreadRenderingService.prototype._resetStatement = function () {
	this._renderComments();
};

SpreadRenderingService.prototype._renderComments = function () {
	if (this._commentsApp && this._commentsApp.viewModel) {
		this._commentsApp.viewModel.loadElements();
	}
};

/**
 * All of the currently rendering statements on this page
 * @type {Array<SpreadRenderingService>}
 * @private
 * @static
 */
SpreadRenderingService._instances = [];

/**
 * JQuery subscription that processes all scroll events and delegates to each SRS instance
 *
 * @type {(JQuery|null)}
 * @private
 * @static
 */
SpreadRenderingService._scrollSubscription = null;

/**
 * Checks to see if any portion of the specified element is within the viewport (below the nCino header)
 *
 * @param {(HTMLElement|JQuery)} element
 * @static
 * @return {boolean}
 */
SpreadRenderingService.isInViewport = function (element) {
	if (typeof jQuery == "function" && element instanceof jQuery) {
		element = element[0];
	}
	
	var rect = element.getBoundingClientRect();
	
	return (
		rect.top <= (window.innerHeight || document.documentElement.clientHeight) &&
		rect.left <= (window.innerWidth || document.documentElement.clientWidth) &&
		rect.bottom >= 0 &&
		rect.right >= 0
	);
};

/**
 * Find the rendering service instance for the corresponding statement
 *
 * @param {string} statementId the 15 or 18 char SFDC Id of the SpreadStatement
 * @return {SpreadRenderingService}
 */
SpreadRenderingService.getInstanceForStatementId = function (statementId) {
	statementId = _18Id(statementId);
	var allIds = SpreadRenderingService._instances.map(function (x) { return x.statementId; });
	var index = allIds.indexOf(statementId);
	if (index != -1) {
		return SpreadRenderingService._instances[index];
	}
};

/**
 * Subscribe to browser scroll events to conditionally render spreads
 * @private
 * @static
 */
SpreadRenderingService._addScrollSubscriptions = function () {
	if (SpreadRenderingService._scrollSubscription) {
		return;
	}
	
	SpreadRenderingService._scrollSubscription = jQuery(window).on('scroll', function () {
		if (SpreadRenderingService._scrollTimeout) {
			clearTimeout(SpreadRenderingService._scrollTimeout);
		}
		
		SpreadRenderingService._scrollTimeout = setTimeout(
			SpreadRenderingService._scrollTimeoutCallback,
			SpreadRenderingService.SCROLL_TIMEOUT_MILLISECONDS
		);
	});
};

/**
 * Called when the user has stopped scrolling for longer than the scroll timeout
 * Notifies all statements in IN_VIEWPORT_ONLY mode to render all visible queued tables
 *
 * @private
 * @static
 */
SpreadRenderingService._scrollTimeoutCallback = function () {
	SpreadRenderingService._instances.forEach(function (statement) {
		if (statement._renderMode == SpreadRenderingService.RENDER_MODE.IN_VIEWPORT_ONLY) {
			statement.renderVisibleImmediately();
		}
	});
};

/**
 *
 * @type {(null|number)}
 * @private
 * @static
 */
SpreadRenderingService._scrollTimeout = null;
SpreadRenderingService.SCROLL_TIMEOUT_MILLISECONDS = 100;

/**
 * @static
 * @readonly
 * @enum {string}
 * @typedef {string} SpreadRenderingMode
 * @property {SpreadRenderingMode} IMMEDIATE - Render all draws and redraws immediately
 * @property {SpreadRenderingMode} IN_VIEWPORT_ONLY - Only render tables in the current viewport. Queue all others
 * @property {SpreadRenderingMode} DEFERRED - Do not allow
 */
SpreadRenderingService.RENDER_MODE = {
	IMMEDIATE: 'render_immediately',
	IN_VIEWPORT_ONLY: 'render_in_view_only',
	DEFERRED: 'rendering_deferred'
};

/**
 * @static
 * @readonly
 * @enum {number}
 * @typedef {number} SpreadRenderingDrawType
 * @property {SpreadRenderingDrawType} NONE - no draw
 * @property {SpreadRenderingDrawType} DRAW - non-clearing redraw
 * @property {SpreadRenderingDrawType} REDRAW - full clear and redraw
 */
SpreadRenderingService.DRAW_TYPE = {
	NONE: -1,
	DRAW: 1,
	REDRAW: 2
};

if (_.isEmpty(LifeCycle.SpreadRenderingService)) {
	LifeCycle.SpreadRenderingService = SpreadRenderingService;
}