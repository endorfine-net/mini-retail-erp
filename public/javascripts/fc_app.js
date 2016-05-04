// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function moveEvent(event, dayDelta, minuteDelta, allDay){
    jQuery.ajax({
        data: 'id=' + event.id + '&title=' + event.title + '&day_delta=' + dayDelta + '&minute_delta=' + minuteDelta + '&all_day=' + allDay,
        dataType: 'script',
        type: 'post',
        url: "/bonsai/events/move"
    });
}

function resizeEvent(event, dayDelta, minuteDelta){
    jQuery.ajax({
        data: 'id=' + event.id + '&title=' + event.title + '&day_delta=' + dayDelta + '&minute_delta=' + minuteDelta,
        dataType: 'script',
        type: 'post',
        url: "/bonsai/events/resize"
    });
}
 
function showEventDetails(event){
		$('#event_actions').css('display','block');
		$('#event_desc').html(event.start.getDate() + "." + event.start.getMonth() + "." + event.start.getFullYear() + " ("+ event.start.getHours()+":" +event.start.getMinutes() +")"+" - " + event.end.getDate() + "." + event.end.getMonth() + "." + event.end.getFullYear() + " ("+ event.end.getHours()+":" +event.end.getMinutes() +")"); 
    $('#event_desc').append("<br><br>"+event.description); 
    $('#edit_event_button').html("<input name='' type='button' value='Промени' class='calendar_form' onclick ='editEvent(" + event.id + ")' />");
    if (event.recurring) {
        title = event.title + "(Повторения)";
        $('#delete_event_button').html("<input name='' type='button' value='Изтрий само това събитие' class='calendar_form' onclick ='deleteEvent(" + event.id + ", " + false + ")' />");
        $('#delete_event_button').append("<input name='' type='button' value='Изтрий всички повторения' class='calendar_form' onclick ='deleteEvent(" + event.id + ", " + true + ")' />")
        $('#delete_event_button').append("<input name='' type='button' value='Изтрий всички бъдещи събития' class='calendar_form' onclick ='deleteEvent(" + event.id + ", \"future\")' />")
    }
		
    else {
        title = event.title;
        $('#delete_event_button').html("<input name='' type='button' value='Изтрий' class='calendar_form' onclick ='deleteEvent(" + event.id + ", " + false + ")' />");
    }$
    $('#desc_dialog').dialog({
        title: title,
        modal: true,
        width: 500,
        close: function(event, ui){
            $('#desc_dialog').dialog('destroy');
        }
        
    });
    
}


function editEvent(event_id){
	$('#desc_dialog').dialog('destroy');	
    jQuery.ajax({
        //data: 'id=' + event_id,
			  data: '',
        dataType: 'script',
        type: 'get',
        url: "/bonsai/events/edit/" + event_id,
				complete: function(){
    			//$("#event_starttime").datetime({ value: '+10min' });
					//$("#event_endtime").datetime({ value: '+10min' });
					//$("#event_alarmtime").datetime({ withDate: false, format: 'hh:ii'});
   			}
    });
}

function deleteEvent(event_id, delete_all){
    jQuery.ajax({
        //data: 'id=' + event_id + '&delete_all='+delete_all,
        dataType: 'script',
        type: 'post',
        url: "/bonsai/events/destroy/" + event_id + '&delete_all='+delete_all
    });
}

function showPeriodAndFrequency(value){

    switch (value) {
        case 'Всеки ден':
            $('#period').html('ден');
            $('#frequency').show();
						$('#event_until').show();
						$('#repeat_forever').show();
            break;
        case 'Всяка седмица':
            $('#period').html('седмица');
            $('#frequency').show();
						$('#event_until').show();
						$('#repeat_forever').show();
            break;
        case 'Всеки месец':
            $('#period').html('месец');
            $('#frequency').show();
						$('#event_until').show();
						$('#repeat_forever').show();
            break;
        case 'Всяка година':
            $('#period').html('година');
            $('#frequency').show();
						$('#event_until').show();
						$('#repeat_forever').show();
            break;
            
        default:
            $('#frequency').hide();
						$('#event_until').hide();
						$('#repeat_forever').hide();
    }
      
    
    
}
