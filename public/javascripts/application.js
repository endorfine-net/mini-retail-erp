$(document).ready(function() {
	preload_image_assets();
	setDependencies();
	$("form").submit(function() {
		$(this).find("input[type=submit]").attr("disabled", true);
	});
});

var ADAPT_CONFIG = {
  // Where is your CSS?
  path: '/stylesheets/',

  // false = Only run once, when page first loads.
  // true = Change on window resize and page tilt.
  dynamic: true,

  // Optional callback... myCallback(i, width)
  //callback: myCallback,

  // First range entry is the minimum.
  // Last range entry is the maximum.
  // Separate ranges by "to" keyword.
  range: [
    //'0px    to 510px  = mobile.tiny.min.css',
    '0px  to 760px  = mobile.min.css',
    '760px  to 980px  = 720.min.css',
    '980px  to 1280px = 960.min.css',
    '1280px to 1600px = 1200.min.css',
    '1600px to 1920px = 1560.min.css',
    '1940px to 2540px = 1920.min.css',
    '2540px           = 2520.min.css'
  ]
};

function updateTips( t ) {
	$(".dialogFormMessage").remove();
  tips
    .html( t )
    .addClass( "ui-state-highlight" );
  setTimeout(function() {
    tips.removeClass( "ui-state-highlight", 1500 );
      }, 500 );
}
 
function checkLength( o, n, min, max ) {
  if ( o.val().length > max || o.val().length < min ) {
    o.addClass( "ui-state-error" );
	if(min != max){
		updateTips( "Стойността трябва да е между " +  min + " и " + max + " символа." );
	}else{
	  	updateTips( "Стойността трябва да е " + min + " символа." );
	}
    return false;
  } else {
  	updateTips("");
    return true;
  }
}
 
function checkRegexp( o, regexp, n ) {
  if ( !( regexp.test( o.val() ) ) ) {
    o.addClass( "ui-state-error" );
    updateTips( n );
    return false;
  } else {
  	updateTips("");
    return true;
  }
}

function isInt(o,min,max) {
	var value = o.val();
   if( !isNaN(value) && parseInt(value) == value){
   		if(min && (value < min)) {
   			o.addClass( "ui-state-error" );
			updateTips( "Стойността трябва да е най-малко " + min );
   			return false;
   		}
   		if(max && (value > max)) {
   			o.addClass( "ui-state-error" );
			updateTips( "Стойността трябва да е най-много " + max );
   			return false;
   		}
   		updateTips("");
   		return true;
   }else{
   	o.addClass( "ui-state-error" );
	updateTips( "Стойността трябва да е цяло число" );
	return false;
   }
}

function isNumeric(o,min,max) {
	var value = o.val();
   if( $.isNumeric(value)){
   		if(min && (value < min)) {
   			o.addClass( "ui-state-error" );
			updateTips( "Стойността трябва да е най-малко " + min );
   			return false;
   		}
   		if(max && (value > max)) {
   			o.addClass( "ui-state-error" );
			updateTips( "Стойността трябва да е най-много " + max );
   			return false;
   		}
   		updateTips("");
   		return true;
   }else{
   	o.addClass( "ui-state-error" );
	updateTips( "Стойността трябва да е число" );
	return false;
   }
}


function errorHighlight(e, type, icon) {
    if (!icon) {
        if (type === 'highlight') {
            icon = 'ui-icon-info';
        } else if(type === 'success'){
        	icon = 'ui-icon-check';
        } 
        else{
            icon = 'ui-icon-alert';
        }
    }
    return e.each(function () {
        $(this).addClass('ui-widget');
        var h = '<div class="ui-state-' + type + ' ui-corner-all" style="padding:0 .7em;">';
        h += '<p>';
        h += '<span class="ui-icon ' + icon + '" style="float:left;margin-right: .3em;"></span>';
        h += $(this).text();
        h += '</p>';
        h += '</div>';

        $(this).html(h);
    });
}


//error dialog
(function ($) {
    $.fn.error = function () {
        errorHighlight(this, 'error');
    };
})(jQuery);

//highlight (alert) dialog
(function ($) {
    $.fn.highlight = function () {
        errorHighlight(this, 'highlight');
    };
})(jQuery);

