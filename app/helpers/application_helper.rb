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

    # Always create the link if it isn't a relative path
    return super(name, url_options, html_options, &block) if !url.start_with?("/")

    # Assume get
    method = :get
    # Replace with specific method if provided
    method = options[:method] if options and options[:method]
    # Replace put with patch to fix issue with some routes and rails 4
    method = :patch if method == :put

    # Try to recognize the route
    route = Rails.application.routes.recognize_path url, method: method

    # Return the link as normal if the current user has the permission
    return super(name, url_options, html_options, &block) if @current_user.has_permission?(route[:controller], route[:action], route[:id])

    # Raise an error if the link is hidden but the user is omni and should see all links
    #raise "Link not rendered for omni user, please check this" if @current_user.groups.find_by(name: "omni").present?
  end

  def button_to(*args)
    raise "Button to is not protected by permissions"
  end
end
