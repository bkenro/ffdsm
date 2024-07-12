# ffdsm

## 概要

*ffdsm* は、[Drupal さっぽろ](https://drupalsapporo.net)謹製の Drupal 実習用 LAMP スタック（VirtualBox 用 Vagrant box）です。

Ubuntu 24.04 LTS（[bento/ubuntu-24.04](https://app.vagrantup.com/bento/boxes/ubuntu-24.04)）をベースに次の変更を加えています：

- パッケージの取得先に http://mirrors.ubuntu.com/mirrors.txt を使用
- apt によるカーネル更新を抑止
- タイムゾーンを Asia/Tokyo に変更
- Drupal の実習で使用するソフトウェアを導入
	- MariaDB
	- Apache2 Web サーバー
	- PHP 8.3
	- Composer
	- Drush 8
	- Mailpit
	- docker-ce、DDEV
	- その他

環境構築用のシェルスクリプト（`initial.sh`）と Vagrantfile を build サブフォルダに収めています。変更内容の詳細はそちらをご覧ください。

作成した box のパッケージファイルは、Vagrant Cloud に [bkenro/ffdsm](https://app.vagrantup.com/bkenro/boxes/ffdsm) という名前でアップロードしています。Vagrantfile で `config.vm.box = "bkenro/ffdsm"` と指定してお使いください。このプロジェクト直下にサンプルの Vagrantfile とマウント先の `www` フォルダを収めています。

なお、ベースとして使用した bento/ubuntu-24.04 ボックスのバージョンや、当方で動作確認した VirtualBox のバージョンについては、[bkenro/ffdsm](https://app.vagrantup.com/bkenro/boxes/ffdsm) の各バージョンに記載のコメントを参照してください。

※名前について<br>
初版が Ubuntu 20.04 LTS（**F**ocal **F**ossa）ベースの、**D**rupal **S**apporo **M**eetup 用に作った環境だったことから *ffdsm* としました。読み方は「ふづむ」です。

## 使い方

実際の使用例は、こちらの動画をご覧ください。

[![](https://img.youtube.com/vi/2pllnb6cyCw/0.jpg)](https://www.youtube.com/watch?v=2pllnb6cyCw&list=PLhinO-VEuZMkLwFWku5u74Y1WNlLoi9qp)

なお、Windows 用のショートカットは、setup.ps1 ファイルを PowerShell で実行（右クリックして [PowerShell で実行] をクリック）すると、実際の展開場所に合わせて作り直すことができます。
