class CreateUserRoles < ActiveRecord::Migration
  def up
   create_table :user_roles do |t|
    t.integer :user_id
    t.integer :role_id

    t.timestamps
    end
    add_index :user_roles, [:user_id, :role_id]
 end

  def down
    drop_table :user_roles
  end
end
