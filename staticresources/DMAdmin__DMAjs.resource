var documentID
var documentType

$(function() {
	$(".tooltip").tooltip();
	loadDocumentTables();
});

function loading(val) {
	if (val) {
		$('#load_scrl').css('top', $(document).scrollTop() + 200);
		$('.loadingBox').show();
	}
	else {
		$('.loadingBox').hide();
	}
}

var defaultOptions = {
	"bPaginate": false,
	"bJQueryUI": true,
	"bRetrieve": true,
	"sPaginationType": "bs_normal",
	"fnPreDrawCallback": function( oSettings ) {
		$('.dataTables_filter input').addClass('form-control input-sm');
		$('.dataTables_filter input').css('width', '200px');
		$('.dataTables_length select').addClass('form-control input-sm');
		$('.dataTables_length select').css('width', '75px');
		$('.dataTables_filter input').attr('placeholder', 'Search');
	}
}


function loadDocumentTables() {
	$('#dTabTable').dataTable($.extend({}, defaultOptions, {
		"aoColumns": [
			{ "sClass": "center", "bSortable": false},
			{ },
			{ },
			{ }
		]
	}));

	$('#dTypeTable').dataTable($.extend({}, defaultOptions, {
		"aoColumns": [
			{ "sClass": "center", "bSortable": false},
			{ },
			{ },
			{ },
			{ }
		]
	}));

	$('#dTable').dataTable($.extend({}, defaultOptions, {
		"aoColumns": [
			{ "sClass": "center", "bSortable": false},
			{ },
			{ },
			{ },
			{ }
		]
	}));
}

function deleteFunction( id, type ) {
	documentID = id;
	documentType = type;
	$('#confirmationDialog').modal('show');
}

