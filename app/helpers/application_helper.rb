module ApplicationHelper
  def title
    base_title = "Jungol"
    if @title.nil?
      base_title
    else
      "#{base_title} - #{@title}"
    end
  end

  def logo
    image_tag("logo-new.png", :alt => "Jungol", :class => "logo")
  end

  def to_hash
    self.inject({}) { |h, i| h[i] = i; h }
  end

  def timeago(time, options = {})
    options[:class] += " timeago"
    content_tag(:span, time.to_s, options.merge(:title => time.getutc.iso8601)) if time
  end
  def link_to_comment_item(comment)
      
    case comment.item_type
    when 'Discussion'
      item = Discussion.find(comment.item_id)
      return link_to item.title, group_discussion_url(item.group, item, :path_only => false), :path_only => false
    when 'Document'
      item = Document.find(comment.item_id)
      return link_to item.title, group_document_url(item.group, item, :path_only => false), :path_only => false
    when 'Todo'
      item = Todo.find(comment.item_id)
      return link_to item.title, group_todo_url(item.group, item, :path_only => false), :path_only => false
    end
  end

end
