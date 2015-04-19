class CreateFallacies < ActiveRecord::Migration
  def change
    create_table :fallacies do |t|
      t.timestamps null: false
      t.string :slug, null: false, index: true # TODO: unique case-insensitive, gem 'schema_plus_pg_indexes'
    end
  end
end
