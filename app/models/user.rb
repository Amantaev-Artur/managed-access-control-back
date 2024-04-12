class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :users_groups, dependent: :delete_all
  has_many :groups, through: :users_groups
  has_many :accesses, through: :groups
  has_many :personal_groups, class_name: "Group", foreign_key: :author_id
  has_many :personal_accesses, class_name: "Access", foreign_key: :author_id
end
