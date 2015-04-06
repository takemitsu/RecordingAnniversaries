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

	private function log($str)
	{
		file_put_contents('php://stdout', "----------------------\n" . $str . "\n");
	}

	public function pickup()
	{
		$entities = $this->entity
			->where('user_id',$this->auth->id())
			->has('days')
			->with('days')
			->orderBy('created_at', 'asc')
			->get();

		foreach ($entities as $key => $entity) {
			if(count($entity->days) == 0) {
				unset($entities[$key]);
			}
			else {
				// days を diff_days でソート！！
				$s = array();
				foreach ($entity->days as $d) {
					array_push($s, $d);
				}
				usort($s, $this->build_sorter('diff_days'));
				unset($entities[$key]->days);
				$entities[$key]->days = $s;
			}
		}
		return $entities->toJson();
	}

	// for sort
	static function build_sorter($key) {
		return function ($a, $b) use($key) {
			return strnatcasecmp($a[$key], $b[$key]);
		};
	}

	public function index()
	{
		$entities = $this->entity
				->where('user_id',$this->auth->id())
				->with('days')
				->orderBy('created_at', 'asc')
				->paginate(20);

		return $entities->toJson();
	}

	public function show($id)
	{
		$entity = $this->entity
			->where('user_id', $this->auth->id())
			->where('id', $id)
			->firstOrFail();

		return $entity->toJson();
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
