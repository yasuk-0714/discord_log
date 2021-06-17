class CreateUserGuilds < ActiveRecord::Migration[6.0]
  def change
    create_table :user_guilds do |t|
      t.references :user, null: false, foreign_key: true
      t.references :guild, null: false, foreign_key: true

      t.timestamps
    end
  end
end
