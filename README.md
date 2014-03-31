testSquare
==========

* Foursquare API と CocoaPodsを使ったテスト用iOSアプリ
* version 0.1

##条件
* CocoaPodsが使用できる環境
* Xcode5.1

##機能
* 現在位置の周辺のvenueを一覧表示します。
* 一覧からチェックイン対象をタップすると周辺地図画面に遷移します。
* 周辺地図画面でチェックインできます。
* その他...これから徐々に実装します。

##インストール前の準備
* Foursquare APIを使うために開発者登録が必要となります。
* 開発者登録を行う事で、CLIENT_ID、CLIENT_SECRET、REDIRECT_URIが取得出来ます。
* 詳しくはここを参照して下さい。

##インストール
* CocoaPodsをインストールします。CocoaPodsのインストール方法は [ここ](http://www.iosjp.com/dev/archives/451 "Objective-Cのライブラリ管理ツール CocoaPods") を見て下さい。
* リモートリポジトリからクローンします。
* testSquare.xcodeprojと同じディレクトリまで移動し、必要なPodをインストールします。

##注意点
* 必要なPodについて
    * testSquareでは、Foursquare-API-v2というPodを使用しています。
* CLLocationManagerの設定について
    * 自分の独習用のため最低限の設定しかしていません。

##ライセンス
* MIT License (http://www.opensource.org/licenses/mit-license.php)

##コピーライト
* Copyright 2014, Takashi Kato([@takataka5845](https://twitter.com/takataka5845 "twitter:@takataka5845")).
