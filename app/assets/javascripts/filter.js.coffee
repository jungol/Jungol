# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
$ ->

  ##--HELPERS
  pluralize = (num, sin, plur = sin + "s") ->
    if num == 1
      num + " " + sin
    else if num > 1
      num + " " + plur
    else if num == 0
      "No " + plur

  linkify = (text, link, options, target = "target='_blank'") ->
    "<a #{options} href='#{link}' #{target}>#{text}</a>"

  timeify = (time, format = "mm/dd/yy hh:mm") ->
    $.timeago(time)

##--/HELPERS

  todoMarkup = (todo) ->
    shared_groups = for group in todo.shared_groups
      linkify( group.name, group.url, "class='group_link'")

    "<h3>#{linkify todo.title, todo.url, "class='todo_link'"}</h3>
      <p class=\"greenme\"><span>#{linkify pluralize( todo.tasks_count, "Task"), todo.url + "#tasks", ""}</span>  |
      last update #{timeify todo.updated_at} |
      <span>#{linkify pluralize( todo.comments.length, "comment"), todo.url + "#comments", ""}</span>  </p>
                <p>#{todo.description}</p>
                <p class=\"greenme\">Share #{shared_groups.join("  |  ")}</p>"

  discMarkup = (disc) ->
    shared_groups = for group in disc.shared_groups
      linkify( group.name, group.url, "class='group_link'")

    "<h3>#{linkify disc.title, disc.url, "class='disc_link'"}</h3>
      <p class=\"greenme\">last post #{timeify disc.last} by #{disc.by.name} |
      <span>#{linkify pluralize( disc.comments.length, "comment"), disc.url + "#comments", ""}</span>  </p>
                <p>#{disc.description}</p>
                <p class=\"greenme\">Share #{shared_groups.join("  |  ")}</p>"

  testData = {
    "origin_group": "1",

    "selected_groups":
      [
        {
          "group_id": "7"
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
        $.each data.discussions, (k,v)->
          $('#main-right').append discMarkup(v)

  $('#test_select').click ->
    $.ajax 'filter/select',
      type: 'POST',
      data: testGroup,
      dataType: 'json',
      error: (jqXHR, textStatus, errorThrown) ->
        $('body').append "AJAX Error: #{textStatus}"
      success: (data, textStatus, jqXHR) ->
        $('body').append "Successful AJAX call: #{data}"

