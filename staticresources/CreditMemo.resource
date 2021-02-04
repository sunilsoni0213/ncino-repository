var aoSectionRenders = [];

function CreditMemoFactory(sDataProviderClass, aoAllTemplates) {	
	// private vars 
	var _that = null;
	var _sClass = null;
	var _aoAllTemplates = null;
	
	// public functions
	this.createRenderer = function(){
		return new CreditMemoSectionRenderer(
				_sClass, 
				aoSectionRenders,
				_aoAllTemplates);
	};
	
	// private functions 
	
	function _fnInit(sClass, that, aoAllTemplates) {
		_sClass = sClass;
		_that = that;
		_aoAllTemplates = aoAllTemplates;
	}
	
	_fnInit(sDataProviderClass, this, aoAllTemplates);
};

function CreditMemoSectionRenderer(sDataProviderClass, aoRenderers, aoAllTemplates){
	// private vars 
	var _that = null;
	var _sClass = null;
	var _data = null;
	var _aoRenderers = null;
	var _sHtml = null;
	var _aoAllTemplates = null;
	
	// public functions
	this.setData = function(data, nContainer){
		
		var html = '';

		// TODO!! fix this by adding a button to clear UI data cache, 
		// otherwise serve data from cache
		if(true){
		//if(_data == null){
			html = _render(data, _aoAllTemplates, nContainer);
		}
		else{
			html = _sync(data);
		}
		_data = data;
		
		_sHtml = html;
		
		return html;
	};
	
	// private functions 
	
	function _fnInit(sClass, that, aoRenderers, aoAllTemplates) {
		_sClass = sClass;
		_that = that;
		_aoRenderers = aoRenderers;
		_aoAllTemplates = aoAllTemplates;
	};
	
	_render = function(data, aoAllTemplates, nContainer){
		var sToRet = null;
		
		for(var i=0;i<_aoRenderers.length;i++){
			if(_aoRenderers[i].dataProvider.indexOf(_sClass) >= 0){
				
				var sTemplates = [];
				for(var m=0;m<_aoRenderers[i].templateNames.length;m++){
					sTemplates.push(
							aoAllTemplates[_aoRenderers[i].templateNames[m]]);
				}
				
				sToRet = _aoRenderers[i].renderer.render(
						data, 
						sTemplates,
						nContainer);
				break;
			}
		}
		return sToRet ;
	};
	
	_sync = function(data){
		return _sHtml;
	};
	
	_fnInit(sDataProviderClass, this, aoRenderers, aoAllTemplates);
};

function ARenderer(){};
ARenderer.prototype.render = function(data, templates, nContainer){
	var sHtml = '';
	
	for(var d=0;d<templates.length;d++){
		var sHamlData = Haml.render(
			templates[d],{
				locals: {
					data: data,
					msgs: msgs,
					nContainer: nContainer
				}
			}
		);

		if(d == 0){
			jQuery(nContainer).find('div.credit_memo_data_replacement').html(sHamlData);
		}
		else{
			jQuery(nContainer).find('div.credit_memo_data_replacement').append(sHamlData);
		}
		sHtml += sHamlData;
	}
	
	return sHtml;
};
CommentaryRenderer.prototype = new ARenderer();
function CommentaryRenderer(){
	ARenderer.apply(this, arguments);
};
CommentaryRenderer.prototype.render = function(data, templates, nContainer){
	ARenderer.prototype.render.apply(this, arguments);
	// TODO: remove this hack!
	if(data.commentaries.length > 0){
		var contents = jQuery.parseJSON(
				data.commentaries[data.commentaries.length-1].text);
		if(contents != null && contents.length > 0){
			var bShow = false;
			
			for(var o=0;o<contents.length;o++){
				for(var j=0;j<contents[o].length;j++){
					if(contents[o][j] != null && 
							contents[o][j].length >0 ){
						bShow = true;
						break;
					}	
				}
			}
			if(bShow){
				showCutAndPasteSection(
						jQuery(nContainer).find('div.controls div.paste a'),
						false);
			}
		}
	}
}


// Hook into module system
if( typeof module !== 'undefined') {
	module.exports = CreditMemoFactory;
}

// -------------------------------------- START CUSTOM RENDERERS ---------------
CreditMemoConvenantsRenderer.prototype = new CommentaryRenderer();
function CreditMemoConvenantsRenderer(){
	CommentaryRenderer.apply(this, arguments);
}

// TODO: add more renderers and templates here!
aoSectionRenders.push({
	dataProvider: 'CreditMemoCovenants',
	renderer: new CreditMemoConvenantsRenderer(),
	templateNames: ['view_credit_memo_commentary']});

