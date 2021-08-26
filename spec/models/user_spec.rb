require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'バリデーション' do
    it 'ユーザー名、メールアドレス、discord_idがある場合、有効' do
      user = build(:user)
      expect(user).to be_valid
    end

    it 'ユーザー名がない場合、無効' do
      user = build(:user, name: nil)
      user.valid?
      expect(user.errors[:name]).to include('を入力してください')
    end

    xit 'ユーザー名が33文字以上、無効' do
      user = build(:user, name: "a" * 33)
      user.valid?
      expect(user.errors[:name]).to include('は32文字以内で入力してください')
    end

    it 'メールアドレスがない場合、無効' do
      user = build(:user, email: nil)
      user.valid?
      expect(user.errors[:email]).to include('を入力してください')
    end

    it 'メールアドレスが重複している場合、無効' do
      user = create(:user, email: 'test@example.com')
      other_user = build(:user, email: 'test@example.com')
      other_user.valid?
      expect(other_user.errors[:email]).to include('はすでに存在します')
    end

    context 'パスワード' do
      it 'passwordとpassword_confirmationが両方ある場合、有効' do
        user = build(:user, password: 'password', password_confirmation: 'password')
        expect(user).to be_valid
      end

      it 'passwordしかない場合、無効' do
        user = build(:user, password: 'password')
        user.valid?
        expect(user.errors[:password_confirmation]).to include('を入力してください')
      end

      it 'パスワードが6文字未満の場合、無効' do
        user = build(:user, password: '12345')
        user.valid?
        expect(user.errors[:password]).to include('は6文字以上で入力してください')
      end
    end

    it 'discord_idが重複した場合、無効' do
      user = create(:user, discord_id: '123456789')
      other_user = build(:user, discord_id: '123456789')
      other_user.valid?
      expect(other_user.errors[:discord_id]).to include('はすでに存在します')
    end

    it 'idが重複した場合、無効' do
      user = create(:user, id: 123456789)
      other_user = build(:user, id: 123456789)
      other_user.valid?
      expect(other_user.errors[:id]).to include('はすでに存在します')
    end
  end

  describe 'デフォルトの値' do
    let(:user) { create(:user) }

    it 'roleがgeneralであること' do
      expect(user.general?).to be_truthy
    end

    it '12字のuuidが生成されている' do
      expect(user.uuid.length).to eq 12
    end

    it 'discord_idがidと同じであること' do
      expect(user.id).to eq user.discord_id.to_i
    end
  end

end
