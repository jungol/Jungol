class InteractionMailer < ActionMailer::Base
  default :from => "Jungol Team <no-reply@jungolhq.com>"

  def new_share(user,share)
    @share = share
    @user = user

    case @share.item_type
    when "Todo"
      item_string = "to-do list was just added"
    when "Discussion"
      item_string  = 'discussion was just added'
    when "Document"
      item_string = 'document was just uploaded'
    end
    mail(:to => user.email, :subject => "A new #{item_string} to your group on Jungol")
  end

  def new_todo_task(tasks, user, creator)
    @tasks = tasks
    @todo = @tasks.first.todo
    @user = user
    @creator = creator
    if tasks.count == 1
      subject = "A new task has been added to your to-do list on Jungol"
    else
      subject = "Some new tasks have been added to your to-do list on Jungol"
    end

    mail(:to => user.email, :subject => subject)
  end

  def new_comment(comment, user, item)
    @item = item
    @comment = comment
    @user = user

    case comment.item_type
    when "Todo"
      @item_string = "to-do list"
    when "Discussion"
      @item_string  = 'discussion'
    when "Document"
      @item_string = 'document'
    end
    mail(:to => user.email, :subject => "A new comment was added to your #{@item_string} on Jungol")
  end
end
