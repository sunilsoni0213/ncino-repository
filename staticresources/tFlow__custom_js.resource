	var oldForm = '';
	var isSubmit = false;
	$(document).ready(function () {
		oldForm = $( '.catchUnsavedChange' ).serialize();
		$( document ).on( "click", ".submitButton",function() {
			isSubmit = true;
		});
	});
	
	window.onbeforeunload = function(e) {
		if(!isSubmit && oldForm != $('.catchUnsavedChange').serialize()){
			e = e || window.event;
			var message = "Any unsaved data will be lost!"
			if (e) { // For IE and Firefox
				e.returnValue = message;
			}
			return message;
		}
	};

	function noenter(e){
		if(window.event){
			key = window.event.keyCode;//IE
		}
		else{
			key = e.which;//firefox
		}
		if(key == 13) {
			console.log("enter key!");
			onFormSubmit();
			console.log("Post Function");
			return false;
		} else{
			return true;
		}
	}