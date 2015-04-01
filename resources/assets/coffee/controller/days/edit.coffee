
mainControllers.controller 'DaysEditController', ($scope, $modalInstance, $http, days) ->
    $scope.days = $.extend {}, days

    $scope.today = ->
        $scope.days.anniv_at = new Date()
    $scope.clear = ->
        $scope.days.anniv_at = null

    $scope.open = ($event) ->
        $event.preventDefault()
        $event.stopPropagation()
        $scope.opened = true

    $scope.dateOptions =
        formatYear: 'yy'
        startingDay: 1

    $scope.format = 'yyyy-MM-dd'

    $scope.save = ->
        method = 'post'
        endPoint = "/api/entities/" + days.entity_id + "/days"

        if days.id
            method = 'put'
            endPoint += "/" + days.id

        $http
            method: method
            url: endPoint
            data: $scope.days
        .success (json) ->
            $modalInstance.close(json)
        .error networkError

    $scope.cancel = ->
        $modalInstance.dismiss('cancel')
