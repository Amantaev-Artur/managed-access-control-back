class Access < ApplicationRecord
  belongs_to :access_type, class_name: 'AccessType'
  belongs_to :author, class_name: 'User'

  has_many :groups_accesses, class_name: 'GroupsAccess', dependent: :delete_all
  has_many :groups, through: :groups_accesses, class_name: 'Group'
end
