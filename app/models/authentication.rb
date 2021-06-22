class Authentication < ApplicationRecord
  # before_save :encrypt_access_token
  belongs_to :user

  validates :uid, presence: true
  validates :provider, presence: true

  #authenticationsテーブルのトークンを暗号化したら、APIリクエストできないためコメントアウト
  # def encrypt_access_token
  #   key_len = ActiveSupport::MessageEncryptor.key_len
  #   secret = Rails.application.key_generator.generate_key('salt', key_len)
  #   crypt = ActiveSupport::MessageEncryptor.new(secret)
  #   self.access_token = crypt.encrypt_and_sign(access_token)
  #   self.refresh_token = crypt.encrypt_and_sign(refresh_token)
  # end
end
