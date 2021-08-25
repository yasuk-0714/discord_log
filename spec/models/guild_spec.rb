require 'rails_helper'

RSpec.describe Guild, type: :model do

  it 'サーバー名がある場合、有効' do
    guild = build(:guild)
    expect(guild).to be_valid
  end

  it 'サーバー名がない場合、無効' do
    guild = build(:guild, name: nil)
    guild.valid?
    expect(guild.errors[:name]).to include('を入力してください')
  end

  it 'サーバーIDが重複している場合、無効' do
    guild = create(:guild, id: 123456789)
    other_guild = build(:guild, id: 123456789)
    other_guild.valid?
    expect(other_guild.errors[:id]).to include('はすでに存在します')
  end
end
