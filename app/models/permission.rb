# frozen_string_literal: true
class Permission < ActiveRecord::Base
  has_many :groups_permissions, dependent: :destroy
  has_many :groups, through: :groups_permissions

  validates :controller, :action, presence: true

  def self.update_permissions_table
    ActiveRecord::Base.transaction do
      delete_outdated_permissions
      create_new_permissions
    end
  end

  def name
    name = "#{controller.humanize.titleize} - #{action.humanize.titleize}"
    name += " - #{id_field}" if id_field
    name
  end

  def model
    return controller.classify.constantize
  rescue NameError
    return nil
  end

  def self.delete_outdated_permissions
    # Delete all permissions that do not map to a valid controller action
    Rails.application.eager_load!
    Permission.all.find_each do |permission|
      # first check if it is one of our special permissions
      next if SPECIAL_PERMS.include?(permission.attributes.slice('action', 'controller'))

      controller = ApplicationController.descendants.find { |c| c.name == "#{permission.controller}_controller".camelcase }
      # Destroy the permission if the controller doesn't exist
      if controller.nil?
        permission.destroy!
        next
      end

      # Destroy the permission if the action doesn't exist
      action = ApplicationController.get_actions(controller).find { |a| a == permission.action.to_s }
      if action.nil?
        permission.destroy!
        next
      end
    end
  end

  def self.create_new_permissions
    # Create a new full access permission for all controller actions that do not have one
    ApplicationController.descendants.each do |controller| # get all children and grand children
      ApplicationController.get_actions(controller).each do |action|
        Permission.find_or_create_by(controller: controller.name.gsub!('Controller', '').underscore, action: action, id_field: nil)
      end
    end

    # Handle our special perms
    SPECIAL_PERMS.each do |p|
      Permission.where(p).first_or_create
    end
  end
end
