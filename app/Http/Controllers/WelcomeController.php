<?php namespace App\Http\Controllers;

use Illuminate\Contracts\Auth\Guard;

class WelcomeController extends Controller {

	public function __construct(Guard $auth)
	{
		$this->middleware('guest');
	}

	public function index()
	{
		return view('welcome');
	}

}
