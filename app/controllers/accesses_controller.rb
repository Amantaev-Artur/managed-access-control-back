class AccessesController < ApplicationController
  before_action :authenticate_user

  def index
    accesses = @current_user.accesses.uniq
    render json: AccessBlueprint.render_as_json(accesses, { current_user: @current_user })
  end

  def show
    access = @current_user.accesses.find(params[:id])
    render json: AccessBlueprint.render_as_json(access, { current_user: @current_user })
  end

  def destroy
    access = @current_user.accesses.find(params[:id])
    access.delete
    render json: :ok
  end

  def create
    groups = Group.where(id: params[:groupIds])
    access_type = AccessType.find_by(slug: params[:type].downcase)
    access = Access.new(
      author: @current_user,
      data: params[:data],
      groups: groups,
      size: params[:size],
      access_type: access_type
    )

    if access.save
      groups.each do |group|
        group.users.each do |user|
          EmailPublisher.new(
            email: user.email,
            action: 'delete_from_group',
            data: { 'access': access.data['serviceName'], 'group': group.name}
          ).call
        end
      end

      render json: AccessBlueprint.render_as_json(access, { current_user: @current_user })
    else
      render json: { error: access.errors }, status: :unprocessable_entity
    end
  end

  def update
    access = Access.find(params[:id])
    groups = Group.where(id: params[:groupIds])
    access_type = AccessType.find_by(slug: params[:type].downcase)

    if params[:data][:password]
      rsa_private_key = OpenSSL::PKey::RSA.new(@current_user.priv_key)
      password = rsa_private_key .private_decrypt(Base64.decode64(params[:data][:password]))
      access.data = params[:data]
      access.data['password'] = password
    else
      access.data = params[:data]
    end

    access.groups = groups
    access.size = params[:size]
    access.access_type = access_type

    if access.save
      render json: AccessBlueprint.render_as_json(access, { current_user: @current_user })
    else
      render json: { error: access.errors }, status: :unprocessable_entity
    end
  end
end
