// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
update_task_status = function (id, s) {
  var task_id = id.substr(5)
  var status = s.substr(7)
  var url = "/tasks/"+task_id+"/update_status";
  var new_class
  
  switch (parseInt(status)) {
  case 0:
    new_class = "fa fa-square-o"
    break;
  case 1:
    new_class = "fa fa-pencil-square-o"
    break;
  case 2:
    new_class = "fa fa-check-square-o"
    break;
  default:
    new_class = "fa fa-spinner"
  }
  
  jQuery.ajax({ url: url, 
          dataType: "script",
          data: "status="+status,
					type: "PUT",
          complete:
            function(xhr){	      
              $("#task-status-"+task_id).attr("class",new_class)
          },
          error:
            function(xhr){             
              console.log("Trigger error #{task_id}")
          }
         }
  );
  return false;
}
