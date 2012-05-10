class CreateRoles < ActiveRecord::Migration
  def up
    create_table :roles do |t|
      t.string :name
      t.timestamps
    end

    create_roles
  end

  def down
    drop_table :roles
  end


  def create_roles
    SimpleRoles::Configuration.valid_roles.each do |role|
      r = Role.new
      r.name = role.to_s
      r.save
    end
  end
end

