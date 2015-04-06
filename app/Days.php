<?php namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use DateTime;

class Days extends Model {

	use SoftDeletes;

	protected $dates = ['deleted_at'];

	public function Entity() {
		return $this->belongsTo('App\Entity');
	}

	protected $appends = ['diff_days'];

	public function getDiffDaysAttribute() {
		return $this->attributes['day_diff'] = $this->diff();
	}

	public function diff() {

		if(date("%d") == 29) {
			$sys_date = date('Y-m-d');
			$anniv_at_tmp = date('Y') . "-" . date('m-d', strtotime($this->anniv_at));
		}
		else {
			$sys_date = date('Y', strtotime($this->anniv_at)) . "-". date('m-d');
			$anniv_at_tmp = $this->anniv_at;
		}
		$sys_date = new DateTime($sys_date);
		$anniv_at = new DateTime($anniv_at_tmp);
		$interval = $sys_date->diff($anniv_at);
		// file_put_contents('php://stdout', "----------------------\n" . $interval->format("%R%a") . "\n");
		if($interval->format("%R") == "-") {
			if(date("%d", strtotime(date('Y') - 1 . date('-m-d'))) == 29) {
				$sys_date = date('Y') - 1 . date('-m-d');
			}
			else {
				$sys_date = date('Y', strtotime($this->anniv_at)) - 1 . "-". date('m-d');
			}
			$sys_date = new DateTime($sys_date);
			$interval = $sys_date->diff($anniv_at);
			// file_put_contents('php://stdout', "----------------------\n" . $interval->format("%R%a") . "\n");
		}
		// file_put_contents('php://stdout', "---- " . $interval->format("%R%a") . "");
		return (int)$interval->format("%a");
	}
}
