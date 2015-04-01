<?php namespace App\Http\Controllers;

use App\Http\Requests;
use App\Http\Requests\createDaysRequest;
use App\Http\Requests\updateDaysRequest;
use App\Http\Controllers\Controller;

use Illuminate\Http\Request;
use Illuminate\Contracts\Auth\Guard;

use App\Days;
use App\Entity;

class DaysController extends Controller {

	protected $auth;
	protected $days;

	public function __construct(Guard $auth, Days $days) {
		$this->middleware('auth');
		$this->auth = $auth;
		$this->days = $days;
	}

	public function store($entity_id, createDaysRequest $request)
	{
		$days = new Days;
		$days->name = $request->name;
		$days->desc = $request->desc;
		$days->anniv_at = $request->anniv_at;
		$days->entity_id = $entity_id;
		$days->save();
		return response()->json($days);
	}

	public function update($entity_id, $id, updateDaysRequest $request)
	{
		$days = $this->days->findOrFail($id);
		foreach ($request->only('name', 'desc','anniv_at') as $key => $value) {
			$days->$key = $value;
		}
		$days->save();
		return response()->json($days);
	}

	public function destroy($entity_id, $id)
	{
		$entity = Entity::where('user_id', $this->auth->id())
			->where('id', $entity_id)
			->firstOrFail();

		$days = $this->days->where('entity_id', $entity->id)
			->where('id', $id)
			->firstOrFail();
		$days->delete();

		return response()->json($days);
	}

}
