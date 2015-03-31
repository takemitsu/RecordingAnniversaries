(function() {
  var mainApp, mainControllers;

  mainApp = angular.module('mainApp', ['ngRoute', 'mainControllers', 'ui.bootstrap']);

  mainApp.config([
    '$routeProvider', function($routeProvider) {
      return $routeProvider.when('/index', {
        templateUrl: '/partials/anniv/index.html',
        controller: 'AnnivIndexController'
      }).otherwise({
        redirectTo: '/index'
      });
    }
  ]);

  mainControllers = angular.module('mainControllers', []);

  mainControllers.controller('AnnivIndexController', function($scope, $http, $location, $routeParams, $modal, $log) {
    $log.info('Load AnnivIndexController');
    return $log.info('Load2');
  });

}).call(this);

//# sourceMappingURL=app.js.map