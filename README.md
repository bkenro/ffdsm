# ffdsm

*ffdsm* は、[Drupal さっぽろ](https://drupalsapporo.net)謹製の Drupal 実習用 LAMP スタック（VirtualBox 用 Vagrant box）です。

Ubuntu 20.04 LTS（[bento/ubuntu-20.04](https://app.vagrantup.com/bento/boxes/ubuntu-20.04)）をベースに次の変更を加えています：

- パッケージのダウンロード元を富山大学のミラーに変更
- apt によるカーネル更新を抑止
- タイムゾーンを Asia/Tokyo に変更
- Drupal の実習で使用するソフトウェアを導入
	- MariaDB
	- Apache2 Web サーバー
	- PHP 7.4
	- Composer
	- Drush 8
	- MailHog / mhsendmail
	- docker、docker-compose
	- その他

環境構築用のシェルスクリプト（`initial.sh`）と Vagrantfile を build サブフォルダに収めています。変更内容の詳細はそちらをご覧ください。

作成した box のパッケージファイルは、Vagrant Cloud に [bkenro/ffdsm](https://app.vagrantup.com/bkenro/boxes/ffdsm) という名前でアップロードしています。Vagrantfile で `config.vm.box = "bkenro/ffdsm"` と指定してお使いください。このプロジェクト直下にサンプルの Vagrantfile とマウント先の `www` フォルダを収めています。

なお、ベースとして使用した benro/ubuntu-20.04 ボックスのバージョンや、当方で動作確認した VirtualBox のバージョンについては、[bkenro/ffdsm](https://app.vagrantup.com/bkenro/boxes/ffdsm) のバージョンに記載のコメントを参照してください。

※名前について  
Ubuntu 20.04 LTS（**F**ocal **F**ossa）ベースの、**D**rupal **S**apporo **M**eetup 用に作った環境ということで、*ffdsm* としました。
