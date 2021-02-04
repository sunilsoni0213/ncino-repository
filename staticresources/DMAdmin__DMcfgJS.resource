$(document).ready(function() {
	$('#cfgkeyTable').dataTable({
		"bPaginate": false,
		"bJQueryUI": true,
		"bRetrieve": true,
		"sPaginationType": "bs_normal",
		"oLanguage": {"sSearch": ""},
		"fnPreDrawCallback": function( oSettings ) {
			$('.dataTables_filter input').addClass('form-control input-sm');
			$('.dataTables_filter input').css('width', '200px');
			$('.dataTables_length select').addClass('form-control input-sm');
			$('.dataTables_length select').css('width', '75px');
			$('.dataTables_filter input').attr('placeholder', 'Search');
		},
		"aoColumns": [
			{ "sClass": "center", "bSortable": false},
			{ },
			{ }
		]
	});
	$('#cfgckjTable').dataTable({
		"bPaginate": false,
		"bJQueryUI": true,
		"bRetrieve": true,
		"sPaginationType": "bs_normal",
		"oLanguage": {"sSearch": ""},
		"fnPreDrawCallback": function( oSettings ) {
			$('.dataTables_filter input').addClass('form-control input-sm');
			$('.dataTables_filter input').css('width', '200px');
			$('.dataTables_length select').addClass('form-control input-sm');
			$('.dataTables_length select').css('width', '75px');
			$('.dataTables_filter input').attr('placeholder', 'Search');
		},
		"aoColumns": [
			{ "sClass": "center", "bSortable": false},
			{ },
			{ }
		]
	});
	$('#cfgvalTable').dataTable({
		"bPaginate": false,
		"bJQueryUI": true,
		"bRetrieve": true,
		"sPaginationType": "bs_normal",
		"oLanguage": {"sSearch": ""},
		"fnPreDrawCallback": function( oSettings ) {
			$('.dataTables_filter input').addClass('form-control input-sm');
			$('.dataTables_filter input').css('width', '200px');
			$('.dataTables_length select').addClass('form-control input-sm');
			$('.dataTables_length select').css('width', '75px');
			$('.dataTables_filter input').attr('placeholder', 'Search');
		},
		"aoColumns": [
			{ "sClass": "center", "bSortable": false},
			{ },
			{ },
			{ },
			{ }
		]
	});
} );