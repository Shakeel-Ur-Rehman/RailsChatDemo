class AddMessagethreadToMessage < ActiveRecord::Migration[5.2]
  def change
    add_reference :messages, :Messagethread, foreign_key: true
  end
end
