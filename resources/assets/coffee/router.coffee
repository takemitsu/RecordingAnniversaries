
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
    .when '/entity',
      templateUrl: '/partials/entity/edit.html'
      controller: 'EntityEditController'
    .when '/entity/:id',
      templateUrl: '/partials/entity/edit.html'
      controller: 'EntityEditController'
    # days
    .when '/entity/:entity_id/days',
      templateUrl: '/partials/days/edit.html'
      controller: 'DaysEditController'
    .when '/entity/:entity_id/days/:id',
      templateUrl: '/partials/days/edit.html'
      controller: 'DaysEditController'

    .otherwise
      redirectTo: '/index'
]
