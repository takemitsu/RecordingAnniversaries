
mainControllers.controller 'EntityEditController', ($scope, $http, $location, $route, $routeParams, $log) ->
    $log.info $routeParams.id

    $scope.entity = {}
    $scope.old_entity = {}

    if $routeParams.id
        $http.get "/api/entities/" + $routeParams.id
        .success (json) ->
            $scope.old_entity = json
            $scope.entity = json
        .error networkError

    $scope.save = ->
        method = 'post'
        endPoint = "/api/entities"
        if $scope.old_entity.id
            method = 'put'
            endPoint += "/" + $scope.old_entity.id

        $http
            method: method
            url: endPoint
            data: $scope.entity
        .success (json) ->
            showSuccessMessage '保存しました'
            $scope.redirect()
        .error networkError

    $scope.cancel = ->
        $scope.redirect()

    $scope.redirect = ->
        $location.path "/list"
