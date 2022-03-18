class CreateFormTags < ActiveRecord::Migration[7.0]
  def change
    create_table :form_tags do |t|
      t.references :sword_form, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
    add_index :form_tags, [:tag_id, :sword_form_id], unique: true
    add_index :form_tags, [:sword_form_id, :tag_id], unique: true
  end
end
