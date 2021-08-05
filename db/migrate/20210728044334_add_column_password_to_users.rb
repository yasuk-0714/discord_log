class AddColumnPasswordToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :crypted_password, :string
    add_column :users, :salt, :string
  end
end
