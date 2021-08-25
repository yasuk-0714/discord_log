require 'rails_helper'

RSpec.describe ChannelTime, type: :model do

  it '全てのカラムに値が入っている場合、有効' do
    channel_time = build(:channel_time)
    expect(channel_time).to be_valid
  end

  it 'start_timeがない場合、無効' do
    channel_time = build(:channel_time, start_time: nil)
    channel_time.valid?
    expect(channel_time.errors[:start_time]).to include('を入力してください')
  end
end
