class AddSampleStatementToFallacy < ActiveRecord::Migration
  def change

    add_reference :fallacies, :statement, index: { unique: true }

    reversible do |direction|
      direction.up do
        Fallacy.includes(:statements).find_each do |fallacy|
          fallacy.update! statement: fallacy.statements.first
        end
      end
    end

  end
end
