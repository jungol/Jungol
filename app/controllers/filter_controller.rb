class FilterController < ApplicationController

  def index
    @groups = current_user.groups #Placeholder
    @current_todos, @current_discussions = [[], []]
    @groups.each do |group|
      @current_todos = @current_todos | group.todos
      @current_discussions = @current_discussions | group.discussions
    end
  end

  def select #RECEIVES A SINGLE GROUP FROM THE CURRENT_USERS'S GROUPS
    @shown = {:main_group => {}, :shared_groups => {}, :items => {:todos => {}, :discussions => {}}}
    @group = Group.find(params[:group_id])
    @shown[:main_group] = @group
    @shown[:shared_groups] = @group.groups
    @shown[:items][:todos] = @group.shared_todos
    @shown[:items][:discussions] = @group.shared_discussions

    render :json => @shown
  end

  def filter
    @groups = []
    @shown_items = {:todos => {}, :discussions => {}}
    params["selected_groups"].each {|k,v| @groups << v["group_id"]}
    @groups = Group.find(:all, :conditions => ['id in (?)', @groups])

    i=0
    group1 = @groups.first  #start with first, since this is an intersect
    group1.shared_todos.each do |td| #add this todo if it has the other groups listed in its groups
      if((td.shared_groups | @groups) == td.shared_groups) #union is same as original, i.e. nothing new in @groups
        @shown_items[:todos][i] = td
        @shown_items[:todos][i][:comments] = td.comments.size
        @shown_items[:todos][i][:creator] = td.creator.as_json(:only => [:name])
        @shown_items[:todos][i][:shared_groups] = td.shared_groups.collect {|gr| gr.name}
        i += 1
      end
    end
    i=0
    group1.shared_discussions.each do |dc| #add this discussion if it has the other groups listed in its groups
      if((dc.shared_groups | @groups) == dc.shared_groups) #union is same as original, i.e. nothing new in @groups
        @shown_items[:discussions][i] = dc
        i += 1
      end
    end
    render :json => @shown_items
  end
end
