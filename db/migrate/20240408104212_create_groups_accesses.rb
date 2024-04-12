class CreateGroupsAccesses < ActiveRecord::Migration[5.2]
  def change
    create_table :groups_accesses do |t|
      t.references :access
      t.references :group
      t.timestamps
    end

    add_foreign_key :groups_accesses, :groups, column: :group_id, on_delete: :cascade
    add_foreign_key :groups_accesses, :accesses, column: :access_id, on_delete: :cascade
    add_index :groups_accesses, [:access_id, :group_id], unique: true
  end
end
