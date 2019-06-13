class AddPhoneToMessagethread < ActiveRecord::Migration[5.2]
  def change
    add_column :messagethreads, :phone, :string
  end
end
