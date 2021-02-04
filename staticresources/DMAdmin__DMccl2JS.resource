var allProducts;

function loadProductIds() {
	DMAdmin.DMFunctionsController.retrieveProducts(
		function(result, event) {
			if (event.status) {
				allProducts = result;
			}
			else
				alert(event.message);
		}
	);
}

function updateChecks(sel) {
	loading(true);
	document.getElementById('saBox').checked = false;
	DMAdmin.DMFunctionsController.getRelatedProducts(
		sel.value,
		function(result, event) {
			if (event.status) {
				for (var i = allProducts.length - 1; i >= 0; i--) {
					if (result.indexOf(allProducts[i]) > -1)
						document.getElementById(allProducts[i]).checked = true;
					else 
						document.getElementById(allProducts[i]).checked = false;
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
	var checkedProducts = [];
	for (var i = allProducts.length - 1; i >= 0; i--) {
		if (document.getElementById(allProducts[i]).checked == true)
			checkedProducts.push(allProducts[i]);
	};
	DMAdmin.DMFunctionsController.updateProductCCLs(
		document.getElementById('documentSelect').value,
		checkedProducts,
		function(result, event) {
			loading(false);
			if (!event.status)
				alert(event.message);
		}
	);
}

function checkAll( val ) {
  if (val) {
    for (var i = allProducts.length - 1; i >= 0; i--) {
      document.getElementById(allProducts[i]).checked = true;
    };
  } else {
    for (var i = allProducts.length - 1; i >= 0; i--) {
      document.getElementById(allProducts[i]).checked = false;
    };
  }
}