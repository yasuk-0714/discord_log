class ChannelTime < ApplicationRecord
  belongs_to :user_channel
  validates :start_time, presence: true
end
