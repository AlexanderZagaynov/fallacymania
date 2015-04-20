class ChangeSophisms < ActiveRecord::Migration
  def change # irreversible
    create_table :sophisms do |t|
      t.timestamps null: false
      t.references :fallacy, null: false, index: true, foreign_key: true
    end

    drop_table :fallacy_samples

    create_table :sophism_translations do |t|
      t.timestamps null: false
      t.references :sophism, null: false, index: true
      t.string :locale, null: false, index: true
      t.text :description
    end
  end
end
