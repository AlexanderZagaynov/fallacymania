class CreateFallacySamples < ActiveRecord::Migration
  def change
    create_table :fallacy_samples do |t|
      t.timestamps null: false
      t.references :fallacy, null: false, index: true, foreign_key: true
      t.string :language, limit: 2, null: false, index: true
      t.text :description
    end
  end
end
