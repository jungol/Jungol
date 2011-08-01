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

  addCon = "<a href=\"#\"><li class=\"add\">Add a Connection</li></a>"

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

  conGroupMarkup = (group) ->
    "<a id='#{group.id}' href='#' class='con_group_li'><li>#{group.name}</li></a>"

  filterData = {
    "origin_group": "1",
    "selected_groups": []
  }

  #CLICK ON MY GROUP
  $('a.my_group_li').click ->
    $.ajax 'filter/select',
      type: 'POST',
      data: {"group_id": @.id},
      dataType: 'json',
      error: (jqXHR, textStatus, errorThrown) ->
        $('body').append "AJAX Error: #{textStatus}"
      success: (data, textStatus, jqXHR) ->
        $('.con_group_ul').empty()
        filterData.selected_groups = []
        $.each data.shared_groups, (k,v) ->
          $('.con_group_ul').append conGroupMarkup(v)
        $('.con_group_ul').append addCon

  #SELECT SHARED GROUP
  $('a.con_group_li').live 'click',  ->
    $('li', @).toggleClass('selected')

    found = $.inArray(@.id, filterData.selected_groups)
    if found > -1 ##Group WAS selected, remove it from list
      filterData.selected_groups.splice(found, 1)
    else #add to list
      filterData.selected_groups.push(@.id)

    $.ajax 'filter/filter',
      type: 'POST',
      data: filterData,
      dataType: 'json',
      error: (jqXHR, textStatus, errorThrown) ->
        $('body').append "AJAX Error: #{textStatus}"
      success: (data) ->
        $.each data.todos, (k,v)->
          $('#item.todo').append todoMarkup(v)
        $.each data.discussions, (k,v)->
          $('#item.discussions').append discMarkup(v)

