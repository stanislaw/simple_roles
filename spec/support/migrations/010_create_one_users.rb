class CreateOneUsers < ActiveRecord::Migration
  def up
    create_table(:one_users) do |t|
      t.string  :name
      t.string  :username

      t.string :role

      t.timestamps
    end
  end

  def down
    drop_table :users
  end
end
