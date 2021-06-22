class CreateGuilds < ActiveRecord::Migration[6.0]
  def change
    create_table :guilds do |t|
      t.string :name, null: false
      t.string :uuid, null: false

      t.timestamps
    end
  end
end
