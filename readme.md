## Laravel PHP Framework

[![Build Status](https://travis-ci.org/laravel/framework.svg)](https://travis-ci.org/laravel/framework)
[![Total Downloads](https://poser.pugx.org/laravel/framework/downloads.svg)](https://packagist.org/packages/laravel/framework)
[![Latest Stable Version](https://poser.pugx.org/laravel/framework/v/stable.svg)](https://packagist.org/packages/laravel/framework)
[![Latest Unstable Version](https://poser.pugx.org/laravel/framework/v/unstable.svg)](https://packagist.org/packages/laravel/framework)
[![License](https://poser.pugx.org/laravel/framework/license.svg)](https://packagist.org/packages/laravel/framework)

Laravel is a web application framework with expressive, elegant syntax. We believe development must be an enjoyable, creative experience to be truly fulfilling. Laravel attempts to take the pain out of development by easing common tasks used in the majority of web projects, such as authentication, routing, sessions, queueing, and caching.

Laravel is accessible, yet powerful, providing powerful tools needed for large, robust applications. A superb inversion of control container, expressive migration system, and tightly integrated unit testing support give you the tools you need to build any application with which you are tasked.

## Official Documentation

Documentation for the framework can be found on the [Laravel website](http://laravel.com/docs).

## Contributing

Thank you for considering contributing to the Laravel framework! The contribution guide can be found in the [Laravel documentation](http://laravel.com/docs/contributions).

### License

The Laravel framework is open-sourced software licensed under the [MIT license](http://opensource.org/licenses/MIT)

--

# Recording Anniversaries Project

> php, composer など関連のインストールは既に終わっている前提

## Laravel プロジェクト作成

Composerを使用し、Laravelインストーラーをダウンロード

```
composer global require "laravel/installer=~1.1"
```

Recording Anniversaries (めんどいんで略してra) プロジェクトを作成

```
laravel new ra
```

## 初期データベース関連

データベース作成

```
mysql -u root 
create database ra;
grant all privileges on ra.* to ra_user@localhost identified by '28bJYiDx2zUki1jd';
```

データベースに属する .env 変更

- .env

```
DB_HOST=localhost
DB_DATABASE=ra
DB_USERNAME=ra_user
DB_PASSWORD=28bJYiDx2zUki1jd
```

モデルを作成(同時にmigrateファイルができる)

```
php artisan make:model Entity
php artisan make:model Days
php artisan make:model Alarm
```

定義を編集

- database/migrations/2015_03_31_055233_create_entities_table.php 
- database/migrations/2015_03_31_055249_create_days_table.php
- database/migrations/2015_03_31_055300_create_alarms_table.php

テーブル概要

```
entity
  $table->increments('id');
  $table->integer('user_id');
  $table->string('name',255);
  $table->text('desc')->nullable();
  $table->integer('status')->unsigned()->default(0);
  $table->timestamps();

days
  $table->increments('id');
  $table->integer('entity_id');
  $table->string('name',255);
  $table->text('desc')->nullable();
  $table->date('anniv_at');
  $table->timestamps();

alarm お知らせ
  $table->increments('id');
  $table->integer('days_id');
  $table->integer('type')->unsigned()->default(0);
  $table->date('alarm_at')->nullable();
  $table->integer('alarm_days')->unsigned()->default(0);
  $table->boolean('enabled')->default(true);
  $table->timestamps();
```

データベースに適用

```
php artisan migrate
```

初期データ登録設定編集

- database/seeds/DatabaseSeeder.php

データベースに反映

```
php artisan db::seed
```

## bower での jquery等のインストール

> ファイルは bower_components/ 以下に入るので必要なファイルをコピーして使用する。
>> bower_components は .gitignore に登録したほうがいいかも

update

```
npm update -g bower
```

jquery, angular-bootstrap

```
bower install jquery
bower install bootstrap
bower install angular-bootstrap
bower install angular
bower install angular-route
```

その他, 必要に応じて

```
bower install angular-cookies
bower install ng-file-upload 
etc..
```



## gulp 設定

gulp 動作確認

```
composer update
# node インストール確認
npm -v
# gulp インストール確認(npm install --global gulp でインストール)
gulp -v
npm install (laravelのrootで行う)
# 実行テスト
gulp

# 必要に応じ
npm install gulp-shell
```

coffee script 使うように gulp 設定ファイル編集

> coffee ファイルを結合してからコンパイルしたかったため、
> 結合エクステンションを作成

```
var gulp   = require("gulp");
var concat = require("gulp-concat")
var elixir = require('laravel-elixir');
var _      = require('underscore');     // npm install xx

"use strict";
var config = {
	distname : "app.coffee",
	distpath : "resources/assets/coffee/"
}
elixir.extend('combineCoffee', function(src, options) {
	options = _.extend(config, options);
	src = src || "resources/assets/coffee/**/*.coffee";

	gulp.task('combineCoffee', function() {
		gulp.src(src)
			.pipe(concat(options.distname))
			.pipe(gulp.dest(options.distpath));
	});
	this.registerWatcher('combineCoffee', src);
	return this.queueTask('combineCoffee');
});

// elixir 本体

elixir(function(mix) {
	mix.less('app.less');

	mix.combineCoffee([
			'resources/assets/coffee/router.coffee',
			'resources/assets/coffee/main.coffee',
			'resources/assets/coffee/controller/anniv/anniv_index.coffee'
	]);
	mix.coffee('app.coffee');
});
```

## todo 2015-04-01

- 和暦で表示したいよね
- アラーム使ってなんか表示する
- など！