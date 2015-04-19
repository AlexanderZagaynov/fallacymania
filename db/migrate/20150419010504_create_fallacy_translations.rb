class CreateFallacyTranslations < ActiveRecord::Migration
  def change
    create_table :fallacy_translations do |t|
      t.timestamps null: false
      t.references :fallacy, null: false, index: true, foreign_key: true
      t.string :language, limit: 2, null: false, index: true # TODO: enum, gem 'schema_plus_enums'
      t.string :name, null: false
      t.text :description
      t.references :fallacy_sample, index: true, foreign_key: true
    end
  end
end
