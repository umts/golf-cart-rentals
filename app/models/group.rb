# frozen_string_literal: true
class Group < ActiveRecord::Base
  has_many :groups_users, dependent: :destroy
  has_many :users, through: :groups_users
  has_many :groups_permissions, dependent: :destroy
  has_many :permissions, through: :groups_permissions

  validates :name, :description, presence: true
  validates :name, uniqueness: true
end
