class AccessBlueprint < Blueprinter::Base
  identifier :id

  fields :size

  field :data do |access, options|
    data = access.data

    if data['password'].present?
      rsa_key = OpenSSL::PKey::RSA.new(options[:current_user].pub_key)
      encrypted_data = rsa_key.public_key.public_encrypt(data['password'])
      data['password'] = Base64.strict_encode64(encrypted_data)
    end

    data
  end

  field :access_type do |access, _options|
    AccessTypeBlueprint.render_as_json(access.access_type)
  end

  field :groups, if: -> (_field_name, access, options) { access.author == options[:current_user] } do |access, _options|
    access.groups.map do |group|
      GroupBlueprint.render_as_json(group)
    end
  end

  field :can_edit do |access, options|
    access.author == options[:current_user]
  end

  field :last_update do |access, _options|
    access.updated_at
  end
end
