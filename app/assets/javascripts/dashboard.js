( function() {

	console.log("Funciton is ready")
	
	$('.thai_title_field').on('keypress',function(){
		console.log("KP")

		$('.update-button').removeAttr('disabled')
	})

	var inputsChanged = function(old_titles){
		new_title = getCurrentTitle()
////////
	}


	var getCurrentTitle = function() {
		inputs = $('.thai_title_field')
		result = []
		for (i=0 ; i < inputs.length ; i++){
			result.push(inputs[i].value)
		}	
		return result	
	}


})();