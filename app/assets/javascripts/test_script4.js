


(function(){
		var loadScript = function(url, callback){

 		 /* JavaScript that will load the jQuery library on Google's CDN.
		     We recommend this code: http://snipplr.com/view/18756/loadscript/.
   		  Once the jQuery library is loaded, the function passed as argument,
		     callback, will be executed. */

		};

		var myAppJavaScript = function($){
 		 /* Your app's JavaScript here.
  		   $ in this scope references the jQuery object we'll use.
  		   Don't use 'jQuery', or 'jQuery191', here. Use the dollar sign
  		   that was passed as argument.*/
  		   	console.log('Your app is using jQuery version '+$.fn.jquery)
  			$('body').append('<p>Your app is using jQuery version '+$.fn.jquery+'</p>');
		};
  
		if ((typeof jQuery === 'undefined') || (parseFloat(jQuery.fn.jquery) < 1.7)) {
  		loadScript('//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js', function(){
  		  jQuery191 = jQuery.noConflict(true);
  		  console.log("this loop2")
  		  myAppJavaScript(jQuery191);
  		});
		} else {
		 console.log("this loop1")	
 		 myAppJavaScript(jQuery);
		}

		console.log('Your app is using jQuery version '+jQuery.fn.jquery)
		console.log("1123456 This is loaded and work!");
		console.log("1123456 This is loaded and work!");
		console.log("1123456 This is loaded and work!");
		console.log("1123456 This is loaded and work!");
		console.log("1123456 This is loaded and work!");
		console.log("1123456 This is loaded and work!");
		console.log("1123456 This is loaded and work!");

		$('.normal-tag').html("<span> แท้กถูกเปลี่ยน </span>")
		
		
    })();





