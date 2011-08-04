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

end
