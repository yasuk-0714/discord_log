class UserChannel < ApplicationRecord
  belongs_to :user
  belongs_to :channel
  has_many :channel_times
end
