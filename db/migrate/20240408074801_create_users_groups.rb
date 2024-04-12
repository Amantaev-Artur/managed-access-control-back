class CreateUsersGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :users_groups do |t|
      t.references :user
      t.references :group
      t.timestamps
    end

    add_foreign_key :users_groups, :groups, column: :group_id, on_delete: :cascade
    add_foreign_key :users_groups, :users, column: :user_id, on_delete: :cascade
    add_index :users_groups, [:user_id, :group_id], unique: true
  end
end
