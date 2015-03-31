<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateAlarmsTable extends Migration {

	/**
	 * Run the migrations.
	 *
	 * @return void
	 */
	public function up()
	{
		Schema::create('alarms', function(Blueprint $table)
		{
			$table->increments('id');
			$table->integer('days_id');
			$table->integer('type')->unsigned()->default(0);
			$table->date('alarm_at')->nullable();
			$table->integer('alarm_days')->unsigned()->default(0);
			$table->boolean('enabled')->default(true);
			$table->timestamps();
		});
	}

	/**
	 * Reverse the migrations.
	 *
	 * @return void
	 */
	public function down()
	{
		Schema::drop('alarms');
	}

}
