# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
$ ->
  #VARIABLES
  filterData = {
    "origin_group": "1",
    "selected_groups": []
  }

  tbody = $('.item#todos > .item-body')
  dbody = $('.item#discussions > .item-body')
  cbody = $('.item#docs > .item-body')
  ginfo = $('.group-info')

  newData = $.parseJSON($('input#state').val())
  filterData = $.extend(filterData, newData)

  [todoCount, discCount, docCount] = [0, 0, 0]

  setHeights = ->
    ht = $('.main-right').height()
    myht = ($('.my_group_ul li').length * 62) + 26
    conht = ($('.con_group_ul li').length * 62) + 26
    newht = Math.max(ht, myht, conht)
    $('.content-bg').height(newht)
    $('#my-groups').animate({height:newht}, 200 )
    $('#con-groups').animate({height:newht}, 200 )
    $('#my-groups-over').height(newht)

  setState = ->
    [todoCount, discCount, docCount] = [0, 0, 0]
    #SET GROUP AS SELECTED
    org = filterData.origin_group
    $('#my-groups li').each ->
       if @.id == org
         $(@).toggleClass('selected')

    $('#my-groups').switchClass 'main-left', 'secondary-left', -> #move to left, gray out
      $('#my-groups-over').height($('#my-groups').height() + 2).show()
      $(@).css {'opacity': 0.5}

    #GET CONNECTED GROUPS
    $.ajax 'filter/select',
      type: 'POST',
      data: {"group_id": org, "state": filterData},
      dataType: 'json',
      error: (jqXHR, textStatus, errorThrown) ->
        $('body').append "AJAX Error: #{textStatus}"
      success: (data, textStatus, jqXHR) ->
        #Clear selected groups, populate new
        $('.con_group_ul').empty()
        $.each data.shared_groups, (k,v) ->
          $('.con_group_ul').append conGroupMarkup(v)
        $('.con_group_ul').append addCon(org)
        #show main group header
        ginfo.empty().append groupInfoMarkup(data.main_group)

        #MARK CONNECTED SELECTED

        $('.con_group_ul li').each ->
          if $.inArray("#{@.id}", filterData.selected_groups) > -1
             $(@).toggleClass('selected')


    #GET ITEMS
    tbody.fadeTo(900, 0)
    dbody.fadeTo(900, 0)
    cbody.fadeTo(900, 0)
    $.ajax 'filter/filter',
      type: 'POST',
      data: {"state": filterData},
      dataType: 'json',
      error: (jqXHR, textStatus, errorThrown) ->
        $('body').append "AJAX Error: #{textStatus}"
      success: (data) ->
        rePopItems(data)

  if newData.length == 0 #First time visiting the page
    #HIDE SOME STUFF
    $('#con-groups').hide()
    $('#main-items').hide()
    $('#my-groups-over').hide()
    setHeights()
  else
    $('#my-groups-over').mouseenter ->
      $('#my-groups').css {'opacity':1}
    $('#my-groups-over').mouseleave ->
      $('#my-groups').css {'opacity':0.5}
    $('#main-welcome').hide()
    setState()
    setHeights()


  #SHOW WELCOME HEADER


  ##--HELPERS
  pluralize = (num, sin, plur = sin + "s") ->
    if num == 1
      num + " " + sin
    else if num > 1
      num + " " + plur
    else if num == 0
      "No " + plur

  linkify = (text, link, options) ->
    "<a #{options} href='#{link}'>#{text}</a>"

  timeify = (time, format = "mm/dd/yy hh:mm") ->
    $.timeago(time)

  b = (text) ->
    "<b>#{text}</b>"

  getGroups = (item) ->
    for group in item.shared_groups
      if group.id == item.group_id then group.name += "*"
      found = $.inArray("#{group.id}", filterData.selected_groups )
      if found > -1 or "#{group.id}" == filterData.origin_group ##Group in filter
        linkify( b(group.name), group.url, "class='group_link'")
      else #add to list
        linkify( group.name, group.url, "class='group_link'")

  addCon = (_group_id) ->
    "<li class=\"add\"><a href='/groups/#{_group_id}/link'>Add a Connection</a></li>"

