require 'rails_helper'

RSpec.describe 'Home', type: :system do

  describe 'ヘッダーの表示' do
    context 'ログイン前' do
      it 'ヘッダーが正しく表示されていること'do
        visit root_path
        expect(page).to have_content('Discord-Log')
        expect(page).to have_content('ボットを登録')
        expect(page).to have_content('ログイン')
      end

      it 'ログインができないこと' do
        visit mypage_path
        expect(current_path).to eq root_path
        expect(page).to have_content('ログインしてください')
      end
    end

    context 'ログイン後' do
      let!(:user) { create(:user) }
      before do
        login_as(user)
      end

      it 'ヘッダーが正しく表示されていること' do
        visit mypage_path
        expect(page).to have_content('Discord-Log')
        expect(page).to have_content('ボットを登録')
        expect(page).to have_content('マイページ')
        expect(page).to have_content('ログアウト')
      end
    end
  end

  describe 'フッターの表示' do
    it '正しく表示されていること' do
      visit root_path
      expect(page).to have_content('利用規約')
      expect(page).to have_content('プライバシーポリシー')
      expect(page).to have_content('お問い合わせ')
    end
  end

  describe '利用規約の表示' do
    it '正しく表示されていること' do
      visit root_path
      click_link '利用規約'
      expect(current_path).to eq terms_of_service_path
    end
  end

  describe 'プライバシーポリシーの表示' do
    it '正しく表示されている' do
      visit root_path
      click_link 'プライバシーポリシー'
      expect(current_path).to eq privacy_policy_path
    end
  end
end
