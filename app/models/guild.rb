class Guild < ApplicationRecord
  before_create :set_uuid

  has_many :user_guilds, dependent: :destroy
  has_many :users, through: :user_guilds, source: :user

  private

  def set_uuid
    self.uuid = loop do
      random_token = SecureRandom.urlsafe_base64(9)
      break random_token unless self.class.exists?(uuid: random_token)
    end
  end
end
