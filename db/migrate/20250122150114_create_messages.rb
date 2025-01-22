class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :messages do |t|
      t.string :role
      t.string :content
      t.integer :tokens
      t.references :chat, null: false, foreign_key: true

      t.timestamps
    end
  end
end
