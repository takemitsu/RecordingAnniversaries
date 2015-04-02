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

		$today = date('Y-m-d');
		// $this->log($today);

		//日付をUNIXタイムスタンプに変換
		$timeStampToday = strtotime($today);

		foreach ($entities as $key1 => $entity) {
			foreach ($entity->days as $key2 => $d) {
				$anniv_at_tmp = date('Y') . "-" . date('m-d', strtotime($d->anniv_at));
				$anniv_at = date($anniv_at_tmp);
				//日付をUNIXタイムスタンプに変換
				$timeStampAnniv = strtotime($anniv_at);
				//何秒離れているかを計算(絶対値)
				$secondDiff = ($timeStampAnniv - $timeStampToday);
				// マイナスなら年を足してもう１回
				if($secondDiff < 0) {
					$anniv_at_tmp = (date('Y') + 1) . "-" . date('m-d', strtotime($d->anniv_at));
					$anniv_at = date($anniv_at_tmp);
					$timeStampAnniv = strtotime($anniv_at);
					$secondDiff = ($timeStampAnniv - $timeStampToday);
				}
				//日数に変換
				$dayDiff = $secondDiff / (60 * 60 * 24);
				// $this->log($dayDiff);
				if($dayDiff > 30) {
					unset($entities[$key1]->days[$key2]);
				}
				else {
					$entities[$key1]->days[$key2]->diff_at = $anniv_at;
					$entities[$key1]->days[$key2]->diff_days = $dayDiff;
				}
			}
		}
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
				foreach ($s as $key1 => $value) {
					$key_id[$key1] = $value->diff_days;
				}
				array_multisort($key_id, SORT_ASC ,$s);
				// day は class有りのオブジェクトなので違う名前でソートしたものを格納
				$entities[$key]->sort_days = $s;
			}
		}

		return $entities->toJson();
	}



	public function index()
	{
		return
			$this->entity
				->where('user_id',$this->auth->id())
				->with('days')
				->orderBy('created_at', 'asc')
				->paginate(20)->toJson()
		;
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
