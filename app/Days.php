<?php namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Days extends Model {

	use SoftDeletes;

	protected $dates = ['deleted_at'];

	public function Entity() {
		return $this->belongsTo('App\Entity');
	}

}
