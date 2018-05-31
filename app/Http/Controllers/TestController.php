<?php namespace App\Http\Controllers;

use App\Http\Requests;
use App\Http\Controllers\Controller;

use Illuminate\Http\Request;

use Log;

class TestController extends Controller {

	public function index(Request $request)
	{
		Log::info('GET test');
        Log::info($request->all());
		return $_SERVER['HTTP_USER_AGENT'];
	}

	public function create()
	{
		Log::info('GET test/create');
	}

	public function store(Request $request)
	{
		Log::info('POST test');
		Log::info($request);
		Log::info('---');
		Log::info($request->all());
        # Log::info('---');
        # Log::info($request->getContent());
        return;
	}

	public function show($id)
	{
		Log::info('GET test/'.$id);
        Log::info($request->all());
	}

	public function edit($id)
	{
		Log::info('GET test/'.$id .'/edit');
        Log::info($request->all());
	}

	public function update($id, Request $request)
	{
		Log::info('PUT test/'.$id);
		Log::info($request);
        Log::info($request->all());
	}

	public function destroy($id)
	{
		Log::info('DELETE test/'.$id);
        Log::info($request->all());
	}

}
