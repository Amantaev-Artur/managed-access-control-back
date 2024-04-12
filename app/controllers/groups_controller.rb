class GroupsController < ApplicationController
  before_action :authenticate_user

  def index
    groups = @current_user.groups
    if params[:excludeGroupId].present?
      exclude_group_ds = Group.find(params[:excludeGroupId]).subtree_ids
      groups = groups.where.not(id: exclude_group_ds)
    end
    render json: GroupBlueprint.render_as_json(Group.sort_by_ancestry(groups), { current_user: @current_user })
  end

  def show
    group = Group.includes(:users).find(params[:id])
    render json: GroupBlueprint.render_as_json(group, { current_user: @current_user })
  end

  def create
    group = Group.new(
      author: @current_user,
      parent_id: params[:parentId],
      name: params[:name],
      description: params[:description],
      users: [@current_user]
    )

    if group.save
      render json: GroupBlueprint.render_as_json(group, { current_user: @current_user })
    else
      render json: { error: group.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    group = Group.find_by!(author: @current_user, id: params[:id])
    group.delete
    render json: :ok
  end

  def update
    group = Group.find(params[:id])
    group.name = params[:name]
    group.description = params[:description]
    group.parent_id = params[:parentId] if params[:parentId]
    group.save

    render json: GroupBlueprint.render_as_json(group, { current_user: @current_user })
  end

  def add_user
    group = Group.find(params[:group_id])
    user = User.find(params[:user_id])

    group.path.each do |g|
      begin
        g.users << user     

        EmailPublisher.new(email: user.email, action: 'welcome_to_group', data: { 'group': g.name }).call
      rescue => _e
      end
    end

    render json: GroupBlueprint.render_as_json(group, { current_user: @current_user })
  end

  def delete_user
    group = Group.find(params[:group_id])
    user = User.find(params[:user_id])

    group.subtree.each do |g|
      unless g.author == user
        g.users.destroy(user)

        EmailPublisher.new(email: user.email, action: 'delete_from_group', data: { 'group': g.name }).call
      end
    end

    render json: GroupBlueprint.render_as_json(group, { current_user: @current_user })
  end
end
