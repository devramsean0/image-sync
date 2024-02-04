class CreateUserSessions < ActiveRecord::Migration[7.1]
    def change
        create_table :user_sessions do |t|
            t.string :cookie
            t.string :ip
            t.string :email_code
            t.belongs_to :user, null: false, foreign_key: true

            t.timestamps
        end
    end
end
