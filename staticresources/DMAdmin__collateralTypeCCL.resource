var allCollateralTypes;

function loadCollateralTypeIds() {
	DMAdmin.DMFunctionsController.retrieveCollateralTypes(
		function(result, event) {
			if (event.status) {
				allCollateralTypes = result;
			}
			else
				alert(event.message);
		}
	);
}

function loadCCLs() {
	DMAdmin.DMFunctionsController.retrieveCCLs(
		function(result, event) {
			if (event.status) {
				allCollateralTypes = result;
			}
			else
				alert(event.message);
		}
	);
}

function typeChanged(sel) {
	loading(true);
	document.getElementById('saBox').checked = false;
	DMAdmin.DMFunctionsController.getCollateralTypeRelatedCCLs(
		sel.value,
		function(result, event) {
			if (event.status) {
				for (var i = allCollateralTypes.length - 1; i >= 0; i--) {
					if (result.indexOf(allCollateralTypes[i]) > -1)
						document.getElementById(allCollateralTypes[i]).checked = true;
					else
						document.getElementById(allCollateralTypes[i]).checked = false;
				};
				loading(false);
			} else {
				loading(false);
				alert(event.message);
			}
		}
	);
}

function updateChecks(sel) {
	loading(true);
	document.getElementById('saBox').checked = false;
	DMAdmin.DMFunctionsController.getRelatedCollateralTypes(
		sel.value,
		function(result, event) {
			if (event.status) {
				for (var i = allCollateralTypes.length - 1; i >= 0; i--) {
					if (result.indexOf(allCollateralTypes[i]) > -1)
						document.getElementById(allCollateralTypes[i]).checked = true;
					else
						document.getElementById(allCollateralTypes[i]).checked = false;
				};
				loading(false);
			} else {
				loading(false);
				alert(event.message);
			}

		}
	);
}

function submitChanges() {
	loading(true);
	document.getElementById('saBox').checked = false;
	var checkedCollateralTypes = [];
	for (var i = allCollateralTypes.length - 1; i >= 0; i--) {
		if (document.getElementById(allCollateralTypes[i]).checked == true)
			checkedCollateralTypes.push(allCollateralTypes[i]);
	};
	DMAdmin.DMFunctionsController.updateCollateralTypeCCLs(
		document.getElementById('documentSelect').value,
		checkedCollateralTypes,
		function(result, event) {
			loading(false);
			if (!event.status)
				alert(event.message);
		}
	);
}

function submitDocumentResult() {
	loading(true);
	var idList = [];
	for (var i = allCollateralTypes.length - 1; i >= 0; i--) {
		if (document.getElementById(allCollateralTypes[i]).checked == true)
			idList.push(allCollateralTypes[i]);
	};
	document.getElementById('saBox').checked = false;
	DMAdmin.DMFunctionsController.updateCollateralCCLsByType(
		document.getElementById('productTypeSelect').value,
		idList,
		function(result, event) {
			if (event.status) {
				loading(false);
			} else {
				loading(false);
				alert(event.message);
			}
		}
	);
}

function checkAll( val ) {
	if (val) {
		for (var i = allCollateralTypes.length - 1; i >= 0; i--) {
			document.getElementById(allCollateralTypes[i]).checked = true;
		};
	} else {
		for (var i = allCollateralTypes.length - 1; i >= 0; i--) {
			document.getElementById(allCollateralTypes[i]).checked = false;
		};
	}
}