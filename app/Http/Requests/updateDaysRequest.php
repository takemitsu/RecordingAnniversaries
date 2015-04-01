<?php namespace App\Http\Requests;

use App\Http\Requests\Request;
use App\Entity;
use App\Days;
use Auth;

class updateDaysRequest extends Request {

	/**
	 * Determine if the user is authorized to make this request.
	 *
	 * @return bool
	 */
	public function authorize()
	{
		// entity check
		$entity_id = $this->route('entities');
		$entity = Entity::where('id', $entity_id)
			->where('user_id', Auth::id())
			->exists();

		// days check
		$days_id = $this->route('days');
		$days = Days::where('id', $days_id)
			->where('entity_id', $entity_id)
			->exists();

		return $entity && $days;
	}

	/**
	 * Get the validation rules that apply to the request.
	 *
	 * @return array
	 */
	public function rules()
	{
		return [
			'name' => 'required|string|max:255',
			'desc' => 'sometimes|string',
			'anniv_at' => 'required|date_format:Y-m-d'
		];
	}

}
