class DocumentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_group, :except => :share
  before_filter :find_doc, :except => [:new, :create]
  before_filter :find_origin_group, :only => :share
  before_filter :require_member, :except => :show #catch them in require_view
  before_filter :require_delete, :only => [:destroy, :edit]
  before_filter :require_view, :except => [:new, :create]

  def new
    @title = "Create a Document"
    @document = Document.new
    @privileged = current_user.privileged? @group
    @blurb = "Create a new Document to share with the world."
  end

  def create
    @document = current_user.created_documents.build(params[:document])
    if @document.save #success
      @document.interactions.create(:user => current_user, :summary => 'Created Document')
      @group.documents << @document

      #create share with original group
      current_user.share @group, @document, (params[:admins_only].present?)

      flash[:success] = "Document Created."
      #HANDLE SHARING
      if params['share'].present?
        params['share'].each do |sh|
          new_share = current_user.created_shares.new()
          if sh[1].include? "admin"
            new_share.admins_only = true
          end
          if new_share.save
            @shared_group = Group.find(sh[0])
            @document.interactions.create(:user => current_user, :summary => 'Shared Document')
            @document.item_shares << new_share
            @shared_group.item_shares << new_share
            new_share.notify_users
          end
        end
      end
      redirect_to group_document_path(@group, @document)
    else
      @title = "Create a Document"
      render :new
    end
  end

  def edit
    @title = "Edit Document"
  end

  def show
    @title = "#{@document.title} < #{@group.name}"
    @comment = current_user.comments.new
    @unshared = @group.unshared_groups(@document)
    @shared = @document.shared_groups
    @up_path = group_document_path(@group, @document)
  end

  def update
    if request.post? #AJAX update - description
      if @document.update_attributes(params[:document])
        render :text => params[:document][:description]
        return
      end
    elsif request.put?
      if @document.update_attributes(params[:document])
        flash[:success] = "Document updated."
        redirect_to @document
      end
    end
    render :nothing => true
  end

  def share
    if request.get? # SHARE PAGE
      @title = "Share #{@document.title}"
      @unshared = @group.unshared_groups(@document)
      #@share = @current_user.created_shares.new()
      render :share
      return
    elsif request.xhr? #CREATE SHARE (AJAX)
      response_text = {:flash => {}, :text => {}}
      new_share = current_user.created_shares.new()
      #DID THEY CHECK THE BOX?
      if params[:admins_only].present?
        new_share.admins_only = true
      end

      if new_share.save
        @document = Document.find(params[:id])
        @document.interactions.create(:user => current_user, :summary => 'Shared Document')
        @document.item_shares << new_share
        @shared_group.item_shares << new_share
        new_share.notify_users
        response_text[:flash] = "'#{@document.title}' has been shared with #{@shared_group.name}."
      else
        response_text[:flash] = "Problem sharing document.  Please try again."
      end
      render :json => response_text
      return

    elsif request.post? #CREATE SHARE
      new_share = current_user.created_shares.new()
      if params[:admins_only].present?
        new_share.admins_only = true
      end

      if new_share.save
        @document = Document.find(params[:id])
        @document.interactions.create(:user => current_user, :summary => 'Shared Document')
        @document.item_shares << new_share
        @shared_group.item_shares << new_share
        new_share.notify_users
        flash[:success] = "'#{@document.title}' has been shared with #{@shared_group.name}."
      else
        flash[:error] = "Problem sharing document.  Please try again."
      end
    elsif request.put? #UPDATE SHARE

    elsif request.delete? #DELETE SHARE

    else #UNKNOWN

    end
    redirect_to group_document_path(@document.group, @document)
  end

  def destroy
    title = @document.title
    @document.destroy
    flash[:success] = "Document '#{title}' destroyed."
    redirect_to @group
  end

  private

    def find_group
      @group = Group.find(params[:group_id])
    end

    def find_doc
      @document = Document.find(params[:id])
    end

    def find_origin_group
      @group = @document.group
      @shared_group = Group.find(params[:group_id])
    end

    def require_delete
      unless current_user.can_delete? @document
        redirect_to group_document_path @group, @document
      end
    end

    def require_view
      unless current_user.can_view?(@group, @document)
        flash[:error] = "You don't have permission to do that."
        redirect_to @group
      end
    end

end
