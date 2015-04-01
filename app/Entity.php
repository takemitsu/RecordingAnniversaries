<?php namespace App;

use Illuminate\Database\Eloquent\Model;

class Entity extends Model {

	public function days() {
		return $this->hasMany('App\Days');
	}

	public function user() {
		return $this->belongsTo('App\User');
	}

}
