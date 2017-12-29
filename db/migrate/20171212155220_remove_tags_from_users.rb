class RemoveTagsFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :questions, :tags
  end
end
