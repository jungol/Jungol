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
    origin_group = Group.find_by_id(params["origin_group"])
    @groups = Group.find(:all, :conditions => ['id in (?)', @groups])
    @groups << origin_group

    i=0
    origin_group.shared_todos.each do |td| #add this todo if it has the other groups listed in its groups
      if((td.shared_groups | @groups) == td.shared_groups) #union is same as original, i.e. nothing new in @groups
        @shown_items[:todos][i] = td
        @shown_items[:todos][i][:comments] = td.comments.size
        @shown_items[:todos][i][:creator] = td.creator.name
        @shown_items[:todos][i][:url] = group_todo_path origin_group, td
        j=0
        @shown_items[:todos][i][:shared_groups] = []
        td.shared_groups.each do |gr|
          @shown_items[:todos][i][:shared_groups][j] = gr
          @shown_items[:todos][i][:shared_groups][j][:url] = group_path gr
          j += 1
        end
        i += 1
      end
    end
    i=0
    origin_group.shared_discussions.each do |dc| #add this discussion if it has the other groups listed in its groups
      if((dc.shared_groups | @groups) == dc.shared_groups) #union is same as original, i.e. nothing new in @groups
        @shown_items[:discussions][i] = dc
        @shown_items[:discussions][i][:comments] = dc.comments
        @shown_items[:discussions][i][:by] = dc.comments.present? ? dc.comments.last.user : dc.creator
        @shown_items[:discussions][i][:url] = group_discussion_path origin_group, dc
        @shown_items[:discussions][i][:last] = dc.comments.present? ? dc.comments.last.updated_at : dc.updated_at
        j=0
        @shown_items[:discussions][i][:shared_groups] = []
        dc.shared_groups.each do |gr|
          @shown_items[:discussions][i][:shared_groups][j] = gr
          @shown_items[:discussions][i][:shared_groups][j][:url] = group_path gr
          j += 1
        end
        i += 1
      end
    end
    render :json => @shown_items
  end
end
