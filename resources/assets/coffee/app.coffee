
mainApp = angular.module 'mainApp', [
  'ngRoute'
#  'ngSanitize'
#  'mainFactories'
  'mainControllers'
  'ui.bootstrap'
#  'angularFileUpload'
#  'hc.marked'
#  'ui.utils'
]

mainApp.config ['$routeProvider', ($routeProvider) ->
    $routeProvider
    .when '/index',
      templateUrl: '/partials/anniv/index.html'
      controller: 'AnnivIndexController'
    # entity
    #.when '/entity',
    #  templateUrl: '/partials/entity/index.html'
    #  controller: 'EntityIndexController'
    #.when '/entity/:id',
    #  templateUrl: '/partials/entity/detail.html'
    #  controller: 'EntityDetailController'

    .otherwise
      redirectTo: '/index'
]


mainControllers = angular.module 'mainControllers', []


mainControllers.controller 'AnnivIndexController', ($scope, $http, $location, $routeParams, $modal, $log) ->
	$log.info('Load AnnivIndexController')
	$log.info('Load2')