# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $('.edit_todo_desc').each ->
    $(this).editable "#{$(this).attr('id')}",
      method: "PUT"
      name: 'todo_item[description]'
      style: 'display: inline'

  $('.edit_todo_status').each ->
    $(this).editable "#{$(this).attr('id')}",
      method: "PUT"
      data:
        1:'Not Started'
        2:'In Progress'
        3:'Completed'
      name: 'todo_item[status]'
      style: 'display: inline'
      type: 'select'
      submit: 'OK'

