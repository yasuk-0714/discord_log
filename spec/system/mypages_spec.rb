require 'rails_helper'

RSpec.describe "Mypages", type: :system do
  let(:user) { create(:user) }
  let(:user_guild) { create(:user, :with_guild, :with_channel) }

  describe 'サイドバー' do
    context 'ユーザーがサーバーを持っているとき' do
      before do
        login_as(user_guild)
      end
      it 'サーバー名が表示されていること' do
        expect(page).to have_content(user_guild.guilds[0][:name])
      end

      it 'サーバー詳細ページにアクセスできること' do
        click_on user_guild.guilds[0][:name]
        expect(page).to have_content("#{user_guild.guilds[0][:name]}の使用状況")
        expect(current_path).to eq guild_path(user_guild.guilds[0][:uuid])
        within '.sidebar' do
          expect(page).to have_link('マイページへ移動')
        end
      end

      context 'サーバーがチャンネルを持っているとき' do
        it 'チャンネル名が表示されていること' do
          expect(page).to have_content(user_guild.channels[0][:name])
        end
      end
    end

    xcontext 'ユーザーがサーバーを複数持っているとき' do
      before do
        binding.pry
        login_as(guild_user_channels)
      end
      it 'サーバー名が複数表示されていること' do
        expect(page).to have_content(user_guils.guild[0][:name])
        expect(page).to have_content(user_guils.guild[1][:name])
        expect(page).to have_content(user_guils.guild[2][:name])
      end
    end

    context 'ユーザーがサーバーを持っていないとき' do
      it 'なにも表示されないこと' do
        login_as(user)
        expect(page).to have_no_content
      end
    end
  end
end