# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
$ ->

  pluralize = (num, sin, plur) ->
    if num == 1
      num + " " + sin
    else if num > 1
      num + " " + plur
    else if num == 0
      "No " + plur

  todoMarkup = (data) ->
    shared_groups = [group.name for group in data.shared_groups]

    "<h3>#{data.title}</h3>
    <p class=\"greenme\"><span>#{pluralize data.tasks_count, "To-Do", "To-Dos"}</span>  |  created by #{data.creator.name} | <span>#{pluralize data.comments.length, "comment", "comments"}</span>  </p>
                <p>#{data.description}</p>
                <p class=\"greenme\">Share #{shared_groups}</p>"

  testData = {
    "selected_groups":
      [
        {
          "group_id": "3"
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
      success: (data) ->
        $.each data.todos, (k,v)->
          $('#main-right').append todoMarkup(v)

  $('#test_select').click ->
    $.ajax 'filter/select',
      type: 'POST',
      data: testGroup,
      dataType: 'json',
      error: (jqXHR, textStatus, errorThrown) ->
        $('body').append "AJAX Error: #{textStatus}"
      success: (data, textStatus, jqXHR) ->
        $('body').append "Successful AJAX call: #{data}"

