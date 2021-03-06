# Discord-Log

![547d93aff1bfd7fabcadc6a4836aa98a](https://user-images.githubusercontent.com/63973453/130365572-2acd531b-9cd1-47b2-897e-472e835d6d98.png)

<br>

## サービス概要
Discord-Logは、**登録したDiscordアカウントのボイスチャンネルの使用時間を自動で計算して、グラフとして視覚化するアプリ**です。

<br>

## 機能紹介
<br>

**アプリ登録後にDiscordのボイスチャンネルに入室して退出後、画面をリロードすると時間が計測され表示されます！**

<br>

| アプリ登録(サーバー管理者の場合)                                                       | アプリ登録(管理者以外)                                                                                               |
| :------------------------------------------------------------------- | :----------------------------------------------------------------------------------------------------- |
| <img src="https://user-images.githubusercontent.com/63973453/130367346-9fa5140c-8e07-4f79-aea0-3323f3080453.png"> | <img src="https://user-images.githubusercontent.com/63973453/130367204-213fc7c7-01ef-441d-bf79-bfddb3cd1e12.png"> |
| ①「サーバーにBotを登録する」より、Botをサーバーに登録してください。<br>②Discordアプリの「サーバー設定」→「ウィジェット」→「ウィジェットを有効」にチェックを入れてください。<br>③「Discord-Logを使う」より、アプリを登録ください。| ①「Discord-Logを使う」より、アプリを登録ください。|

<br>

| マイページ画面                                                       | サイドバー                                                                                              |
| :------------------------------------------------------------------- | :----------------------------------------------------------------------------------------------------- |
| <img src="https://user-images.githubusercontent.com/63973453/130367396-555b8147-62e1-4d28-b747-d6eb3d3e95a4.png" width="90%"> | <img src="https://user-images.githubusercontent.com/63973453/130367941-4e52d2ca-39cd-4894-b6af-52139ec7ce4a.png">                                   |
| ログインユーザーの全サーバーのボイスチャンネルの使用時間を確認することができます。<br>特定の期間ごとに使用時間がグラフで表示され、また期間中に使用したボイスチャンネルのトップ5も表示します。|ログインユーザーが所属している全てのサーバーが表示されます。その下には、そのサーバー内にある、ボイスチャンネルが表示されるようになっています。それらのボタンリンクをクリックすると、それぞれの詳細ページに遷移します。|

<br>

| サーバー詳細ページ                                                       | チャンネル詳細ページ                                                                                              |
| :------------------------------------------------------------------- | :----------------------------------------------------------------------------------------------------- |
| <img src="https://user-images.githubusercontent.com/63973453/130368083-c44f859d-17dd-40f5-83eb-47905f5f56a8.png"> | <img src="https://user-images.githubusercontent.com/63973453/130368113-9577a015-4a51-4f3e-8970-53bb010c3544.png">                                   |
| サイドバーにある、サーバー名のボタンリンクをクリックすることで、サーバーの詳細ページへ遷移することができます。<br>そのサーバー内にある、ボイスチャンネルの使用時間を確認することができます。|サイドバーにある、ボイスチャンネル名のボタンリンクをクリックすることで、ボイスチャンネルの詳細ページへ遷移することができます。<br>そのボイスチャンネルの使用時間を確認することができます。|

<br>

| 使い方① 　                                                      |
| :------------------------------------------------------------------- |
| ![556ce3e3db330d117267d32d6e8ca83b.gif](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/625435/61130cf9-9044-8b57-f811-b037fb156d3e.gif) | 
| Discordのボイスチャンネルに入室して退出後、画面をリロードすると時間が計測され表示されます。 |

| 使い方② 　マイページ                                                      |
| :------------------------------------------------------------------- |
| ![5045bbbd46d6663b981fe9f6763d0cc5.gif](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/625435/abc8b3a9-5923-c25e-2ef3-ed7b80c61aa3.gif)| 
| ログイン後に遷移する画面になります。<br>この画面では、ログインユーザーの全サーバーのボイスチャンネルの使用時間を確認することができます。 |

| 使い方③ 　サーバー詳細ページ                                                      |
| :------------------------------------------------------------------- |
| ![7b6a52596f1789796adfc3d3d8899e46.gif](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/625435/39c2199e-668b-c096-8420-2d5e4e80a68a.gif)| 
| サイドバーにある、サーバー名のボタンリンクをクリックすることで、サーバーの詳細ページへ遷移することができます。<br>この画面では、そのサーバー内にある、ボイスチャンネルの使用時間を確認することができます。 |

| 使い方④ 　チャンネル詳細ページ                                                      |
| :------------------------------------------------------------------- |
| ![bf673d68cff45274cb483780d08ad5e6.gif](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/625435/76bc9cfb-3b5a-03ba-5d4f-6b4c337ed3ba.gif) | 
| サイドバーにある、ボイスチャンネル名のボタンリンクをクリックすることで、ボイスチャンネルの詳細ページへ遷移することができます。<br>この画面では、そのボイスチャンネルの使用時間を確認することができます。|


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

<br>

## ER図
![Discord_Log-Page-1 (3)](https://user-images.githubusercontent.com/63973453/130365416-00700bf6-0293-45e1-8045-3d5d83622913.png)

<br>

## インフラ構成図

![インフラ構成図 (4)](https://user-images.githubusercontent.com/63973453/132782438-e84cf879-fd0c-4105-b299-56c01e1957ac.png)





## Qiita記事
- [[個人開発]Discordの使用時間を計測するアプリ「Discord-Log」を作りました](https://qiita.com/yasuk-0714/items/98a25750407209f4b64f)
