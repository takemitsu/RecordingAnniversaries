<?php

Route::get('/', 'WelcomeController@index');

Route::get('anniv', 'AnnivController@index');

Route::controllers([
	'auth' => 'Auth\AuthController',
	'password' => 'Auth\PasswordController',
]);

Route::get('config', function() {
    $version = Array(
        "version" => "1.0",
    );
    return Response()->json($version);
});

Route::group(array('prefix' => 'api'), function() {

    Route::post('auth/login','Auth\APIController@login');
    Route::get('auth/token', 'Auth\APIController@getToken');

	Route::get('entities/pickup', 'EntityController@pickup');
	Route::resource('entities', 'EntityController',
		['only' => ['index', 'store', 'update' , 'destroy', 'show'],]);

	Route::resource('entities.days', 'DaysController',
		['only' => ['store', 'update' , 'destroy', 'show'],]);
});

Route::resource('test', 'TestController');
// for debug
// データベースログ出力(use only php artisan serv)
// DB::listen(function($sql, $bindings, $time)
// {
//     file_put_contents('php://stdout', "[SQL] {$sql} \n" .
//                       "      bindings:\t".json_encode($bindings)."\n".
//                       "      time:\t{$time} milliseconds\n");
// });

// file_put_contents('php://stdout', "----------------------");
