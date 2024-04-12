class CreateAccessesAndAccessesTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :access_types do |t|
      t.string :slug, null: false

      t.timestamps
    end

    create_table :accesses do |t|
      t.integer :author_id
      t.string :size, null: false
      t.jsonb :data
      t.references :access_type, null: false, foreign_key: true, on_delete: :cascade

      t.timestamps
    end
  end
end
