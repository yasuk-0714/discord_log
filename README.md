# Discord-Log

![547d93aff1bfd7fabcadc6a4836aa98a](https://user-images.githubusercontent.com/63973453/130365572-2acd531b-9cd1-47b2-897e-472e835d6d98.png)

## サービス概要
Discord-Logは、**登録したDiscordアカウントのボイスチャンネルの使用時間を自動で計算して、グラフとして視覚化するアプリ**です。

## 機能紹介
|アプリ登録(サーバー管理者の場合)|
|---|
|![Untitled Diagram (8)](https://user-images.githubusercontent.com/63973453/130367346-9fa5140c-8e07-4f79-aea0-3323f3080453.png)|
|管理者の方は「サーバーにBotを登録する」より、Botをサーバーに登録してください。次に、Discordアプリの「サーバー設定」→「ウィジェット」→「ウィジェットを有効」にチェックを入れてください。最後に「Discord-Logを使う」より、アプリを登録ください。|

|アプリ登録(管理者以外の方)|
|---|
|![Untitled Diagram (3)](https://user-images.githubusercontent.com/63973453/130367204-213fc7c7-01ef-441d-bf79-bfddb3cd1e12.png)|
|サーバーの管理者以外の方は、「Discord-Logを使う」より、アプリを登録ください。|

|マイページ画面|サイドバー|
|---|---|
|![562cbd145d0cb538a3db6f349f882b41](https://user-images.githubusercontent.com/63973453/130367396-555b8147-62e1-4d28-b747-d6eb3d3e95a4.png)|![28521ad61b7785f2c55e7519fec0f4e7](https://user-images.githubusercontent.com/63973453/130367941-4e52d2ca-39cd-4894-b6af-52139ec7ce4a.png)|
|この画面では、ログインユーザーの全サーバーのボイスチャンネルの使用時間を確認することができます。「今日の使用時間」、「ここ１週間の使用時間」、「これまでのDiscord使用時間」、「各月の使用時間」がグラフで表示され、また期間中に使用したボイスチャンネルのトップ5も表示します。|サイドバーには、ログインユーザーが所属している全てのサーバーが表示されます。その下には、そのサーバー内にある、ボイスチャンネルが表示されるようになっています。|

|サーバー詳細ページ|チャンネル詳細ページ|
|---|----|
|![35ab4f2504d88e3f94ecacfe3bd270ca](https://user-images.githubusercontent.com/63973453/130368083-c44f859d-17dd-40f5-83eb-47905f5f56a8.png)|![7eb76715eddd964d46dbabb5cb7fed2a](https://user-images.githubusercontent.com/63973453/130368113-9577a015-4a51-4f3e-8970-53bb010c3544.png)|
|サイドバーにある、サーバー名のボタンリンクをクリックすることで、サーバーの詳細ページへ遷移することができます。この画面では、そのサーバー内にある、ボイスチャンネルの使用時間を確認することができます。|サイドバーにある、ボイスチャンネル名のボタンリンクをクリックすることで、ボイスチャンネルの詳細ページへ遷移することができます。この画面では、そのボイスチャンネルの使用時間を確認することができます。|

## 使用技術

- Ruby 2.6.6
- Ruby on Rails 6.0.3
- Discord API　
- slim 
- sorcery 
- chartkick
- Bootstrap
- config
- dotenv-rails
- RSpec

## ER図
![Discord_Log-Page-1 (3)](https://user-images.githubusercontent.com/63973453/130365416-00700bf6-0293-45e1-8045-3d5d83622913.png)

## Qiita記事
[[個人開発]Discordの使用時間を計測するアプリ　「Discord-Log」を作りました](https://qiita.com/yasuk-0714/items/98a25750407209f4b64f)
