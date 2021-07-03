class CreateChannelTimes < ActiveRecord::Migration[6.0]
  def change
    create_table :channel_times do |t|
      t.datetime :start_time, null: false
      t.datetime :end_time
      t.references :user_channel, null: false, foreign_key: true

      t.timestamps
    end
  end
end
