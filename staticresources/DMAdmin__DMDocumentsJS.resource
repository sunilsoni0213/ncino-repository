var documentID
var documentType
function deleteFunction( id, type ) {
	documentID = id;
	documentType = type;
	$('#confirmationDialog').modal('show');
}