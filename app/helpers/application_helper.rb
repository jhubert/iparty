module ApplicationHelper
  def flashes(*keys)
    keys.collect do |key|
      content_tag(:div, content_tag(:p, flash[key], nil, false), { :class => "flash #{key}" }, false).html_safe if flash[key]
    end.join.html_safe
  end
end
