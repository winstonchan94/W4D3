class AddUserIdToCats < ActiveRecord::Migration[5.1]
  def change
    add_column :cats, :user_id, :int, null: false
    add_index :cats, :user_id
  end
end
