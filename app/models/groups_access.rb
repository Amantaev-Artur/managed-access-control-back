class GroupsAccess < ApplicationRecord
  belongs_to :group, class_name: "Group"
  belongs_to :access, class_name: "Access"
end
