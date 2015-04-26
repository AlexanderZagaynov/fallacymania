class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.timestamps null: false
      t.references :user, null: false, index: true, foreign_key: true
      t.references :statement, null: false, foreign_key: true
      t.references :fallacy, null: false, foreign_key: true
      t.boolean :correct, default: false, null: false, index: true
      t.string :locale, default: '', null: false
      t.integer :difficulty, default: 0, null: false, index: true
      t.index %i(user_id statement_id), unique: true
    end
  end
end
