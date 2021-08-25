require 'rails_helper'

RSpec.describe Authentication, type: :model do

  it '全ての値がある場合、有効' do
    authentication = build(:authentication)
    expect(authentication).to be_valid
  end

  it 'uidがない場合、無効' do
    authentication = build(:authentication, uid: nil)
    authentication.valid?
    expect(authentication.errors[:uid]).to include('を入力してください')
  end

  it 'providerがない場合、無効' do
    authentication = build(:authentication, provider: nil)
    authentication.valid?
    expect(authentication.errors[:provider]).to include('を入力してください')
  end
end
