class SorceryCore < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :discord_id, null: false, unique: true
      t.string :name, null: false
      t.string :email, null: false
      t.string :uuid, null: false
      t.integer :role, null: false, default: 1

      t.timestamps                null: false
    end

    add_index :users, :email, unique: true
    add_index :users, :discord_id, unique: true
  end
end
