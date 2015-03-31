<?php

use Illuminate\Database\Seeder;
use Illuminate\Database\Eloquent\Model;

use App\User;
use App\Entity;
use App\Days;

class DatabaseSeeder extends Seeder {

	/**
	 * Run the database seeds.
	 *
	 * @return void
	 */
	public function run()
	{
		Model::unguard();

		$this->call('UserTableSeeder');
		$this->call('EntityTableSeeder');
	}

}

class UserTableSeeder extends Seeder {

	public function run()
	{
		DB::table('users')->delete();
		User::create([
			'id'       => 1,
			'email'    => 'takemitsu@notespace.jp',
			'name'     => 'takemitsu',
			'password' => Hash::make('nsp'),
		]);
	}
}

class EntityTableSeeder extends Seeder {
	public function run()
	{
		DB::table('entities')->delete();
		DB::table('days')->delete();

		Entity::create([
			'id'      => 1,
			'user_id' => 1,
			'name'    => '長女'
		]);

		Days::create([
			'id'        => 1,
			'entity_id' => 1,
			'name'      => '誕生日',
			'anniv_at'  => '2006-02-03'
		]);
	}
}
