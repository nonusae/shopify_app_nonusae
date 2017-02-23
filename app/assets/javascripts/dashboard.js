( function() {

	console.log("Funciton is ready")

	$('.thai_title_field').on('input',function(){
		eventTargetId = event.target.id
		flagLabel(eventTargetId)

		$('.update-button').removeAttr('disabled')
	})

	var flagLabel = function(eventTargetId){

		id= eventTargetId.replace("field-","")
		label = $('#label-'+id)

		if (label[0].class == "flagedLabel") {

		}else{
			label[0].class = "flagedLabel"
			label[0].textContent += "" 
		}

	}




})();