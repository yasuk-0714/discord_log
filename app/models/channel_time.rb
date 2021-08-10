class ChannelTime < ApplicationRecord
  belongs_to :user_channel
  validates :start_time, presence: true

  scope :date, ->(date) { where(created_at: date) }

  def self.total_time
    sum(:total_time)
  end

  def self.user_channel(user_channel)
    where(user_channel_id: user_channel)
  end

  def self.group_id
    group(:user_channel_id)
  end
end
