class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.integer :author_id
      t.string :name
      t.string :description
      t.text :ancestry
      t.timestamps
    end
  end
end
