class GroupBlueprint < Blueprinter::Base
  identifier :id

  fields :description,
         :name,
         :parent_id

  field :users_count do |group, _params|
    group.users.count
  end

  field :author, if: -> (_field_name, group, options) { group.author == options[:current_user] }do |group, _options|
    UserBlueprint.render_as_json(group.author)
  end

  field :users, if: -> (_field_name, group, options) { group.author == options[:current_user] } do |group, _options|
    group.users.map do |user|
      UserBlueprint.render_as_json(user)
    end
  end
end
