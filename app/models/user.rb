class User < ApplicationRecord
  require "net/http"
  require "uri"
  require "json"
  require "openssl"

  before_create :set_uuid

  authenticates_with_sorcery!
  has_one :authentication, dependent: :destroy
  accepts_nested_attributes_for :authentication

  has_many :user_guilds, dependent: :destroy
  has_many :guilds, through: :user_guilds, source: :guild
  has_many :user_channels, dependent: :destroy
  has_many :channels, through: :user_channels, source: :channel
  has_many :channel_times, through: :user_channels

  validates :discord_id, presence: true, uniqueness: true
  validates :name, presence: true
  validates :email, presence: true
  validates :role, presence: true

  enum role: { general: 0, admin: 10}

  private

  def set_uuid
    self.uuid = loop do
      random_token = SecureRandom.urlsafe_base64(9)
      break random_token unless self.class.exists?(uuid: random_token)
    end
  end
end
