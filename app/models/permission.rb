class Permission < ActiveRecord::Base
  has_many :groups_permissions, dependent: :destroy
  has_many :groups, through: :groups_permissions

  def self.update_permissions_table
    ActiveRecord::Base.transaction do
      # Delete all permissions that do not map to a valid controller action
      Rails.application.eager_load!
      Permission.all.each do|permission|
        controller = ApplicationController.descendants.select{ |controller| controller.name == "#{permission.controller}_controller".camelcase }.first
        # Destroy the permission if the controller doesn't exist
        if controller.nil?
          permission.destroy!
          next
        end

        # Destroy the permission if the action doesn't exist
        action = ApplicationController.get_actions(controller).select{ |action| action == "#{permission.action}" }.first
        if action.nil?
          permission.destroy!
          next
        end
      end

      # Create a new full access permission for all controller actions that do not have one
      ApplicationController.descendants.each do |controller|      # get all children and grand children
        ApplicationController.get_actions(controller).each do |action|
          Permission.find_or_create_by(controller: controller.name.gsub!("Controller","").underscore, action: action, id_field: nil)
        end
      end
    end
  end

  def name
    name = "#{controller.humanize.titleize} - #{action.humanize.titleize}"
    name += " - #{id_field}" if id_field
    return name
  end

  def model
    begin
      return controller.classify.constantize
    rescue => e
      return nil
    end
  end
end