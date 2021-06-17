class User < ApplicationRecord
  before_create :set_uuid

  authenticates_with_sorcery!
  has_one :authentication, dependent: :destroy
  accepts_nested_attributes_for :authentication

  has_many :user_guilds
  has_many :guilds, through: :user_guilds

  validates :discord_id, presence: true, uniqueness: true
  validates :name, presence: true
  validates :email, presence: true
  validates :role, presence: true

  enum role: { admin: 0, general: 1}

  private

  def set_uuid
    self.uuid = loop do
      random_token = SecureRandom.urlsafe_base64(9)
      break random_token unless self.class.exists?(uuid: random_token)
    end
  end
end
