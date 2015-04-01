<?php namespace App;

use Illuminate\Database\Eloquent\Model;

class Days extends Model {

	public function Entity() {
		return $this->belongsTo('App\Entity');
	}

}
