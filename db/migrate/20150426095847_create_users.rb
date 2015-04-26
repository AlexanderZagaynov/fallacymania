class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.timestamps null: false
      t.boolean :guest, default: false, null: false
      t.index :guest
      t.string :name
    end
  end
end
