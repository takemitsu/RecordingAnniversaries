<?php namespace App\Http\Requests;

use Auth;

use App\Http\Requests\Request;
use App\Entity;

class updateEntityRequest extends Request {

	/**
	 * Determine if the user is authorized to make this request.
	 *
	 * @return bool
	 */
	public function authorize()
	{
		$entity_id = $this->route('entities');
		return Entity::where('id', $entity_id)
			->where('user_id', Auth::id())->exists();
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
			'desc' => 'sometimes|string'
		];
	}

}
