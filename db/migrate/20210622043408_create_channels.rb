class CreateChannels < ActiveRecord::Migration[6.0]
  def change
    create_table :channels do |t|
      t.string :name, null: false
      t.string :uuid, null: false
      t.integer :position, null: false
      t.references :guild, null: false, foreign_key: true

      t.timestamps
    end
  end
end
