# frozen_string_literal: true

module Accesses
  # Создание access
  class CreateService
    def initialize(access:, access_type:, data:, group_ids:, size:)
      @access = access
      @access_type = access_type
      @data = 
    end

    def call
      access = Access.new(
        author: @author,
        data: @data,
        groups: groups,
        size: @size,
        access_type: @access_type
      )

      return unless access.save

      notify_users(access)

      access
    end

    private

    def groups
      @groups ||= Group.where(id: @group_ids)
    end

    def notify_users(access)
      groups.each do |group|
        group.users.each do |user|
          EmailPublisher.new(
            email: user.email,
            action: 'delete_from_group',
            data: { 'access': access.data['serviceName'], 'group': group.name }
          ).call
        end
      end
    end
  end
end
