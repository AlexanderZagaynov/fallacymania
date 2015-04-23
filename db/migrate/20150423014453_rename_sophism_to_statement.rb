class RenameSophismToStatement < ActiveRecord::Migration
  def change
    rename_table :sophisms, :statements
    rename_table :sophism_translations, :statement_translations
    rename_column :statement_translations, :sophism_id, :statement_id
  end
end
