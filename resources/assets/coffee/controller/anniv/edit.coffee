
mainControllers.controller 'EntityEditController', ($scope, $modalInstance, $http, entity) ->
    $scope.entity = $.extend {}, entity

    $scope.save = ->
        method = 'post'
        endPoint = "/api/entities"
        if entity.id
            method = 'put'
            endPoint += "/" + entity.id

        $http
            method: method
            url: endPoint
            data: $scope.entity
        .success (json) ->
            $modalInstance.close(json)
        .error networkError

    $scope.cancel = ->
        $modalInstance.dismiss('cancel')
