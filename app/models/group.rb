class Group < ApplicationRecord
  has_ancestry

  belongs_to :author, class_name: "User"

  has_many :users_groups, dependent: :delete_all
  has_many :users, through: :users_groups

  has_many :groups_accesses, dependent: :delete_all
  has_many :accesses, through: :groups_accesses
end
