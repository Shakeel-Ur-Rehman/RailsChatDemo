class ChangeColumnName < ActiveRecord::Migration[5.2]
  def change
    rename_column :messages, :messagethreads_id, :messagethread_id
  end
end
