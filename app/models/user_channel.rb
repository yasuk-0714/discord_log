class UserChannel < ApplicationRecord
  belongs_to :user
  belongs_to :channel
  has_many :channel_times, dependent: :destroy

  validates :id, uniqueness: true
end
