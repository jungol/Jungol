# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
$ ->
  testData = {
    "selected_groups":
      [
        {
          "group_id": "2"
        },
          {
            "group_id": "1"
          }
      ]
    }

  testGroup = {
    "group_id": "2"
  }

  $('#test_filter').click ->
    $.ajax 'filter/filter',
      type: 'POST',
      data: testData,
      dataType: 'json',
      error: (jqXHR, textStatus, errorThrown) ->
        $('body').append "AJAX Error: #{textStatus}"
      success: (data, textStatus, jqXHR) ->
        $('body').append "Successful AJAX call: #{data}"

  $('#test_select').click ->
    $.ajax 'filter/select',
      type: 'POST',
      data: testGroup,
      dataType: 'json',
      error: (jqXHR, textStatus, errorThrown) ->
        $('body').append "AJAX Error: #{textStatus}"
      success: (data, textStatus, jqXHR) ->
        $('body').append "Successful AJAX call: #{data}"
