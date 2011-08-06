# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $('.edit_todo_desc').each ->
    $(this).editInPlace(
      url:"#{$(this).attr('id')}",
      update_value: 'todo[description]')

  $('.sortable').sortable
     stop: (event, ui) ->
       todo_path = $(this).find('.edit_task_desc').attr('id')
       params = $('.sortable').sortable('serialize')
       $.ajax todo_path,
         type: "POST",
         data: params
