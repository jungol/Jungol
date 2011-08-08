# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $('#add-task-form').hide()

  $('#add-task-button').click ->
    $('#add-task-form').toggle()

  $('.edit_todo_desc').each ->
    $(this).editInPlace(
      url:"#{$(this).attr('id')}",
      field_type: "textarea",
      update_value: 'todo[description]')

  $('.sortable').sortable
     stop: (event, ui) ->
       todo_path = $(this).find('.edit_task_desc').attr('id')
       params = $('.sortable').sortable('serialize')
       $.ajax todo_path,
         type: "POST",
         data: params
