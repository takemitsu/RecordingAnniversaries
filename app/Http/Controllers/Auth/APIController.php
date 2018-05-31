<?php namespace App\Http\Controllers\Auth;

use App\Http\Requests;
use App\Http\Controllers\Controller;

use Illuminate\Http\Request;
use Illuminate\Contracts\Auth\Guard;

use App\Entity;

class APIController extends Controller {

	protected $entity;
	protected $auth;

	public function __construct(Entity $entity, Guard $auth) {
		//$this->middleware('auth');
		$this->entity = $entity;
		$this->auth = $auth;
	}

	public function login(Request $request)
	{
        if($this->auth->check()){
            return response()->json($this->auth->user());
        }
        if($this->auth->attempt(['email' => $request->input('email'), 'password' => $request->input('password')])) {
            return response()->json($this->auth->user());
        }

        abort(401, 'Authenticate Error');

	}
    // get token
    public function getToken()
    {
        return response()->json([
          "token" => csrf_token(),
        ]);
    }
}