//highlight (alert) dialog
(function ($) {
    $.fn.success = function () {
        errorHighlight(this, 'success');
    };
})(jQuery);


function showError(text, container_id){
	$(".dialogFormMessage").remove();
	updateTips("");
	$(container_id).prepend("<div id='errorMessage' class='dialogFormMessage'>" + text + "</div>");
	$("#errorMessage").error();
	$(".dialogFormMessage").delay(5000).fadeOut(500);	
}

function showHighlight(text, container_id){
	$(".dialogFormMessage").remove();
	updateTips("");
	$(container_id).prepend("<div id='highlightMessage' class='dialogFormMessage'>" + text + "</div>");
	$("#highlightMessage").highlight();	
	$(".dialogFormMessage").delay(5000).fadeOut(500);
}

function showSuccess(text, container_id){
	$(".dialogFormMessage").remove();
	updateTips("");
	$(container_id).prepend("<div id='successMessage' class='dialogFormMessage'>" + text + "</div>");
	$("#successMessage").success();	
	$(".dialogFormMessage").delay(5000).fadeOut(500);
}


function IsValidEmail(email) {
	var filter = /^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
	return filter.test(email);
}

function transform_table_list(controller_name, method_name) {
	$(".pagesize").css("visibility", "visible");
	var last_page = $("#last_page").val();
	if (last_page == "undefined" || isNaN(last_page) || last_page == "") {
		last_page = 0;
	} else {
		last_page = parseInt(last_page);
	}

	var sort_column = $("#sort_column").val();
	var sort_direction = $("#sort_direction").val();
	var search_string = $("#search_string").val();
	$("#filterBox").val(search_string);
	
	switch (controller_name) {
		
		case "products":
			if(method_name == "statistics"){
				$("#productList").tablesorter({
					debug : false,
					sortList : [[0,0]],
					widgets : ['zebra']	
				}).tablesorterFilter({
					filterContainer : $("#filterBox"),
					filterClearContainer : $("#filterClear"),
					filterColumns : [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
					filterCaseSensitive : false
				});
			}
			else{
				$("#productList").tablesorter({
					debug : false,
					sortList : [[0,0]],
					widgets : ['zebra']	
				}).tablesorterFilter({
					filterContainer : $("#filterBox"),
					filterClearContainer : $("#filterClear"),
					filterColumns : [0, 1, 2],
					filterCaseSensitive : false
				});
			}
			break;
		case "products":
			$("#productList").tablesorter({
				debug : false,
				sortList : [[0,0]],
				widgets : ['zebra']	
			}).tablesorterFilter({
				filterContainer : $("#filterBox"),
				filterClearContainer : $("#filterClear"),
				filterColumns : [0, 1, 2],
				filterCaseSensitive : false
			});
			break;	
		case "users":
			make_tableList_tr_clickable();
			if (sort_column == "undefined" || isNaN(sort_column) || sort_column == "" || sort_direction == "undefined" || isNaN(sort_direction) || sort_direction == "") {
				var sort_list = [[3, 0]];
			} else {
				var sort_list = [[parseInt(sort_column), parseInt(sort_direction)]];
			}
			$("#tableList").tablesorter({
				debug : false,
				sortList : sort_list,
				widgets : ['zebra'],
				headers : {
					7 : {
						sorter : false
					},
					1 : {
						sorter : false
					}
				}
			}).bind("sortEnd", function() {
				apply_search_filter();
			}).tablesorterFilter({
				filterContainer : $("#filterBox"),
				filterClearContainer : $("#filterClear"),
				filterColumns : [0, 2, 3, 4, 5, 6],
				filterCaseSensitive : false
			});
			$("#tableList .header").click(function() {
				$("#tableList tfoot .first").click();
			});
			break;

        case "requests":
            make_tableList_tr_clickable();
            $("#productList").tablesorter({
                debug : false,
                //sortList : [[0,0]],
                widgets : ['zebra']
            }).tablesorterFilter({
                filterContainer : $("#filterBox"),
                filterClearContainer : $("#filterClear"),
                filterColumns : [0, 1, 2],
                filterCaseSensitive : false
            });
            break;


        default:
			make_tableList_tr_clickable();
			if (sort_column == "undefined" || isNaN(sort_column) || sort_column == "" || sort_direction == "undefined" || isNaN(sort_direction) || sort_direction == "") {
				var sort_list = [[0, 0]];
			} else {
				var sort_list = [[parseInt(sort_column), parseInt(sort_direction)]];
			}
			$("#tableList").tablesorter({
				debug : false,
				sortList : sort_list,
				widgets : ['zebra'],
				headers : {
					2 : {
						sorter : false
					}
				}
			}).bind("sortEnd", function() {
				apply_search_filter();
			}).tablesorterPager({
				container : $("#toolBoxTablePagination"),
				positionFixed : false,
				sortMultiSortKey : "ctrlKey",
				page : last_page
			}).tablesorterFilter({
				filterContainer : $("#filterBox"),
				filterClearContainer : $("#filterClear"),
				filterColumns : [0, 1],
				filterCaseSensitive : false
			});
			$("#tableList .header").click(function() {
				$("#tableList tfoot .first").click();
			});
	}
	$("#tableList").bind("sortStart", function() {
	}).bind("sortEnd", function() {
		//set_inputs_page_sort();
	}).bind("pagingEvent", function() {
		set_inputs_page_sort();
	});

	$("#productList").bind("sortStart", function() {
	}).bind("sortEnd", function() {
		//set_inputs_page_sort();
	}).bind("pagingEvent", function() {
		set_inputs_page_sort();	});
}

function apply_search_filter() {
	search_string = $("#filterBox").val();
	if (search_string != "" && search_string != "undefined") {
		$("#filterBox").keyup();
	}
}


function product_add_items() {
	var is_successful = false;
	$('#add_items').dialog({
		autoOpen : false,
		modal : true,
		width : 600,
		height : 590,
	      buttons: {
	        "Добави": function() {      	
	          var bValid = true;
	          allFields.removeClass( "ui-state-error" );
	          $(".dialogFormMessage").remove();

	  			bValid = bValid && checkLength( size, "size", 2, 2 ) && isInt(size,17,45);
	  			bValid = bValid && checkLength( delivery_price, "delivery_price", 1, 12 ) && isNumeric(delivery_price);
	  			bValid = bValid && checkLength( price, "price", 1, 12 ) && isNumeric(price);
	  			bValid = bValid && checkLength( amount, "amount", 1, 10 ) && isInt(amount);
	 
	          if ( bValid ) {
	          	$.ajax({
				  type: "POST",
				  url: "/items/add",
				  data: { 
					  	product_id: product_id.val(),
					  	datetime: datetime.val(), 
					  	color_id: color_id.find("option:selected").val(), 
					  	location_id: location_id.find("option:selected").val(), 
					  	size: size.val(), 
					  	delivery_price: delivery_price.val(), 
					  	price: price.val(),
					  	amount: amount.val(),

				  	}
				})
				  .done(function( response ) {
				  	$("#add_items").html(response);
				  	is_successful = true;
				  })
				  .fail(function( response ) {
				  	$("#add_items").html(response.responseText);
				  });
	          }
	        },
	        "Затвори": function() {
	          $( this ).dialog( "close" );
	        }
	      },
	      close: function() {	      	
	        allFields.val( "" ).removeClass( "ui-state-error" );
	        $('#add_items').html('<div style="margin-top:250px; width:inherit; text-align:center"><img src="/images/ajax-loader.gif" width="35" height="35" alt="Моля изчакайте..." /></div>');
	        if(is_successful) window.location = window.location.href;
	      }
	});
	$('.addItems').each(function() {
		$(this).click(function() {
			$('#add_items').dialog('open');
		});
	});
}

function product_multi_edit_items() {
	 var is_successful = false; 
	$('#multi_edit_price').dialog({
		autoOpen : false,
		modal : true,
		width : 600,
		height : 460,
	      buttons: {
	        "Запази": function() {      	
	          var bValid = true;
	          allFields.removeClass( "ui-state-error" );
	          $(".dialogFormMessage").remove();

	  			bValid = bValid && checkLength( price, "price", 1, 12 ) && isNumeric(price);
	  				 
	          if ( bValid ) {
	          	$.ajax({
				  type: "POST",
				  url: "/items/edit_multiple_items",
				  data: { 
					  	item_id: item_id.val(),
					  	price: price.val(),
					  	scope_type: scope_type.find("option:selected").val()

				  	}
				})
				  .done(function( response ) {
				  	is_successful = true;
				  	$("#multi_edit_price").html(response);
				    setTimeout( function() { $("#multi_edit_price").dialog('close'); }, 1000);
				  })
				  .fail(function( response ) {
				  	$("#multi_edit_price").html(response.responseText);
				    //$( this ).dialog( "close" );
				  });
	          }
	        },
	        "Затвори": function() {
	          $( this ).dialog( "close" );
	        }
	      },
	      close: function() {
	        allFields.val( "" ).removeClass( "ui-state-error" );
	        $('#multi_edit_price').html('<div style="margin-top:250px; width:inherit; text-align:center"><img src="/images/ajax-loader.gif" width="35" height="35" alt="Моля изчакайте..." /></div>');
	       if(is_successful) window.location = window.location.href;
	      }
	});
	$('.multiEditItems').each(function() {
		$(this).click(function() {
			$('#multi_edit_price').dialog('open'	);
		});
	});
}

function product_edit_item() {
	 var is_successful = false; 
	$('#edit_item').dialog({
		autoOpen : false,
		modal : true,
		width : 600,
		height : 550,
	      buttons: {
	        "Запази": function() {      	
	          var bValid = true;
	          allFields.removeClass( "ui-state-error" );
	          $(".dialogFormMessage").remove();

	  			bValid = bValid && checkLength( delivery_price, "delivery_price", 1, 12 ) && isNumeric(delivery_price);
	  			bValid = bValid && checkLength( price, "price", 1, 12 ) && isNumeric(price);
	  			bValid = bValid && checkLength( amount_current, "amount_current", 1, 10 ) && isInt(amount_current	);
	  			bValid = bValid && checkLength( amount_delivered, "amount_delivered", 1, 10 ) && isInt(amount_delivered);
	 
	          if ( bValid ) {
	          	$.ajax({
				  type: "POST",
				  url: "/items/edit",
				  data: { 
					  	item_quantity_id: item_quantity_id.val(),
					  	datetime: datetime.val(), 
					  	delivery_price: delivery_price.val(), 
					  	price: price.val(),
					  	amount_current: amount_current.val(),
					  	amount_delivered: amount_delivered.val(),

				  	}
				})
				  .done(function( response ) {
				  	is_successful = true;
				  	$("#edit_item").html(response);
				    setTimeout( function() { $("#edit_item").dialog('close'); }, 1000);
				  })
				  .fail(function( response ) {
				  	$("#edit_item").html(response.responseText);
				    //$( this ).dialog( "close" );
				  });
	          }
	        },
	        "Затвори": function() {
	          $( this ).dialog( "close" );
	        }
	      },
	      close: function() {
	        allFields.val( "" ).removeClass( "ui-state-error" );
	        $('#edit_item').html('<div style="margin-top:250px; width:inherit; text-align:center"><img src="/images/ajax-loader.gif" width="35" height="35" alt="Моля изчакайте..." /></div>');
	       if(is_successful) window.location = window.location.href;
	      }
	});
	$('.editItems').each(function() {
		$(this).click(function() {
			$('#edit_item').dialog('open'	);
		});
	});
}

function product_request_items(){
    var is_successful = false;
    $('#request_items').dialog({
        autoOpen : false,
        modal : true,
        width : 600,
        height : 540,
        buttons: {
            "Запази": function() {
                var bValid = true;
                allFields.removeClass( "ui-state-error" );

                if ( bValid ) {
                    $.ajax({
                        type: "POST",
                        url: "/requests/create",
                        data: {
                            quantity: quantity.find("option:selected").val(),
                            location_id: location_id.find("option:selected").val(),
                            item_quantity_id: item_quantity_id.val(),
                            note: note.val()
                        }
                    })
                        .done(function( response ) {
                            is_successful = true;
                            $("#request_items").html(response);
                            setTimeout( function() { $("#request_items").dialog('close'); }, 1000);
                        })
                        .fail(function( response ) {
                            $("#request_items").html(response.responseText);
                            //$( this ).dialog( "close" );
                        });
                }

            },
            "Затвори": function() {
                $( this ).dialog( "close" );
            }
        },
        close: function() {
            allFields.val( "" ).removeClass( "ui-state-error" );
            $('#request_items').html('<div style="margin-top:250px; width:inherit; text-align:center"><img src="/images/ajax-loader.gif" width="35" height="35" alt="Моля изчакайте..." /></div>');
            if(is_successful) window.location = window.location.href;
        }
    });
    $('.requestItems').each(function() {
        $(this).click(function() {
            $('#request_items').dialog('open');
        });
    });

}


function update_request(){
    var is_successful = false;
    $('#update_request').dialog({
        autoOpen : false,
        modal : true,
        width : 600,
        height : 540,
        buttons: {
            "Запази": function() {
                var bValid = true;
                allFields.removeClass( "ui-state-error" );

                if ( bValid ) {
                    $.ajax({
                        type: "POST",
                        url: "/requests/update",
                        data: {
                            id: id.val(),
                            request_status_id: request_status_id.find("option:selected").val()
                        }
                    })
                        .done(function( response ) {
                            is_successful = true;
                            $("#update_request").html(response);
                            setTimeout( function() { $("#update_request").dialog('close'); }, 1000);
                        })
                        .fail(function( response ) {
                            $("#update_request").html(response.responseText);
                            //$( this ).dialog( "close" );
                        });
                }

            },
            "Затвори": function() {
                $( this ).dialog( "close" );
            }
        },
        close: function() {
            allFields.val( "" ).removeClass( "ui-state-error" );
            $('#update_request').html('<div style="margin-top:250px; width:inherit; text-align:center"><img src="/images/ajax-loader.gif" width="35" height="35" alt="Моля изчакайте..." /></div>');
            if(is_successful) window.location = window.location.href;
        }
    });
    $('.requestUpdate').each(function() {
        $(this).click(function() {
            $('#update_request').dialog('open');
        });
    });

}

function product_deliver_items(){
		var is_successful = false; 
		$('#deliver_items').dialog({
		autoOpen : false,
		modal : true,
		width : 600,
		height : 500,
	      buttons: {
	        "Запази": function() {
	          var bValid = true;
	          allFields.removeClass( "ui-state-error" );
	 
	          if ( bValid ) {
	          	$.ajax({
				  type: "POST",
				  url: "/items/deliver",
				  data: { 
					  	amount: amount.find("option:selected").val(),
					  	datetime: datetime.val(),
					  	location_id: location_id.find("option:selected").val(),
					  	item_quantity_id: item_quantity_id.val()
				  	}
				})
				  .done(function( response ) {
				  	is_successful = true;
				  	$("#deliver_items").html(response);
				    setTimeout( function() { $("#deliver_items").dialog('close'); }, 1000);
				  })
				  .fail(function( response ) {
				  	$("#deliver_items").html(response.responseText);
				    //$( this ).dialog( "close" );
				  });
				}
	          
	        },
	        "Затвори": function() {
	          $( this ).dialog( "close" );
	        }
	      },
	      close: function() {
	        allFields.val( "" ).removeClass( "ui-state-error" );
	        $('#deliver_items').html('<div style="margin-top:250px; width:inherit; text-align:center"><img src="/images/ajax-loader.gif" width="35" height="35" alt="Моля изчакайте..." /></div>');
	      	if(is_successful) window.location = window.location.href;
	      }
	});
	$('.deliverItems').each(function() {
		$(this).click(function() {
			$('#deliver_items').dialog('open');
		});
	});
	
}


function product_sale_item(){
		var is_successful = false; 
		$('#sale_item').dialog({
		autoOpen : false,
		modal : true,
		width : 600,
		height : 550,
	      buttons: {
	        "Запази": function() {
	          var bValid = true;
	          allFields.removeClass( "ui-state-error" );
	 
	          if ( bValid ) {
	          	$.ajax({
				  type: "POST",
				  url: "/items/sale",
				  data: { 
					  	exchange_only: exchange_only.attr('checked')?true:false,
					  	price: price.val(),
					  	datetime: datetime.val(),
					  	payment_type: payment_type.find("option:selected").val(),
					  	item_quantity_id: item_quantity_id.val(),
					  	note: note.val()
				  	}
				})
				  .done(function( response ) {
				  	is_successful = true;
				  	$("#sale_item").html(response);
				  	setTimeout( function() { $("#sale_item").dialog('close'); }, 1000);
				  })
				  .fail(function( response ) {
				  	$("#sale_item").html(response.responseText);
				    //$( this ).dialog( "close" );
				  });
				}
	          
	        },
	        "Затвори": function() {
	          $( this ).dialog( "close" );
	        }
	      },
	      close: function() {
	        allFields.val( "" ).removeClass( "ui-state-error" );
	        $('#sale_item').html('<div style="margin-top:250px; width:inherit; text-align:center"><img src="/images/ajax-loader.gif" width="35" height="35" alt="Моля изчакайте..." /></div>');
	      	if(is_successful) window.location = window.location.href;
	      }
	});
	$('.saleItems').each(function() {
		$(this).click(function() {
			$('#sale_item').dialog('open');
		});
	});
	
}

function product_exchange_items(){
		var is_successful = false; 
		$('#exchange_items').dialog({
		autoOpen : false,
		modal : true,
		width : 600,
		height : 510,
	      buttons: {
	        "Запази": function() {
	          var bValid = true;
	          allFields.removeClass( "ui-state-error" );
	 
	          if ( bValid ) {
	          	$.ajax({
				  type: "POST",
				  url: "/items/exchange",
				  data: { 
					  	operation_id: operation_id.find("option:selected").val(),
					  	datetime: datetime.val(),
					  	price: price.val(),
					  	item_quantity_id: item_quantity_id.val(),
					  	note: note.val()
				  	}
				})
				  .done(function( response ) {
				  	is_successful = true;
				  	$("#exchange_items").html(response);
				    setTimeout( function() { $("#exchange_items").dialog('close'); }, 1000);
				  })
				  .fail(function( response ) {
				  	$("#exchange_items").html(response.responseText);
				    //$( this ).dialog( "close" );
				  });
				}
	          
	        },
	        "Затвори": function() {
	          $( this ).dialog( "close" );
	        }
	      },
	      close: function() {
	        allFields.val( "" ).removeClass( "ui-state-error" );
	        $('#exchange_items').html('<div style="margin-top:250px; width:inherit; text-align:center"><img src="/images/ajax-loader.gif" width="35" height="35" alt="Моля изчакайте..." /></div>');
	      	if(is_successful) window.location = window.location.href;
	      }
	});
	$('.exchangeItems').each(function() {
		$(this).click(function() {
			$('#exchange_items').dialog('open');
		});
	});
	
}

function make_productList_tr_clickable() {
	$("#productList tbody.listBody tr").each(function() {
		$(this).css("cursor", "pointer");
		$(this).click(function() {
			jQuery.ajax({
				success : function(request) {
					jQuery('#show_product').html(request);
				},
				type : 'get',
				url : '/products/' + $(this).attr("rel")
			});
			$('#show_product').dialog('open');
		});
	});
	$("#productList tbody tr .tools a").click(function(e) {
		e.stopPropagation();
	});
	$("#productList tbody tr .checkboxContainer").click(function(e) {
		e.stopPropagation();
	});
}

function make_tableList_tr_clickable() {
	//$("#tableList tbody tr").each(function(){
	$("#tableList tbody.listBody tr").each(function() {
		$(this).css("cursor", "pointer");
		//$(this).mouseover(function(){window.status = $(this).find(".tools a").first().attr("href"); return true;});
		//$(this).mouseout(function(){window.status = "";});
		$(this).click(function() {
			top.window.location = $(this).find(".tools a").first().attr("href");
		});
	});
	$("#tableList tbody tr .tools a").click(function(e) {
		e.stopPropagation();
	});
}


function preload_image_assets() {
	var images_folder = '/images/';
	MM_preloadImages(
		images_folder + 'asc.gif', 
		images_folder + 'bg.gif', 
		images_folder + 'brush3.png', 
		images_folder + 'black-grad.gif', 
		images_folder + 'bullet_square_blue.png', 
		images_folder + 'desc.gif', 
		images_folder + 'first.png', 
		images_folder + 'gray-grad-table-head.gif', 
		images_folder + 'green-grad.gif', 
		images_folder + 'green-h2-grad.gif', 
		images_folder + 'icon-archive.png', 
		images_folder + 'icon-edit.png', 
		images_folder + 'icon-exit.png',  
		images_folder + 'last.png', 
		images_folder + 'next.png', 
		images_folder + 'prev.png', 
		images_folder + 'sprite.png', 
		images_folder + 'logo.gif', 
		images_folder + 'yellow-grad.gif', 
		images_folder + 'gray-grad-2.gif', 
		images_folder + 'gray-widgets-head.gif');
}


function showSystemMessage(type, htmlText) {
	var messageType = "error";
	var form_error_type = "";
	if (type != "" && type != "undefined") {
		if (type == "highlight" || type == "form_highlight") {
			messageType = "highlight";
		}
		if (type == "form_error" || type == "form_highlight") {
			form_error_type = "form_error";
		}
	}
	var messageHtml = '	<div class="ui-widget"><div class="ui-state-' + messageType + ' ' + form_error_type + ' ui-corner-all"><p><span class="ui-icon ui-icon-info" style="float: left; margin-right: 0.3em;"></span>' + htmlText + '</p></div></div>'
	if (type == "form_error") {
		$("#form_error_message").html(messageHtml);
	} else if (type == "form_highlight") {
		$("#form_highlight_message").html(messageHtml);
	} else {
		$("#message").html(messageHtml);
	}
}

function setContentMinWidth() {
	var docWidth = $(document).width()
	var contentsWidth = $('#container').outerWidth()
	var containerMarginLeft = Math.round((docWidth - contentsWidth) / 2)
	//$('#container').css({"min-width": containerMinWidth, "margin-left":  containerMarginLeft})
	$('#container').css({
		"margin-left" : containerMarginLeft
	})
}

function toggleAllCheckBoxes(masterCheckbox, checkContainer) {
	var $container = $(checkContainer);
	$container.find("input:checkbox").each(function() {
		$(this)[0].checked = masterCheckbox[0].checked
	})
}

function MM_preloadImages() {//v3.0
	var d = document;
	if (d.images) {
		if (!d.MM_p)
			d.MM_p = new Array();
		var i, j = d.MM_p.length, a = MM_preloadImages.arguments;
		for ( i = 0; i < a.length; i++)
			if (a[i].indexOf("#") != 0) {
				d.MM_p[j] = new Image;
				d.MM_p[j++].src = a[i];
			}
	}
}

function setDependencies() {
	$(".has_dependency").each(function() {
		var child_class = $(this).attr("rel");
		var is_checked = $(this).attr("checked")
		toggleDependent(child_class, is_checked);
		$(this).change(function() {
			toggleDependent(child_class, this.checked);
		});
		//$("." + $(this).attr("rel")).attr("disabled","disabled");
	});
}

function toggleDependent(child_class, parent_checked) {
	//alert(parent_checked);
	var disabled = "";
	if (parent_checked == true) {
		disabled = false;
	} else {
		disabled = true;
	}
	//alert("disabled is " + disabled);
	$("." + child_class).attr("disabled", disabled);
}

function set_photos_switch() {
	var photo = $("#main_photo");
	$("a[rel='slideshow']").each(function() {
		$(this).attr("rel", $(this).attr("href"));
		$(this).css("cursor", "pointer");
		$(this).removeAttr("href", "#");
		$(this).removeAttr("target");
		$(this).click(function() {
			photo.css("background-image", "url(" + $(this).attr("rel") + ")");
		});
	});
}

function send_filterBox_search_string() {
	if ($("#filterBox").val() != "") {
		var the_url = "" + window.location;
		if (the_url.indexOf("?", 0) >= 0) {
			top.window.location = the_url + "&search=" + $("#filterBox").val();
		} else {
			top.window.location = the_url + "?search=" + $("#filterBox").val();
		}
	}
}

