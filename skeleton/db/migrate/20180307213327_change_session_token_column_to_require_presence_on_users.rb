class ChangeSessionTokenColumnToRequirePresenceOnUsers < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :session_token, :string, null: false 
  end
end
