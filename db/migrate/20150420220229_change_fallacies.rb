class ChangeFallacies < ActiveRecord::Migration
  def change # irreversible
    remove_foreign_key :fallacy_samples, :fallacies
    remove_foreign_key :fallacy_translations, :fallacies
    remove_foreign_key :fallacy_translations, :fallacy_samples

    rename_column :fallacy_translations, :language, :locale
    change_column :fallacy_translations, :locale, :string, limit: nil
    remove_column :fallacy_translations, :fallacy_sample_id
  end
end
