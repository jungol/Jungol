# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
$ ->
  #VARIABLES
  filterData = {
    "origin_group": "1",
    "selected_groups": []
  }
  onGroup = true

  #HIDE SOME STUFF
  $('#con-groups').hide()
  $('#main-items').hide()
  $('#my-groups-over').hide()

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

  createNewLinks = (groupID) ->
    $('.item#todos > .item-head a').attr('href', "/groups/#{groupID}/todos/new").attr('target', '_blank')
    $('.item#discussions > .item-head a').attr('href', "/groups/#{groupID}/discussions/new").attr('target', '_blank')

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

  groupInfoMarkup = (group) ->
    "<img src='/assets/prssa-logo.png' /><h1>#{group.name}</h1><p><a href=\"#\">Group Info</a> | <a href=\"#\">Invite New Members</a></p>
      <p class=\"blurb\">#{group.about}</p>"

  #gets items after group is selected
  getItems = (_group_id) ->
    tbody = $('.item#todos > .item-body')
    dbody = $('.item#discussions > .item-body')
    tbody.fadeTo(900, 0)
    dbody.fadeTo(900, 0)
    filterData.origin_group = _group_id
    createNewLinks(_group_id)
    $.ajax 'filter/select',
      type: 'POST',
      data: {"group_id": _group_id},
      dataType: 'json',
      error: (jqXHR, textStatus, errorThrown) ->
        $('body').append "AJAX Error: #{textStatus}"
      success: (data, textStatus, jqXHR) ->
        #Clear selected groups, populate new
        $('.con_group_ul').empty()
        filterData.selected_groups = []
        $.each data.shared_groups, (k,v) ->
          $('.con_group_ul').append conGroupMarkup(v)
        $('.con_group_ul').append addCon
        $('.group-info').empty().append groupInfoMarkup(data.main_group)
        #Populate items connected to origin group
        tbody.empty()
        dbody.empty()
        $.each data.items.todos, (k,v)->
          tbody.append todoMarkup(v)
        $.each data.items.discussions, (k,v)->
          dbody.append discMarkup(v)
        if $.isEmptyObject(data.items.discussions) then dbody.append "<p>No Discussions.</p>"
        if $.isEmptyObject(data.items.todos) then tbody.append "<p>No Todos.</p>"
        tbody.stop().fadeTo(500, 1)
        dbody.stop().fadeTo(500, 1)

  $('#my-groups-over').click ->
    $('#con-groups').hide('slide', {direction:'right'}, 300)#SHOW CONNECTED GROUPS
    $('#my-groups').switchClass('secondary-left', 'main-left', 300) #move to right, ungray
    $(@).hide()


  #CLICK ON ONE OF YOUR GROUPS
  $('a.my_group_li').click ->
    $('#main-welcome').hide()
    $('#main-items').show()
    getItems(@.id)
    $('ul.my_group_ul li').removeClass('selected') #unselect all
    $('li', @).toggleClass('selected') #Mark as selected
    $('#con-groups').show('slide', { direction:'right'}, 300 ) #SHOW CONNECTED GROUPS
    $('#my-groups').switchClass 'main-left', 'secondary-left', 300, -> #move to left, gray out
      $('#my-groups-over').height($('#my-groups').height() + 2).show()




  #SELECT SHARED GROUP
  $('a.con_group_li').live 'click',  ->
    $('li', @).toggleClass('selected')
    tbody = $('.item#todos > .item-body')
    dbody = $('.item#discussions > .item-body')
    tbody.fadeTo(900, 0)
    dbody.fadeTo(900, 0)
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
        tbody.empty()
        dbody.empty()
        $.each data.todos, (k,v)->
          tbody.append todoMarkup(v)
        $.each data.discussions, (k,v)->
          dbody.append discMarkup(v)
        if $.isEmptyObject(data.discussions) then dbody.append "<p>No Discussions.</p>"
        if $.isEmptyObject(data.todos) then tbody.append "<p>No Todos.</p>"
        tbody.stop().fadeTo(500, 1)
        dbody.stop().fadeTo(500, 1)
