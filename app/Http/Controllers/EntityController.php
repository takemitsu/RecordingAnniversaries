<?php namespace App\Http\Controllers;

use App\Http\Requests;
use App\Http\Controllers\Controller;

use Illuminate\Http\Request;
use Illuminate\Contracts\Auth\Guard;

use App\Entity;

class EntityController extends Controller {

	protected $entity;
	protected $auth;

	public function __construct(Entity $entity, Guard $auth) {
		$this->middleware('auth');
		$this->entity = $entity;
		$this->auth = $auth;
	}

	public function index()
	{
		$user = $this->auth->user();

		return response()->json(
			$entities = $this->entity
				->whereRaw('user_id = ?',[$user->id])
				->with('days')
				->orderBy('created_at', 'desc')
				->paginate(5)
		);
	}


	public function store()
	{
		//
	}


	public function show($id)
	{
		//
	}


	public function update($id)
	{
		//
	}


	public function destroy($id)
	{
		//
	}

}
