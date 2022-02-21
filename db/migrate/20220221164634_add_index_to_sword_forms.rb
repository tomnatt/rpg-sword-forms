class AddIndexToSwordForms < ActiveRecord::Migration[7.0]
  def change
    add_index :sword_forms, :name, unique: true
  end
end
