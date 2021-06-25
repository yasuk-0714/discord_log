class Channel < ApplicationRecord
  before_create :set_uuid

  has_many :user_channels, dependent: :destroy
  has_many :users, through: :user_channels, source: :user
  belongs_to :guild

  validates :name, presence: true
  validates :uuid, presence: true
  validates :position, presence: true

  private

  def set_uuid
    self.uuid = loop do
      random_token = SecureRandom.urlsafe_base64(9)
      break random_token unless self.class.exists?(uuid: random_token)
    end
  end
end
