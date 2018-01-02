class AddEmailConfirmationAndConfirmationTokenToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :email_confirmation, :boolean, default: false

    add_column :users, :confirmation_token, :string
  end
end
