

$(function() {
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
		console.log("11234567789 This is loaded and work!");


		a = $('.normal-tag')
		b = []
		for (m = 0; m < a.length; m++)
		{
			b.push(a[m].textContent.trim())
		}

		c = b.join(",")
		c = c.replace(/&/g,"%26")
		shop_domain = Shopify.shop
		console.log("c is")
		console.log(c)
		$.ajax({
        	type: "get",
        	dataType: "json",
        	url: "https://shopify-tag-app.herokuapp.com/tags/get_translated_tag.json?tags="+c+"&shop_domain="+shop_domain,
        	success: function(data){
				for (i=0; i < data.length; i++){
					title = data[i].title
					t_title = data[i].thai_title
					if (/\S/.test(t_title)) {
						node =  $(".normal-tag-"+(i+1))
						if (node.children().length == 0) {
							node.text(t_title);
						} else if (node.children().length == 1) {
							node.children().text(t_title);	
						}
					}
				}				
				$('.loading').css("display","none")
				$('.loaded').css("display","true")
        	}        	
    	}) 


    	if ($('.group-tag').length > 0) {
    		a = $('.group-tag')
    		b = []
			for (m = 0; m < a.length; m++)
			{
				cat_item = a[m].className.split(" ").filter(function(element) { return element.match("group-tag-name-") })[0].split("group-tag-name-")[1]
				cat_tag = a[m].textContent.trim()
				full_value = cat_item + "_" + cat_tag
				b.push(full_value)
			}    		
			c = b.join(",")
			c = c.replace(/&/g,"%26")
			shop_domain = Shopify.shop
			console.log("c is")
			console.log(c)	
			$.ajax({
	        	type: "get",
	        	dataType: "json",
	        	url: "https://shopify-tag-app.herokuapp.com/tags/get_translated_tag.json?tags="+c+"&shop_domain="+shop_domain,
	        	success: function(data){
					for (i=0; i < data.length; i++){
						title = data[i].title
						t_title = data[i].thai_title
						console.log(t_title)
						if (/\S/.test(t_title)) {
							node =  $(".group-tag-"+(i+1))
							if (node.children().length == 0) {
								node.text(t_title);
							} else if (node.children().length == 1) {
								node.children().text(t_title);	
							}
						}
					}				
					$('.loading').css("display","none")
					$('.loaded').css("display","true")
					$('.loaded').show()
	        	}
	    	}) 			
					
    	}

   // NEW IMPLEMENTATION
   	if ($('.group-tag-cat').length > 0 ) {
   		a = $('.group-tag-cat')
   		ab = [[],[]]
   		for (m =0; m < a.length; m++){
   			ab[0].push(a[m].textContent.trim())
   		}// end for m 

   		a2 = $('.group-tag-sub')
   		for (m =0; m < a2.length; m++){
   			full_tag = a2[m].className.split(" ").filter(function(element) { return element.match("group-tag-sub-") })[0].split("group-tag-sub-")[1]
   			ab[1].push(full_tag)
   		}

   		c1 = ab[0].join(",")
   		c2 = ab[1].join(",")
   		c =  c1 + "*:*" + c2
   		c = c.replace(/&/g,"%26")
   		cc = c
   		shop_domain = Shopify.shop
		console.log("cc is")
		console.log(cc)	
		var sb
			$.ajax({
	        	type: "get",
	        	dataType: "json",
	        	url: "https://shopify-tag-app.herokuapp.com/tags/get_translated_group_tag.json?tags="+cc+"&shop_domain="+shop_domain,
	        	success: function(data){
	        		sb =data
	        		for (m=0; m < data[0].length; m++){
						// title = data[i].title
						t_cat = data[0][m].group_tag_thai_cat
						console.log(t_cat)
						if (/\S/.test(t_cat)) {
							node =  $(".group-tag-cat-"+(m+1))
							if (node.children().length == 0) {
								node.text(t_cat);
							} else if (node.children().length == 1) {
								node.children().text(t_cat);	
							}
						}

						for (i=0; i < data[1].length; i++){
							console.log("enter i loop with m,i" + (m) + (i))
							t_sub =data[1][i].group_tag_thai_sub
							console.log((m+1)+"_"+(i+1))
							console.log(t_sub)

							if (/\S/.test(t_sub)) {
								console.log("node")
								console.log($(".group-tag-sub-"+(m+1)+"_"+(i+1)))
								node =  $(".group-tag-sub-"+(m+1)+"_"+(i+1))
								if (node.children().length == 0) {
									node.text(t_sub);
								} else if (node.children().length == 1) {
									node.children().text(t_sub);	
								}
							}							
						}//end for for i

	        		} // end for m 
	        	}
	    	}) // end of ajax 			


   	} // end of if grouptag



   //END IMPLEMENTATION



   // IMPLEMENTATION 2

if ($('.group-tag-cat').length > 0 ) {

	a = $('.group-tag-cat')
	ab = []
   		for (m =0; m < a.length; m++){
   			ab.push([])
   			ab[m].push(a[m].textContent.trim())
   			ab[m].push([])
   			for (i = 0; i < 1000; i++){
   				if ($('.group-tag-sub-'+(m+1)+"_"+(i+1)).length > 0) {
   					a2 = $('.group-tag-sub-'+(m+1)+"_"+(i+1))
	   				full_tag = a2[0].className.split(" ").filter(function(element) { return element.match("group-tag-sub-") })[0].split("group-tag-sub-")[1]
	   				ab[m][1].push(full_tag)
	   				} else { break ;}   				
   			}
   		}// end for m 	


   		c = ab.join("*:*")
   		c = c.replace(/&/g,"%26")
   		cc = c
   		shop_domain = Shopify.shop
		console.log("cc is")
		console.log(cc)

		var sb
			$.ajax({
	        	type: "get",
	        	dataType: "json",
	        	url: "https://shopify-tag-app.herokuapp.com/tags/get_translated_group_tag.json?tags="+cc+"&shop_domain="+shop_domain,
	        	success: function(data){
	        		sb = data
	        		for (m=0; m < data.length; m++){
	        			for (n=0; n < data[m].length; n++){ // n max 1
	        				if (n == 0){
	        					t_cat = data[m][n].group_tag_thai_cat
								console.log(t_cat)
								if (/\S/.test(t_cat)) {
									node =  $(".group-tag-cat-"+(m+1))
									if (node.children().length == 0) {
										node.text(t_cat);
									} else if (node.children().length == 1) {
										node.children().text(t_cat);	
									}
								} //end of if test t cat	
	        				}else{
	        					for (l=0; l < data[m][n].length; l++){
		        					t_sub = data[m][n][l].group_tag_thai_sub
									console.log(t_sub)

									if (/\S/.test(t_sub)) {
										console.log("node")
										console.log($(".group-tag-sub-"+(m+1)+"_"+(l+1)))
										node =  $(".group-tag-sub-"+(m+1)+"_"+(l+1))
										if (node.children().length == 0) {
											node.text(t_sub);
										} else if (node.children().length == 1) {
											node.children().text(t_sub);	
										}
									}	
								}        					

	        				} // end of else
	        			} // end of n
	        		} //end of m

	        	}
	    	}) // end of ajax		


}


   //







    	if ( $('.specific-translate-tag').length > 0 ) {
    		tag_name = $('.specific-translate-tag').text()
    		tag_name = tag_name.replace(/&/g,"%26")
			$.ajax({
        		type: "get",
        		dataType: "json",
        		url: "https://shopify-tag-app.herokuapp.com/tags/get_translated_tag.json?tags="+tag_name+"&shop_domain="+shop_domain,
        		success: function(data){
        			translated_title = data[0].thai_title
        			$(".specific-translate-tag").text(translated_title)
        		}
    		});
		}
		
		


		
    });








