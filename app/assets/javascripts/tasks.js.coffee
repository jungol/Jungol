# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $('.edit_task_desc').each ->
    $(this).editInPlace(
      url:"#{$(this).attr('id')}",
      update_value: 'task[description]')
      #style: 'display: inline'

#  $('.edit_task_status').each ->
#    $(this).editInPlace(
#      url: "#{$(this).attr('id')}",
#      select_options:
#        "In Progress:1, Completed:2"
#      update_value: 'task[status]'
#      field_type: 'select')

  $('.task_radio').change ->
    $.ajax "#{@id}",
      type: 'POST',
      data: "task[status]=#{@value}",
      error: (jqXHR, textStatus, errorThrown) ->
        $('body').append "AJAX Error: #{textStatus}"
      success: (data, textStatus, jqXHR) ->
        $('body').append "Successful AJAX call: #{data}"
