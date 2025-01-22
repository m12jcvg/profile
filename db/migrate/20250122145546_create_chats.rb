class CreateChats < ActiveRecord::Migration[8.0]
  def change
    create_table :chats do |t|
      t.text :thread_id

      t.timestamps
    end
  end
end
