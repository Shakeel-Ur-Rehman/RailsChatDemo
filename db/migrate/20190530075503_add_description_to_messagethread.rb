class AddDescriptionToMessagethread < ActiveRecord::Migration[5.2]
  def change
    add_column :messagethreads, :description, :text
  end
end
