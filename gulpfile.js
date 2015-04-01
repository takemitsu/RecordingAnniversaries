var gulp   = require("gulp");
var concat = require("gulp-concat")
var elixir = require('laravel-elixir');
var _      = require('underscore');     // npm install xx

/*
 |--------------------------------------------------------------------------
 | combine files
 |--------------------------------------------------------------------------
 | mix.combineCoffee([input files],
 | {
 |    distname : output name
 |    distpath : output path
 | }
 */

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

/*
 |--------------------------------------------------------------------------
 | Elixir Asset Management
 |--------------------------------------------------------------------------
 |
 | Elixir provides a clean, fluent API for defining some basic Gulp tasks
 | for your Laravel application. By default, we are compiling the Less
 | file for our application, as well as publishing vendor resources.
 |
 */

elixir(function(mix) {
	mix.less('app.less');

	mix.combineCoffee([
			'resources/assets/coffee/router.coffee',
			'resources/assets/coffee/main.coffee',
			'resources/assets/coffee/util/message.coffee',
			'resources/assets/coffee/controller/anniv/index.coffee',
			'resources/assets/coffee/controller/anniv/edit.coffee',
			'resources/assets/coffee/controller/days/edit.coffee'
	]);
	mix.coffee('app.coffee');
});
