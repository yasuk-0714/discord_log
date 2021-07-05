class SorceryExternal < ActiveRecord::Migration[6.0]
  def change
    create_table :authentications do |t|
      t.bigint :user_id, null: false
      t.string :provider, :uid, null: false
      t.string :access_token, null: false, default: ""
      t.string :refresh_token, null: false, default: ""

      t.timestamps              null: false
    end

    add_index :authentications, [:provider, :uid]
    add_index :authentications, :user_id
  end
end
