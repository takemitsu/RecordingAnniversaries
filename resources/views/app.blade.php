<!DOCTYPE html>
<html lang="en" ng-app="mainApp">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>Recording Anniversaries</title>

	<link href="{{ asset('/css/app.css') }}" rel="stylesheet">

	<!-- Fonts -->
	<link href='//fonts.googleapis.com/css?family=Roboto:400,300' rel='stylesheet' type='text/css'>

	<!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
	<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
	<!--[if lt IE 9]>
		<script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
		<script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
	<![endif]-->
</head>
<body>
	<nav class="navbar navbar-default">
		<div class="container-fluid">
			<div class="navbar-header">
				<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
					<span class="sr-only">Toggle Navigation</span>
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
				</button>
				<a class="navbar-brand" href="/anniv/#/index">Recording Anniversaries</a>
			</div>

			<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
				<ul class="nav navbar-nav navbar-right">
					@if (Auth::guest())
						<li><a href="{{ url('/auth/login') }}">Login</a></li>
						<li><a href="{{ url('/auth/register') }}">Register</a></li>
					@else
						<li><a href="/anniv/#/list">List</a></li>
						<li class="dropdown" dropdown>
							<a role="button" class="dropdown-toggle" dropdown-toggle>
								{{ Auth::user()->name }} <span class="caret"></span>
							</a>
							<ul class="dropdown-menu" role="menu">
								<li><a href="{{ url('/auth/logout') }}">Logout</a></li>
							</ul>
						</li>
					@endif
				</ul>
			</div>
		</div>
	</nav>

	<div id="message" class="hidden">
		<div class="alert">
		</div>
	</div>

	@yield('content')

	<!-- Scripts -->
	<script type="text/javascript" src="/js/common/jquery.min.js"></script>
	<script type="text/javascript" src="/js/common/bootstrap.min.js"></script>
	<script type="text/javascript" src="/js/common/angular.min.js"></script>
	<script type="text/javascript" src="/js/common/angular-route.min.js"></script>
	<script type="text/javascript" src="/js/common/ui-bootstrap.min.js"></script>
	<script type="text/javascript" src="/js/common/ui-bootstrap-tpls.min.js"></script>
	<script type="text/javascript" src="/js/app.js"></script>
</body>
</html>
