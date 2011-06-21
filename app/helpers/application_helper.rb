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
    image_tag("logo.png", :alt => "Jungol", :class => "round")
  end

end
