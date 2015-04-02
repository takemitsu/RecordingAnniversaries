
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
    .when '/list',
      templateUrl: '/partials/anniv/list.html'
      controller: 'AnnivListController'
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
