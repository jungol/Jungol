$(function() {
  $('.sortable').sortable({
    stop: function(event, ui){
      var todo_path = $(this).find('.edit_task_desc').attr('id');
      var params = $('.sortable').sortable('serialize');
      $.ajax({
        type: "POST",
        url: todo_path,
        data: params
      });
    }
  });
});
