class RemoveUnncessaryColumnsUserSession < ActiveRecord::Migration[7.1]
    def change
        add_column :user_sessions, :authenticated, :boolean, default: false
        remove_column :user_sessions, :ip
    end
end
