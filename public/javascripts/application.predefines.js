function set_inputs_page_sort(){
			//$("#last_page").val(config.page);
			//$("#sort_column").val(config.sortList[0][0]);
			//$("#sort_direction").val(config.sortList[0][1]);	
			//alert("set_inputs_page_sort");
			$("tbody .tools a").each(function(){
				var href = 	$(this).attr("href");
				var rel = $(this).attr("rel");
				var search_string = $("#filterBox").val();
				if(rel && rel != ""){
					href = rel;	
				}															
				else{
					$(this).attr("rel", href);
				}
				//alert($(this).attr("rel"))
				if(href.indexOf("?",0) >= 0){
					var last_page_param_name = "&last_page=";
				}
				else{
					var last_page_param_name = "?last_page=";
				}
				
				href = href + last_page_param_name + config.page + "&sort_column=" + config.sortList[0][0] + "&sort_direction=" + config.sortList[0][1] ;
				if(search_string !="" && search_string != "undefined" && search_string != "NaN"){
					href = href + "&search_string=" + search_string;
				}
				$(this).attr("href", href);
				
				$("#sort_column").val(config.sortList[0][0]);
				$("#sort_direction").val(config.sortList[0][1]);
				$("#last_page").val(config.page);
				
				
			});
}// JavaScript Document