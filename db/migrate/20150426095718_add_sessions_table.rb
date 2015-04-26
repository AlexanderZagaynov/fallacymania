class AddSessionsTable < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.timestamps null: false
      t.index :updated_at
      t.string :session_id, null: false
      t.index :session_id, unique: true
      t.text :data
    end
  end
end
