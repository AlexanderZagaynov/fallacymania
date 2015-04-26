class AddUserToSessions < ActiveRecord::Migration

  class Session < ActiveRecord::Base
    belongs_to :user
  end
  class User < ActiveRecord::Base
    has_many :sessions
  end

  def change
    add_reference :sessions, :user, index: true, foreign_key: true

    reversible do |direction|
      direction.up do
        Session.find_each do |session|
          session.update! user: User.create!(guest: true)
        end
      end
    end

    change_column_null :sessions, :user_id, false
  end
end
