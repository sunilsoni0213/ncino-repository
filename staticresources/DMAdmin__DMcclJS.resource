var selectedProduct;
var allTabs;
var allTabCCLs;

function loadDocTabs() {
	DMAdmin.DMFunctionsController.retrieveDocTabs(
		function(result, event) {
			if (event.status) {
				allTabs = result;
			}
			else
				alert(event.message);
		}
	);
}

function productChanged(sel) {
	document.getElementById('selectAllBox').checked = false;
	updateCCLTable(sel.value);
}

function checkRelatedTabs(sel) {
	loading(true);
	DMAdmin.DMFunctionsController.getRelatedDocTabs(
		sel.value,
		function(result, event) {
			if (event.status) {
				for (var i = allTabs.length - 1; i >= 0; i--) {
					if (result.indexOf(allTabs[i]) > -1){
						console.log('checking: ' + allTabs[i]);
						document.getElementById(allTabs[i]).checked = true;
					}
					else {
						console.log('unchecking: ' + allTabs[i]);
						document.getElementById(allTabs[i]).checked = false;
					}
				};
				checkRelatedCCLs(sel, result)
			} else {
				loading(false);
				alert(event.message);
			}	
		}
	);
}

function checkRelatedCCLs(sel, tabs) {
	DMAdmin.DMFunctionsController.getTabRelatedCCLs(
		tabs,
		function(result, event) {
			if (event.status) {
				allTabCCLs = result;
			}
			else {
				loading(false);
				alert(event.message);
			}
		}
	);
	DMAdmin.DMFunctionsController.getRelatedCCLs(
		sel.value,
		function(result, event) {
			if (event.status) {
				for (var i = allTabCCLs.length - 1; i >= 0; i--) {
					if (result.indexOf(allTabCCLs[i]) > -1){
						console.log('checking: ' + allTabCCLs[i]);
						document.getElementById(allTabCCLs[i]).checked = true;
					}
					else {
						console.log('unchecking: ' + allTabCCLs[i]);
						document.getElementById(allTabCCLs[i]).checked = false;
					}
				};
				loading(false);
			} else {
				loading(false);
				alert(event.message);
			}	
		}
	);
}

function submitTabResult() {
	document.getElementById('selectAllBox').checked = false;
	var checkedTabs = [];
	for (var i = allTabs.length - 1; i >= 0; i--) {
		if (document.getElementById(allTabs[i]).checked == true) {
			checkedTabs.push(allTabs[i]);
		}
	};
	DMAdmin.DMFunctionsController.updateProductDocTabs(
		document.getElementById('productSelect').value,
		checkedTabs,
		function(result, event) {
			updateCCLTable(document.getElementById('productSelect').value);
			if (!event.status)
				alert(event.message);
		}
	);
}

function submitCCLResult() {
	loading(true);
	document.getElementById('selectAllBox').checked = false;
	var idList = [];
	for (var i = allTabCCLs.length - 1; i >= 0; i--) {
		if (document.getElementById(allTabCCLs[i]).checked == true) 
			idList.push(allTabCCLs[i]);
	};
	DMAdmin.DMFunctionsController.updateProductCCLsByProduct(
		document.getElementById('productSelect').value,
		idList,
		function(result, event) {
			loading(false);
			if (!event.status)
				alert(event.message);
		}
	);
}

function checkAll( val ) {
	if (val) {
		for (var i = allTabCCLs.length - 1; i >= 0; i--) {
			document.getElementById(allTabCCLs[i]).checked = true;
		};
	} else {
		for (var i = allTabCCLs.length - 1; i >= 0; i--) {
			document.getElementById(allTabCCLs[i]).checked = false;
		};
	}
}
