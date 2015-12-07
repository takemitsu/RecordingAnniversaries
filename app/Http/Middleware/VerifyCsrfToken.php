<?php namespace App\Http\Middleware;

use Closure;
use Illuminate\Foundation\Http\Middleware\VerifyCsrfToken as BaseVerifier;

class VerifyCsrfToken extends BaseVerifier {

    protected $routes = [
        'api/auth/login',
    ];

	/**
	 * Handle an incoming request.
	 *
	 * @param  \Illuminate\Http\Request  $request
	 * @param  \Closure  $next
	 * @return mixed
	 */
	public function handle($request, Closure $next)
	{

        if($this->excludedRoutes($request)){
            return $this->addCookieToResponse($request, $next($request));
        }

		return parent::handle($request, $next);
	}

    protected function excludedRoutes($request) {
        foreach($this->routes as $route) {
            if($request->is($route)) { return true; }
        }
    }
}
