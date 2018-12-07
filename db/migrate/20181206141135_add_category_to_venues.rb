class AddCategoryToVenues < ActiveRecord::Migration[5.2]
  def change
    add_column :venues, :category, :string
  end
end
