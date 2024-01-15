<h1 align="center">
  <a href="https://github.com/dec0dOS/amazing-github-template">
    <img src="{{cookiecutter.repo_slug}}/docs/images/logo.svg" alt="Logo" width="125" height="125">
    <div>app説明するGIF（短め)を入れる</div>
  </a>
</h1>

![Apptitle](./assets/images/Apptitle.png)

<details open="open">
<summary>目次</summary>

- [概要](#概要)
- [はじめる](#はじめる)
  - [使用方法](#使用方法)
    - [開発環境](#開発環境)
    - [セットアップ](#セットアップ)
    - [環境変数](#環境変数)
- [ロードマップ](#ロードマップ)
- [コントリビューター](#コントリビューター)
- [参考](#参考)

</details>

---

## 概要

<table>
<tr>
<td>

<details open>
<summary> 『おえかき　かめらさん』とは</summary>
<br>

せっかく家族でお出かけしていても、車での移動中、各々でスマホを見ているなど、コミュニケーション不足を感じませんか？
<br>
『おえかき　かめらさん』では自分や家族が描いた絵が、その場で AR となって周りの風景と一緒に写真撮影ができます。
<br>
世界でたった一枚の最高の思い出を残しましょう 🎁
<br>
<br>
【できる事】
<br>
　・紙で描いた絵を撮影して登録　 ✏️
<br>
　・端末でお絵描きした絵を登録　 📱🖊️
<br>
　・自分が描いた絵以外も複数選択して AR 表示　 👪
<br>
　・周りの風景と選択した AR を一緒に撮影　 🏕️
<br>
　・アルバム写真に撮影場所表示　 🗾
<br>

</details>

</td>
</tr>
</table>

## はじめる

### 使用方法

#### 開発環境

下記のソフトウェアのインストールを実施

- フロントエンド：Xcode (ver15.0.1)
  <br>
  [参考：Xcode インストール](https://tech-camp.in/note/technology/88418/)

<!-- - バックエンドサーバー：Node (ver18.0.0)
  <br>
  [参考：Node インストール](https://qiita.com/sefoo0104/items/0653c935ea4a4db9dc2b) -->

#### セットアップ

下記手順に従って、セットアップを実施
<br>
前提：フロントエンド＝ iPhone にビルド、バックエンド＝ Pass にデプロイ

###### &emsp;全体

&emsp;1. git clone にてリポジトリーをクローンする

```zh
git clone https://github.com/final-project-visionaries/drAwing-tRaveler.git
```

###### &emsp;バックエンド

&emsp;1. 上記クローンした Server フォルダを Paas にデプロイ（ex: Render, Heroku など）
<br>
&emsp;&emsp;[参考：Render で DB(Postgres
) 作成](https://note.com/watanabe_kf1983/n/n9e4597ae223e)
<br>
&emsp;&emsp;[参考：Render へ Node アプリをデプロイ](https://qiita.com/snyt45/items/1e14b4a41d20176749dd)
<br>
&emsp;&emsp;※デプロイ時に下記環境変数を２つ設定
<br>
&emsp;&emsp; NODE_ENV=production
<br>
&emsp;&emsp; DATABASE_URL="Render で作成した DB の Internal URL"
<br>

###### &emsp;フロントエンド

&emsp;1. 上記クローンした Client フォルダを Xcode で開く
<br>
&emsp;2.下記ファイルでバックエンドへの Http リクエストのエンドポイントをご自身のバックエンドサーバーの URL に変更する
<br>
&emsp;/client/api/Auth.swift

```swift
//変更前
var apiAuthEndPoint = "https://drawing-traveler-7a488b236b7c.herokuapp.com/api/v1/auth"
//変更後
var apiAuthEndPoint = "[ご自身のサーバーのURL]/api/v1/auth"
```

<br>
&emsp;/client/api/Images.swift

```swift
//変更前
var apiEndPoint = "https://drawing-traveler-7a488b236b7c.herokuapp.com/api/v1/images"
//変更後
var apiEndPoint = "[ご自身のサーバーのURL]/api/v1/images"
```

<br>
&emsp;/client/api/Albums.swift

```swift
//変更前
var apiAlbumEndPoint = "https://drawing-traveler-7a488b236b7c.herokuapp.com/api/v1/albums"
//変更後
var apiAlbumEndPoint = "[ご自身のサーバーのURL]/api/v1/albums"
```

<br>
&emsp;3. Xcode にて iPhone にアプリをビルド
<br>

&emsp;&emsp; [参考 : 自作アプリを iPhone へビルド](https://tech.amefure.com/swift-iphone)

## ロードマップ

今後の計画

- SNS で共有できる機能
- 地域限定アート機能

## コントリビューター

このプロジェクトに貢献してくれている、コントリビューターの皆さんです

<a href="https://github.com/final-project-visionaries/drAwing-tRaveler/graphs/contributors">
  <img src="https://github.com/Ogata-Kazuyoshi.png"  style="width:80px;border-radius: 50%;"/>
  <img src="https://github.com/MATSUINAOKO.png"  style="width:80px;border-radius: 50%;"/>
  <img src="https://github.com/Tomohirojin157831.png"  style="width:80px;border-radius: 50%;"/>
  <img src="https://github.com/myu-myu-myu.png"  style="width:80px;border-radius: 50%;"/>
</a>

## クレジット
- "Happy Hey" by Infraction
- [https://bit.ly/3GrEbF4](https://bit.ly/3GrEbF4)
- Music promoted by Inaudio: [http://bit.ly/3qxoX6U](http://bit.ly/3qxoX6U)
