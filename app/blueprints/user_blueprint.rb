class UserBlueprint < Blueprinter::Base
  identifier :id

  fields :email,
         :name,
         :nickname,
         :image
end
