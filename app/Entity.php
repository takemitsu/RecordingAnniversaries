<?php namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Entity extends Model {

	use SoftDeletes;

	protected $dates = ['deleted_at'];

	public function days() {
		return $this->hasMany('App\Days');
	}

	public function user() {
		return $this->belongsTo('App\User');
	}

}
