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
    image_tag("logo-new.png", :alt => "Jungol")
  end

  def to_hash
    self.inject({}) { |h, i| h[i] = i; h }
  end

end
