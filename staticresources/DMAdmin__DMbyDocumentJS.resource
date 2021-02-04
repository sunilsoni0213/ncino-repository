var allCCLs;

function checkAll( val ) {
	if (val) {
		for (var i = allCCLs.length - 1; i >= 0; i--) {
			document.getElementById(allCCLs[i]).checked = true;
			document.getElementById(allCCLs[i]).indeterminate = false;
		};
	} else {
		for (var i = allCCLs.length - 1; i >= 0; i--) {
			document.getElementById(allCCLs[i]).checked = false;
			document.getElementById(allCCLs[i]).indeterminate = false;
		};
	}
}

function loadCCLs() {
	DMAdmin.DMFunctionsController.retrieveCCLs(
		function(result, event) {
			if (event.status) {
				allCCLs = result;
			}
			else
				alert(event.message);
		}
	);
}

function typeChanged(sel) {
	loading(true);
	document.getElementById('saBox').checked = false;
	DMAdmin.DMFunctionsController.getTypeRelatedCCLs(
		sel.value,
		function(result, event) {
			if (event.status) {
				for (var i = allCCLs.length - 1; i >= 0; i--) {
					if (result.indexOf(allCCLs[i]) > -1)
						document.getElementById(allCCLs[i]).checked = true;
					else
						document.getElementById(allCCLs[i]).checked = false;
				};
				checkIndeterminate(sel);
			} else {
				loading(false);
				alert(event.message);
			}
		}
	);
}

function checkIndeterminate(sel) {
	DMAdmin.DMFunctionsController.getTypeIndeterminateCCLs(
		sel.value,
		function(result, event) {
			if (event.status) {
				for (var i = allCCLs.length - 1; i >= 0; i--) {
					if (result.indexOf(allCCLs[i]) > -1)
						document.getElementById(allCCLs[i]).indeterminate = true;
					else
						document.getElementById(allCCLs[i]).indeterminate = false;
				};
				loading(false);
			} else {
				loading(false);
				alert(event.message);
			}
		}
	);
}

function submitDocumentResult() {
	loading(true);
	var idList = [];
	for (var i = allCCLs.length - 1; i >= 0; i--) {
		if (document.getElementById(allCCLs[i]).checked == true)
			idList.push(allCCLs[i]);
	};
	document.getElementById('saBox').checked = false;
	DMAdmin.DMFunctionsController.updateProductCCLsByType(
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

