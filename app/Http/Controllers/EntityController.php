<?php namespace App\Http\Controllers;

use App\Http\Requests;
use App\Http\Controllers\Controller;

use Illuminate\Http\Request;
use Illuminate\Contracts\Auth\Guard;

use App\Entity;
use App\Http\Requests\createEntityRequest;
use App\Http\Requests\updateEntityRequest;

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
				->orderBy('created_at', 'asc')
				->paginate(5)
		);
	}


	public function store(createEntityRequest $request)
	{
		$user = $this->auth->user();

		$entity = new Entity;
		$entity->name = $request->name;
		$entity->desc = $request->desc;
		$entity->user_id = $user->id;
		$entity->save();
		return response()->json($entity);
	}


	public function update($id, updateEntityRequest $request)
	{
		$entity = $this->entity->findOrFail($id);
		foreach ($request->only('name', 'desc') as $key => $value) {
			$entity->$key = $value;
		}
		$entity->save();
		return response()->json($entity);
	}


	public function destroy($id)
	{

		$entity = $this->entity
			->where('user_id', $this->auth->id())
			->where('id', $id)
			->firstOrFail();
		$entity->delete();
		return response()->json($entity);
	}

}
