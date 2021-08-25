require 'rails_helper'

RSpec.describe Channel, type: :model do
  it 'チャンネル名とpositonがある場合、有効' do
    channel = build(:channel)
    expect(channel).to be_valid
  end

  it 'チャンネル名がない場合、無効' do
    channel = build(:channel, name: nil)
    channel.valid?
    expect(channel.errors[:name]).to include('を入力してください')
  end

  it 'positonがない場合、無効 ' do
    channel = build(:channel, position: nil)
    channel.valid?
    expect(channel.errors[:position]).to include('を入力してください')
  end

  it 'idが重複した場合、無効' do
    channel = create(:channel, id: 123456789)
    other_channel = build(:channel, id: 123456789)
    other_channel.valid?
    expect(other_channel.errors[:id]).to include('はすでに存在します')
  end
end
