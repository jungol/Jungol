class FilterController < ApplicationController
  before_filter :authenticate_user!

  def index
    @title = "Welcome to Jungol!"
    @groups = current_user.groups
    @state = current_user.filter_state.to_json unless current_user.filter_state.blank?
  end

  def select #RECEIVES A SINGLE GROUP FROM THE CURRENT_USERS'S GROUPS
    current_user.update_attributes(:filter_state => params[:state])
    @shown = {:main_group => {}, :shared_groups => {}, :items => {:todos => {}, :discussions => {}, :documents => {}}}
    @group = Group.find(params[:group_id])
    @shown[:main_group] = @group

    #link_to(image_tag(group.logo.url(:medium), :alt => "#{@group.name} Logo"), group_path(@group))
    @shown[:main_group][:url] = group_path @group
    @shown[:shared_groups] = @group.groups
    @shown[:items] = {:todos => {}, :discussions => {}, :documents => {}}
    i=0
    @group.shared_todos.each do |td|
      if current_user.can_view? @group, td
        @shown[:items][:todos][i] = td
        @shown[:items][:todos][i][:comments] = td.comments.size
        @shown[:items][:todos][i][:creator] = td.creator.present? ? td.creator.name : "Creator Deleted"
        @shown[:items][:todos][i][:url] = group_todo_path @group, td
        j=0
        @shown[:items][:todos][i][:shared_groups] = []
        td.shared_groups.each do |gr|
          @shown[:items][:todos][i][:shared_groups][j] = gr
          @shown[:items][:todos][i][:shared_groups][j][:url] = group_path gr
          @shown[:items][:todos][i][:shared_groups][j][:admin] = td.admin_share? gr
          j += 1
        end
        i += 1
      end
    end
    i=0
    @group.shared_discussions.each do |dc|
      if current_user.can_view? @group, dc
        @shown[:items][:discussions][i] = dc
        @shown[:items][:discussions][i][:comments] = dc.comments
        @shown[:items][:discussions][i][:by] = dc.comments.present? ? dc.comments.last.user : dc.creator
        @shown[:items][:discussions][i][:url] = group_discussion_path @group, dc
        @shown[:items][:discussions][i][:last] = dc.comments.present? ? dc.comments.last.updated_at : dc.updated_at
        j=0
        @shown[:items][:discussions][i][:shared_groups] = []
        dc.shared_groups.each do |gr|
          @shown[:items][:discussions][i][:shared_groups][j] = gr
          @shown[:items][:discussions][i][:shared_groups][j][:url] = group_path gr
          @shown[:items][:discussions][i][:shared_groups][j][:admin] = dc.admin_share? gr
          j += 1
        end
        i += 1
      end
    end
    i=0
    @group.shared_documents.each do |doc|
      if current_user.can_view? @group, doc
        @shown[:items][:documents][i] = doc
        @shown[:items][:documents][i][:comments] = doc.comments
        @shown[:items][:documents][i][:by] = doc.comments.present? ? doc.comments.last.user : doc.creator
        @shown[:items][:documents][i][:url] = group_document_path @group, doc
        @shown[:items][:documents][i][:last] = doc.comments.present? ? doc.comments.last.updated_at : doc.updated_at
        j=0
        @shown[:items][:documents][i][:shared_groups] = []
        doc.shared_groups.each do |gr|
          @shown[:items][:documents][i][:shared_groups][j] = gr
          @shown[:items][:documents][i][:shared_groups][j][:url] = group_path gr
          @shown[:items][:documents][i][:shared_groups][j][:admin] = doc.admin_share? gr
          j += 1
        end
        i += 1
      end
    end

    render :json => @shown
  end

  def filter
    @groups = []
    current_user.update_attributes(:filter_state => params[:state])
    @shown_items = {:todos => {}, :discussions => {}, :documents => {}}
    if params["state"]["selected_groups"].present?
      params["state"]["selected_groups"].each {|val| @groups << val }
    end
    origin_group = Group.find_by_id(params["state"]["origin_group"])
    @groups = Group.find(:all, :conditions => ['id in (?)', @groups])
    @groups << origin_group

    i=0
    origin_group.shared_todos.each do |td| #add this todo if it has the other groups listed in its groups
      if((current_user.can_view? origin_group, td) && ((td.shared_groups | @groups) == td.shared_groups))#union is same as original, i.e. nothing new in @groups
        @shown_items[:todos][i] = td
        @shown_items[:todos][i][:comments] = td.comments.size
        @shown_items[:todos][i][:creator] = td.creator.present? ? td.creator.name : "Creator Deleted"
        @shown_items[:todos][i][:url] = group_todo_path origin_group, td
        j=0
        @shown_items[:todos][i][:shared_groups] = []
        td.shared_groups.each do |gr|
          @shown_items[:todos][i][:shared_groups][j] = gr
          @shown_items[:todos][i][:shared_groups][j][:url] = group_path gr
          @shown_items[:todos][i][:shared_groups][j][:admin] = td.admin_share? gr
          j += 1
        end
        i += 1
      end
    end
    i=0
    origin_group.shared_discussions.each do |dc| #add this discussion if it has the other groups listed in its groups
      if((current_user.can_view? origin_group, dc) && ((dc.shared_groups | @groups) == dc.shared_groups))#union is same as original, i.e. nothing new in @groups
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
          @shown_items[:discussions][i][:shared_groups][j][:admin] = dc.admin_share? gr
          j += 1
        end
        i += 1
      end
    end
    i=0
    origin_group.shared_documents.each do |doc| #add this document if it has the other groups listed in its groups
      if((current_user.can_view? origin_group, doc) && ((doc.shared_groups | @groups) == doc.shared_groups))#union is same as original, i.e. nothing new in @groups
        @shown_items[:documents][i] = doc
        @shown_items[:documents][i][:comments] = doc.comments
        @shown_items[:documents][i][:by] = doc.comments.present? ? doc.comments.last.user : doc.creator
        @shown_items[:documents][i][:url] = group_document_path origin_group, doc
        @shown_items[:documents][i][:last] = doc.comments.present? ? doc.comments.last.updated_at : doc.updated_at
        j=0
        @shown_items[:documents][i][:shared_groups] = []
        doc.shared_groups.each do |gr|
          @shown_items[:documents][i][:shared_groups][j] = gr
          @shown_items[:documents][i][:shared_groups][j][:url] = group_path gr
          @shown_items[:documents][i][:shared_groups][j][:admin] = doc.admin_share? gr
          j += 1
        end
        i += 1
      end
    end
    render :json => @shown_items
  end
end
