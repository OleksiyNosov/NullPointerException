class AddIndexToConfirmationTokenInUsers < ActiveRecord::Migration[5.1]
  def change
    add_index :users, :confirmation_token
  end
end
