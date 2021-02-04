jQuery(function(){
	(function (app){
		View = function(viewModel){
			var self = this;
			// TODO: externalize
			var height = jQuery(window).height();
			var width = jQuery(window).width();
			var renderNode = function(r, node){
				var color = Raphael.getColor();
				var ellipse = node.shapecall(r, node).attr({
					fill: node.fill || color,
					stroke: node.stroke || color,
					"stroke-width": 2
				}).dblclick(function(elem){
					LifeCycle.BorrowerTree.debug('INFO', 'dblclicking on [' + node.id + ']');
					
					viewModel.OBJECTMAP[node.record.recordId()].show(
							!viewModel.OBJECTMAP[node.record.recordId()].show());
					
				}).hover(function(mouseEvent){ // hover in
					this.glowPath = this.glow({});
					return this.glowPath;
				},
				function (mouseEvent){ // hover out
					this.glowPath.remove();
				});
				
				/* set DOM node ID */
				ellipse.node.id = node.label || node.id;
				shape = r.set().push(
						ellipse).push(
								node.iconcall(r, node)).push(
										node.textcall(r, node));
				return shape;
			};
			var isDone = function(){
				if(self.counter != 0 && self.counter == self.countercheck){
					return true;
				}
				self.countercheck = self.counter;
				return false;
			};
			var checkIfDone = function(isDoneExecuting){
				var b = isDoneExecuting();
				LifeCycle.BorrowerTree.debug('INFO', 'is done executing[' + b + ']');
				if(!b){
					_.delay(checkIfDone, 500, isDone);
				}
				else{
					self.draw();
					_.each(self.toRemoveNodes, function(node){
						self.graph.removeNode(node.id);
						self.graphNodes[node.id] = null;
					});
					self.toRemoveNodes.splice(0, self.toRemoveNodes.length);

					app.unblockUI();
				}
			};
			//
			// key: node id
			// value: node
			//
			self.graphNodes = {};
			self.toRemoveNodes = [];
			self.counter = 0;
			self.counterCheck = 0;
			self.viewModel = viewModel;
			self.graph = new Graph();
			self.layouter = null;
			self.renderer = null;
			
			self.render = function(){
				checkIfDone(isDone);
				var koObj = self.getInflatedObject(
						self.viewModel[self.viewModel.recordType()].recordId());
				self.renderObj(null, self.graph, koObj, self.viewModel, self.rerender);
				return self;
			};
			self.renderObj = function(parentNode, graph, obj, vm, renderCallback){
				
				self.counter++;
				var edgeAdded = false;
				
				var recordType = LifeCycle.BorrowerTree.typeMap[obj.apexType()];
				if(recordType != null && recordType == self.viewModel.recordType()){
					if(obj.recordId() != self.viewModel[recordType].recordId()){
						self.removeNode(graph, parentNode);
						return;
					}
					else{
						edgeAdded = true;
					}
				}
				
				var inflatedObj = self.getInflatedObject(obj.recordId());
				
				LifeCycle.BorrowerTree.debug('INFO', 'rendering view for record type [' + recordType + ']' + '[' + obj.recordId() +']');

				var node = self.graphNodes[obj.recordId()];
				switch(recordType){
					case 'LOAN':
						
						if(node == null){
							node = {
								id : obj.recordId(),
								content: {
									id : obj.recordId(),
									label: 'Loan: \n' + inflatedObj.name() + ' \n' +
										'Original Amount: ' + Utils.formatCurrencyForDisplay(inflatedObj.amount()), // TODO: externalize
									record: inflatedObj,
									iconcall: function(r, node){
										return r.path(app.svgIcons.dollar).attr({fill: "#000", stroke: "none"});
									},
									shapecall: function(r, node){
										return r.rect(0, 0, 200, 75, 4);
									},
									textcall: function(r, node){
										return r.text(100, 25, node.label || node.id);
									},
									render: renderNode
								}
							};
							self.addNode(graph, node);
							
							var borrowerNode = {
								id: obj.recordId() +'_borrowers',
								content: {
									id : obj.recordId(),
									label: 'Borrowers', // TODO: externalize
									record: inflatedObj,
									iconcall: function(r, node){
										return r.path(app.svgIcons.people).attr({
											fill: "#000", 
											stroke: "none", 
											transform: ['t',-17,-20]});
									},
									shapecall: function(r, node){
										return  r.ellipse(0, 0, 30, 20);
									},
									textcall: function(r, node){
										return r.text(0, 30, node.label || node.id);
									},
									render: renderNode
								}
							};
							var guarantorNode = {
								id: obj.recordId() +'_guarantors',
								content: {
									id : obj.recordId(),
									label: 'Guarantors', // TODO: externalize
									record: inflatedObj,
									iconcall: function(r, node){
										return r.path(app.svgIcons.chart).attr({
											fill: "#000", 
											stroke: "none", 
											transform: ['t',-17,-20]});
									},
									shapecall: function(r, node){
										return  r.ellipse(0, 0, 30, 20);
									},
									textcall: function(r, node){
										return r.text(0, 30, node.label || node.id);
									},
									render: renderNode
								}
							};
							self.addNode(graph, borrowerNode);
							self.addNode(graph, guarantorNode);
							self.addEdge(graph, node, borrowerNode);
							self.addEdge(graph, node, guarantorNode);
							
							if(inflatedObj.relationship && inflatedObj.relationship.recordId() != null){
								self.renderObj(
										null, // relationship is the parent
										graph, 
										inflatedObj.relationship, 
										vm, renderCallback);
							}
							if(inflatedObj.borrowers){
								_.each(inflatedObj.borrowers(), function(element, index, list){
									self.renderObj(borrowerNode, graph, element, vm, renderCallback);
								});
							}
							if(inflatedObj.guarantors){
								_.each(inflatedObj.guarantors(), function(element, index, list){
									self.renderObj(guarantorNode, graph, element, vm, renderCallback);
								});
							}
						}
						break;
					case 'RELATIONSHIP':
						if(node == null){
							
							node = {
								id : obj.recordId(),
								content: {
									id : obj.recordId(),
									label: 'Relationship: \n' + inflatedObj.name() + ' \n(' + inflatedObj.entityType()+ ')', // TODO: externalize
									record: inflatedObj,
									iconcall: function(r, node){
										return r.path(app.svgIcons.relationship).attr({
											fill: "#000", 
											stroke: "none", 
											transform: ['t',-17,-20]});
									},
									shapecall: function(r, node){
										return  r.ellipse(0, 0, 60, 40);
									},
									textcall: function(r, node){
										return r.text(0, 60, node.label || node.id);
									},
									render: renderNode
								}
							};
							self.addNode(graph, node);

							LifeCycle.BorrowerTree.debug('INFO', 'relationship has contacts: [' + (inflatedObj.contacts().length ) + ']');
							
							if(inflatedObj.parent){
								self.renderObj(
										null, // this is the parent 
										graph, 
										inflatedObj.parent, 
										vm, 
										renderCallback);
							}
							if(inflatedObj.loans){
								_.each(inflatedObj.loans(), function(element, index, list){
									//self.renderObj(node, graph, element, vm, renderCallback);
								});
							}
							if(inflatedObj.contacts){
								_.each(inflatedObj.contacts(), function(element, index, list){
									self.renderObj(node, graph, element, vm, renderCallback);
								});
							}
						}
						break;
					case 'BORROWER':
					case 'GUARANTOR':
						if(node == null){
							if(inflatedObj.relationship){

								var inflatedRelationship = self.getInflatedObject(inflatedObj.relationship.recordId());
								
								node = {
										id : obj.recordId(),
										content: {
											id : obj.recordId(),
											label: inflatedRelationship.name() + ' \n' +
												(inflatedObj.contingentType? 'Contingency: ' + inflatedObj.contingentType() + ' ': '') +
												' | ' + (inflatedObj.contingentPercentage? inflatedObj.contingentPercentage() + '%' : ''), // TODO: externalize
											record: inflatedObj,
											iconcall: function(r, node){
												return r.path(app.svgIcons.link).attr({
													fill: "#000", 
													stroke: "none", 
													transform: ['t',-17,-15]});
											},
											shapecall: function(r, node){
												return  r.ellipse(0, 0, 30, 20);
											},
											textcall: function(r, node){
												return r.text(0, 30, node.label || node.id);
											},
											render: renderNode
										}
									};
									self.addNode(graph, node);
									
									/*
									var parentNodeId = '_borrowers';
									if('GUARANTOR' == recordType){
										parentNodeId = '_guarantors';
									}
									*/
									
									var relationshipNode = self.renderObj(
											null, 
											graph, 
											inflatedObj.relationship, 
											vm, 
											renderCallback);
									
									self.addEdge(graph, relationshipNode, node); 
									
									if(inflatedObj.loan){
										self.renderObj(node, graph, inflatedObj.loan, vm, renderCallback);
									}
									
									if(inflatedObj.signers){
										_.each(inflatedObj.signers(), function(element, index, list){
											self.renderObj(node, graph, element, vm, renderCallback);
										});
									}
									
									
							}
						}
						break;
					case 'SIGNER':
						if(node == null){
							node = {
								id : obj.recordId(),
								content: {
									id : obj.recordId(),
									label: 'Capacity: ' + inflatedObj.capacity() + ' \n' +
										(inflatedObj.ownershipPercentage? 'Ownership: ' + inflatedObj.ownershipPercentage()+'%' : ''), // TODO: externalize
									record: inflatedObj
									// TODO: wire in custom render functions
								}
							};
							//self.addNode(graph, node);
							
							if(inflatedObj.contact && inflatedObj.involvement){
								var contactNode = self.renderObj(
										null, 
										graph, 
										inflatedObj.contact, 
										vm, 
										renderCallback);
								
								var involvementNode = self.renderObj(
										null, 
										graph, 
										inflatedObj.involvement, 
										vm, 
										renderCallback);
								
								edgeAdded = true;
								
								self.addEdge(graph, involvementNode, contactNode, node.content.label); 
							}
						}
						break;
					case 'CONTACT':
						if(node == null){
							node = {
								id : obj.recordId(),
								content: {
									id : obj.recordId(),
									label: 'Contact: \n' + inflatedObj.name(), // TODO: externalize
									record: inflatedObj,
									iconcall: function(r, node){
										return r.path(app.svgIcons.person).attr({
											fill: "#000", 
											stroke: "none", 
											transform: ['t',-17,-20]});
									},
									shapecall: function(r, node){
										return  r.ellipse(0, 0, 30, 20);
									},
									textcall: function(r, node){
										return r.text(0, 30, node.label || node.id);
									},
									render: renderNode
								}
							};
							self.addNode(graph, node);
							
							if(inflatedObj.relationship){
								self.renderObj(
										null, 
										graph, 
										inflatedObj.relationship, 
										vm, 
										renderCallback);
							}
							if(inflatedObj.signings){
								_.each(inflatedObj.signings(), function(element, index, list){
									self.renderObj(node, graph, element, vm, renderCallback);
								});
							}
						}
						break;
				}
				if(!edgeAdded){
					self.addEdge(graph, parentNode, node);
				}
				return node;
			};
			self.addNode = function(graph, node){
				graph.addNode(
						node.id,
						node.content);
				
				self.graphNodes[node.id] = node;
				
				LifeCycle.BorrowerTree.debug(
						'INFO', 
						'adding node: [' + (node.id) + ' - ' + (node.content.label) +']');
				
				return self;
			};
			self.removeNode = function(graph, node){
				if(graph != null && node != null){
					
					LifeCycle.BorrowerTree.debug(
							'INFO', 
							'removing node: [' + (node.id) + ']');
					
					if(self.graphNodes[node.id]){
						self.toRemoveNodes.push(node);
					}
					return self;
				}
			};
			self.addEdge = function(graph, nodeA, nodeB, label){
				if(graph != null && nodeA != null && nodeB != null){
					LifeCycle.BorrowerTree.debug('INFO', 'edge label: ' + label);
					
					var style = {
							directed: true, 
							'stroke-width': 1, 
							'font-size': 10, 
							'font-weight': 'normal'};
					
					var temp = {};
					temp.toString = function(){ return '';};
					if(label != null){
						style.label = label;
					}
					else{
						style.label = temp;
					}
					LifeCycle.BorrowerTree.debug(
							'INFO', 
							'adding edge: [' + (nodeA.id) + ' - ' + (nodeA.content.label) +'] [' + 
								(nodeB.id) + ' - ' + (nodeB.content.label) +'] style: [' + JSON.stringify(style)+ ']');
					
					graph.addEdge(nodeA.id, nodeB.id, style);
				}
				return self;
			};
			self.getInflatedObject = function(recordId){
				return self.viewModel.OBJECTMAP[recordId];
			};
			self.clear = function(){
				self.graphNodes = {};
				self.counter = 0;
				self.counterCheck = 0;
				self.graph = new Graph();
				if(self.renderer){
					self.renderer.r.clear();
				}
				self.renderer = null;
				self.layouter = null;
			};
			self.redraw = function(){
				app.blockUI();
				self.clear();
				self.render();
			}
			self.draw = function(){
				self.layouter = self.layouter || new Graph.Layout.Spring(self.graph);
				self.renderer = self.renderer || new Graph.Renderer.Raphael(
						self.viewModel.canvasDivId(), 
						self.graph,
						width,
						height);
				
				self.renderer.draw();
				
				// TODO: resolve this!
				jQuery('svg').find('text').css({'fill-opacity': 1.0});
			};
			return self;
		};
		app.View = View;
	})(window.borrowerTreeApp);
});