##--/HELPERS

  createNewLinks = (groupID) ->
    $('.item#todos > .item-head a').attr('href', "/groups/#{groupID}/todos/new")
    $('.item#discussions > .item-head a').attr('href', "/groups/#{groupID}/discussions/new")
    $('.item#docs > .item-head a').attr('href', "/groups/#{groupID}/documents/new")

  todoMarkup = (todo) ->
    shared_groups = getGroups(todo)
    todoCount++

    "<h3 class=\"#{if todoCount == 1 then "top" else ""}\">#{linkify todo.title, todo.url, "class='todo_link'"}</h3>
      <p class=\"greenme\"><span>#{linkify pluralize( todo.tasks_count, "Task"), todo.url + "#tasks", ""}</span>  |
      last update #{timeify todo.updated_at} |
      <span>#{linkify pluralize( todo.comments.length, "comment"), todo.url + "#comments", ""}</span>  </p>
                <p>
                  #{if todo.description.length > 200 then todo.description.substr(0,200) + "..." else todo.description}
                </p>
                <p class=\"greenme\">Shared between  #{shared_groups.join("  |  ")}</p>"

  discMarkup = (disc) ->
    shared_groups = getGroups(disc)
    discCount++

    "<h3 class=\"#{if discCount == 1 then "top" else ""}\">#{linkify disc.title, disc.url, "class='disc_link'"}</h3>
      <p class=\"greenme\">last post #{timeify disc.last} by #{if disc.by==null then "[User Deleted]" else disc.by.name} |
      <span>#{linkify pluralize( disc.comments.length, "comment"), disc.url + "#comments", ""}</span>  </p>
                <p>
                  #{if disc.description.length > 200 then disc.description.substr(0,200) + "..." else disc.description}
                </p>
                <p class=\"greenme\">Shared between  #{shared_groups.join("  |  ")}</p>"

  docMarkup = (doc) ->
    shared_groups = getGroups(doc)
    docCount++

    "<h3 class=\"#{if docCount == 1 then "top" else ""}\">#{linkify doc.title, doc.url, "class='doc_link'"}</h3>
      <p class=\"greenme\">last post #{timeify doc.last} by #{if doc.by==null then "[User Deleted]" else doc.by.name} |
      <span>#{linkify pluralize( doc.comments.length, "comment"), doc.url + "#comments", ""}</span>  </p>
                <p>
                  #{if doc.description.length > 200 then doc.description.substr(0,200) + "..." else doc.description}
                </p>
                <p class=\"greenme\">Shared between  #{shared_groups.join("  |  ")}</p>"

  conGroupMarkup = (group) ->
    "<li id='#{group.id}' class='con_group_li'>#{group.name}</li>"

  groupInfoMarkup = (group) ->
    "<div class='group-img>'<span class='group-img-wrap'>"+
      linkify(
        "<img src=\"#{if group.logo_file_name==null then '/assets/group-img-default.png' else "http://s3.amazonaws.com/jungol_images/app/public/system/logos/#{group.id}/medium/#{group.logo_file_name}"}\"
    alt=\"#{group.name}\"/>"
    ,group.url) +
      "</span></div><div class='group-text'><h1>#{group.name}</h1><p><a href=\"/groups/#{group.id}\">Group Info</a> |
      <a href=\"/users/invitation/new\" >Invite New User</a></p>
      <p class=\"blurb\">
      #{if group.about.length > 150 then group.about.substr(0,150) + "..." else group.about}
      </p></div>"

  #gets items after group is selected
  getItems = (_group_id) ->
    [todoCount, discCount, docCount] = [0, 0, 0]
    tbody.fadeTo(900, 0)
    dbody.fadeTo(900, 0)
    cbody.fadeTo(900, 0)
    ginfo.fadeTo(900, 0)
    filterData.origin_group = _group_id
    createNewLinks(_group_id)
    $.ajax 'filter/select',
      type: 'POST',
      data: {"group_id": _group_id, "state": filterData},
      dataType: 'json',
      error: (jqXHR, textStatus, errorThrown) ->
        $('body').append "AJAX Error: #{textStatus}"
      success: (data, textStatus, jqXHR) ->
        #Clear selected groups, populate new
        $('.con_group_ul').empty()
        filterData.selected_groups = []
        $.each data.shared_groups, (k,v) ->
          $('.con_group_ul').append conGroupMarkup(v)
        $('.con_group_ul').append addCon(_group_id)
        ginfo.empty().append groupInfoMarkup(data.main_group)
        #Populate items connected to origin group
        rePopItems(data.items)
        ginfo.stop().fadeTo(500, 1)
        setHeights()

  rePopItems = (data) ->
    tbody.empty()
    dbody.empty()
    cbody.empty()
    $.each data.todos, (k,v)->
      tbody.append todoMarkup(v)
    $.each data.discussions, (k,v)->
      dbody.append discMarkup(v)
    $.each data.documents, (k,v)->
      cbody.append docMarkup(v)
    if $.isEmptyObject(data.discussions) then dbody.append "<p style='opacity:0.6'>No Discussions.</p>"
    if $.isEmptyObject(data.todos) then tbody.append "<p style='opacity:0.6'>No Todos.</p>"
    if $.isEmptyObject(data.documents) then cbody.append "<p style='opacity:0.6'>No Documents.</p>"
    tbody.stop().fadeTo(500, 1)
    dbody.stop().fadeTo(500, 1)
    cbody.stop().fadeTo(500, 1)
    setHeights()


  $('#my-groups-over').click ->
    $(@).unbind('mouseenter mouseleave')
    $(@).hide()
    $('#con-groups').hide('slide', {direction:'right'}, 300)#HIDE CONNECTED GROUPS
    $('#my-groups').switchClass('secondary-left', 'main-left', 300) #move to right, ungray

  #CLICK ON ONE OF YOUR GROUPS
  $('.my_group_li').click ->
    $('#main-welcome').hide()
    $('#main-items').show()
    if not $(@).hasClass('selected') #If it's not already selected
      getItems(@.id)
      $(@).siblings().removeClass('selected') #unselect all
      $(@).toggleClass('selected') #Mark as selected

    $('#con-groups').show('slide', { direction:'right'}, 300 ) #SHOW CONNECTED GROUPS
    #ADD HOVER FUNCTION
    $('#my-groups-over').mouseenter ->
      $('#my-groups').css {'opacity':1}
    $('#my-groups-over').mouseleave ->
      $('#my-groups').css {'opacity':0.5}
    #MARK 'MY GROUPS' INACTIVE, SHOW OVER-DIV
    $('#my-groups').switchClass 'main-left', 'secondary-left', 300, -> #move to left, gray out
      $('#my-groups-over').height($('#my-groups').height() + 2).show()
      $(@).css {'opacity': 0.5}


  $('.con_group_li').live 'click',  ->
    [todoCount, discCount, docCount] = [0, 0, 0]
    $(@).toggleClass('selected')
    tbody.fadeTo(900, 0)
    dbody.fadeTo(900, 0)
    cbody.fadeTo(900, 0)
    found = $.inArray(@.id, filterData.selected_groups)
    if found > -1 ##Group WAS selected, remove it from list
      filterData.selected_groups.splice(found, 1)
    else #add to list
      filterData.selected_groups.push(@.id)

    $.ajax 'filter/filter',
      type: 'POST',
      data: {"state": filterData},
      dataType: 'json',
      error: (jqXHR, textStatus, errorThrown) ->
        $('body').append "AJAX Error: #{textStatus}"
      success: (data) ->
        rePopItems(data)
