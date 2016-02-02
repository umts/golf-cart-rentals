class User < ActiveRecord::Base
  has_paper_trail

  validates :first_name, :last_name, :username, :spire, :phone, :email, presence: true
  validates :spire, uniqueness: { scope: [:username] }

  scope :active, -> { where(active: true) }

  def full_name
    return "#{self.first_name} #{self.last_name}"
  end
end
