# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#$(document).ready(function() {
#  $('.edit_todo_item').editable('update', {
#    method :  'put',
#    submitdata: {id:0}
#  });
#});
$ ->
  $('.edit_todo_item').each ->
      $(this).editable "#{$(this).attr('id')}",
        method: "PUT"
        name: 'description'

