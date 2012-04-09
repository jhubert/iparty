module ApplicationHelper
  def flashes(*keys)
    keys.collect do |key|
      content_tag(:div, content_tag(:p, flash[key], nil, false), { :class => "alert alert-#{key == 'notice' ? 'info' : key}" }, false).html_safe if flash[key]
    end.join.html_safe
  end
end
