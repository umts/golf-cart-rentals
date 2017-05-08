# frozen_string_literal: true
class User < ActiveRecord::Base
  has_paper_trail

  has_many   :groups_users, dependent: :destroy
  has_many   :groups, through: :groups_users

  # user is creator
  has_many   :created_rentals, class_name: Rental.name, foreign_key: :creator_id
  # user is renter
  has_many   :rented_rentals, class_name: Rental.name, foreign_key: :renter_id

  belongs_to :department

  validates :first_name, :last_name, :spire_id, :phone, :email, :department, presence: true
  validates :spire_id, length: { is: 8 }, uniqueness: true

  scope :active, -> { where(active: true) }

  def full_name
    [first_name, last_name].join ' '
  end

  ransacker :full_name, formatter: proc { |v| v.mb_chars.downcase.to_s } do |parent|
    Arel::Nodes::NamedFunction.new('LOWER',
                                   [Arel::Nodes::NamedFunction.new('concat_ws',
                                                                   [Arel::Nodes.build_quoted(' '), parent.table[:first_name], parent.table[:last_name]])])
  end

  def tag
    "#{full_name} #{spire_id}"
  end

  def has_permission?(controller, action, id = nil)
    return false unless active # inactive users shouldnt be able to do anything
    # Get a list of permissions associated with this controller and action
    relevant_permissions = GroupsUser.where(user_id: self.id, active: true).map do |x|
      x.group.permissions.where(active: true, controller: controller, action: action)
    end.flatten

    # Deny if the list is empty
    return false if relevant_permissions.empty?

    # Permit if list has a permission with no id_field
    return true if relevant_permissions.select { |x| x.id_field.nil? }.present?

    # Permit if the list has a permission with an id field, and the model instance we want matches
    model = controller.classify.constantize

    relevant_permissions.each do |perm|
      id_field_val = model.find(id).send(perm[:id_field])

      return true if id_field_val == self.id || (id_field_val.methods.include?(:include?) && id_field_val.include?(self))
    end

    # Deny if everything fails
    false
  end

  def has_group?(group)
    groups.include? group
  end

  def assignable_renters
    if has_permission?('rentals', 'assign_anyone')
      User.all
    else
      department.users
    end
  end
end
