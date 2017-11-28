class AddTagsToQuesions < ActiveRecord::Migration[5.1]
  def change
    add_column :questions, :tags, :string, array: true, default: []
  end
end
