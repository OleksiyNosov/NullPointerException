class AddEmailConfirmationAndConfirmationTokenToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :status, :integer, default: 0
  end
end