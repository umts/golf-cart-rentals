module ApplicationHelper
  def link_to(name = nil, url_options = nil, html_options = nil, &block)
    # Convert given options to a usable url, this allows:
    #   link_to(@object) do ... end
    #   link_to "Link text", @model ...
    #   link_to "Link text", model_method_path ...
    #   link_to "Link text", model_method_path(@model.id, ...) ...
    #   link_to "Link text", "http://www.google.com" ...

    # Use name to generate url if the first arg was an object
    if name.is_a? ActiveRecord::Base
      url = url_for(name)
      options = url_options
    else
      url = url_for(url_options)
      options = html_options
    end

    # Always create the link if it isn't a relative path and not permission controlled
    return super(name, url_options, html_options, &block) unless url.start_with?('/')

    # Assume get
    method = 'get'
    # Replace with specific method if provided, replacing put with patch to fix issue with some routes and rails 4
    method = options[:method].to_s.gsub('put', 'patch') if options && options[:method]

    # Try to recognize the route
    route = Rails.application.routes.recognize_path url, method: method

    # Return the link as normal if the current user has the permission
    return super(name, url_options, html_options, &block) if @current_user.has_permission?(route[:controller], route[:action], route[:id])

    # Raise an error if the link is hidden but the user is omni and should see all links
    # raise "Link not rendered for omni user, please check this" if @current_user.groups.find_by(name: "omni").present?
  end

  def button_to(*_args)
    raise 'Button to is not protected by permissions'
  end

  # pre-format date and time fields to use bootstrap versions which work across browsers
  def date_field_tag(method, options = {})
    content_tag :div, class: 'input-group date datepicker' do
      options[:placeholder] = 'YYYY-MM-DD'
      concat text_field_tag(method, nil, options)
      concat content_tag :span, (
        content_tag :span, nil, class: 'glyphicon glyphicon-calendar'
      ), class: 'input-group-addon'
    end
  end

  def date_field(object_name, method, options = {})
    content_tag :div, class: 'input-group date datepicker' do
      options[:placeholder] = 'YYYY-MM-DD'
      concat text_field(object_name, method, options)
      concat content_tag :span, (
        content_tag :span, nil, class: 'glyphicon glyphicon-calendar'
      ), class: 'input-group-addon'
    end
  end

  def time_field(object_name, method, options = {})
    content_tag :div, class: 'input-group date timepicker' do
      options[:placeholder] = 'HH:MM AM'
      concat text_field(object_name, method, options)
      concat content_tag :span, (
        content_tag :span, nil, class: 'glyphicon glyphicon-time'
      ), class: 'input-group-addon'
    end
  end

  # Helper to handle and render multiple flash messages
  def flash_message(type, text, now = nil)
    if now
      flash.now[type] ||= []
      flash.now[type] << text
    else
      flash[type] ||= []
      flash[type] << text
    end
  end
end
