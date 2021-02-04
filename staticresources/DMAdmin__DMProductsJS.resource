var productID
var productType
function deleteFunction( id, type ) {
	productID = id;
	productType = type;
	$('#confirmationDialog').modal('show');
}