# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $('.edit_task_desc').each ->
    $(this).editInPlace(
      url:"#{$(this).attr('id')}",
      update_value: 'task[description]')
      #style: 'display: inline'

  $('.task_radio').change ->
    stat = @value
    li = $(@).closest('li')
    if (stat=="2") then li.addClass('completed') else li.removeClass('completed')
    $.ajax "#{@id}",
      type: 'POST',
      data: "task[status]=#{stat}",
#      error: (jqXHR, textStatus, errorThrown) ->
#        $('body').append "AJAX Error: #{textStatus}"
#      success: (data, textStatus, jqXHR) ->
#        $('body').append "Successful AJAX call: #{data}"
