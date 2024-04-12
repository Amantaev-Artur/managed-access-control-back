class AccessType < ApplicationRecord
  LOGIN_TYPE_SLUG = 'login'

  has_many :accesses

  validates :slug, uniqueness: { case_sensitive: false }
end
