class AddIndex < ActiveRecord::Migration[6.0]
  def change
    add_index :channel_times, :total_time
    add_index :channel_times, :created_at
  end
end
