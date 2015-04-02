(function() {
  var mainApp, mainControllers, networkError, showErrorMessage, showMessage, showSuccessMessage;

  mainApp = angular.module('mainApp', ['ngRoute', 'mainControllers', 'ui.bootstrap']);

  mainApp.config([
    '$routeProvider', function($routeProvider) {
      return $routeProvider.when('/index', {
        templateUrl: '/partials/anniv/index.html',
        controller: 'AnnivIndexController'
      }).when('/list', {
        templateUrl: '/partials/anniv/list.html',
        controller: 'AnnivListController'
      }).otherwise({
        redirectTo: '/index'
      });
    }
  ]);

  mainControllers = angular.module('mainControllers', []);

  mainControllers.filter('JDate', function() {
    return function(input, only_wayear) {
      var date, dates, gengo, wayear;
      if (!input) {
        return '';
      }
      if (input.length !== 10) {
        return '';
      }
      dates = input.split("-");
      if (dates.length !== 3) {
        return '';
      }
      date = parseInt(dates.join(""));
      if (!date) {
        return '';
      }
      if (dates[0] > 2099) {
        return '';
      }
      if (dates[1] > 12 || dates[1] === "00") {
        return '';
      }
      if (dates[2] > 31 || dates[2] === "00") {
        return;
      }
      if (date >= 19890108) {
        gengo = '平成';
        wayear = dates[0] - 1988;
      } else if (date >= 19261225) {
        gengo = '昭和';
        wayear = dates[0] - 1925;
      } else if (date >= 19120730) {
        gengo = '大正';
        wayear = dates[0] - 1911;
      } else if (date >= 18680125) {
        gengo = '明治';
        wayear = dates[0] - 1867;
      } else {
        return '';
      }
      if (wayear === 1) {
        wayear = '元';
      }
      if (only_wayear === 1) {
        return gengo + wayear + '年';
      }
      return gengo + wayear + '年' + dates[1] + '月' + dates[2] + '日';
    };
  });

  mainControllers.filter('DiffDate', function() {
    return function(input) {
      var date, dates, diff, diffDay, diff_date, now;
      if (!input) {
        return '';
      }
      if (input.length !== 10) {
        return '';
      }
      dates = input.split("-");
      if (dates.length !== 3) {
        return '';
      }
      date = parseInt(dates.join(""));
      if (!date) {
        return '';
      }
      if (dates[0] > 2099) {
        return '';
      }
      if (dates[1] > 12 || dates[1] === "00") {
        return '';
      }
      if (dates[2] > 31 || dates[2] === "00") {
        return;
      }
      date = new Date(dates[0], dates[1] - 1, dates[2]);
      now = new Date();
      now = new Date(now.getFullYear(), now.getMonth(), now.getDate());
      diff_date = new Date(now.getFullYear(), date.getMonth(), date.getDate());
      if (now > diff_date) {
        diff_date = new Date(now.getFullYear() + 1, date.getMonth(), date.getDate());
      }
      diff = diff_date - now;
      diffDay = diff / 86400000;
      return diffDay;
    };
  });

  showMessage = function(type, message, autoclose) {
    if (autoclose == null) {
      autoclose = true;
    }
    $('#message .alert').addClass('alert-' + type).empty().append(message);
    $('#message').removeClass('hidden').show('fade');
    if (autoclose) {
      return setTimeout(function() {
        return $('#message').hide('fade', function() {
          return $('#message .alert').removeClass('alert-' + type);
        });
      }, 2000);
    }
  };

  showSuccessMessage = function(message) {
    return showMessage('success', message);
  };

  showErrorMessage = function(message) {
    return showMessage('danger', message);
  };

  networkError = function(json, status) {
    if (status !== 401) {
      return showErrorMessage(json.message);
    } else {
      return location.href = '/';
    }
  };

  mainControllers.controller('AnnivIndexController', function($scope, $http, $location, $routeParams, $modal, $log) {
    $scope.loadDetail = function() {
      return $http.get("/api/entities/pickup").success(function(data) {
        return $scope.entities = data;
      }).error(function(data) {
        return $log.info(data);
      });
    };
    return $scope.loadDetail();
  });

  mainControllers.controller('AnnivListController', function($scope, $http, $location, $routeParams, $modal, $log) {
    $scope.maxSize = 5;
    $scope.itemPerPage = 10;
    $scope.totalItems = 1;
    $scope.filters = {
      page: 1
    };
    $scope.loadDetail = function() {
      return $http.get("/api/entities", {
        params: $scope.filters
      }).success(function(data) {
        $scope.entities = data.data;
        $scope.filters.page = data.current_page;
        $scope.itemPerPage = data.per_page;
        return $scope.totalItems = data.total;
      }).error(function(data) {
        return $log.info(data);
      });
    };
    $scope.loadDetail();
    $scope.addEntity = function() {
      return $scope.editEntity(null);
    };
    $scope.editEntity = function(entity) {
      var instance;
      instance = $modal.open({
        templateUrl: '/partials/entity/modal/edit.html',
        controller: 'EntityEditController',
        resolve: {
          entity: function() {
            if (entity) {
              return entity;
            } else {
              return {
                name: '',
                desc: ''
              };
            }
          }
        }
      });
      return instance.result.then(function(selectItem) {
        showSuccessMessage('保存しました');
        return $scope.loadDetail();
      }, function() {
        return $log.info('dismiss editEntity');
      });
    };
    $scope.deleteEntity = function(entity) {
      if (confirm(entity.name + " を削除します。よろしいですか？")) {
        return $http({
          method: 'delete',
          url: "/api/entities/" + entity.id
        }).success(function(json) {
          return $scope.loadDetail();
        }).error(networkError);
      }
    };
    $scope.addAnniv = function(entity) {
      return $scope.editAnniv(entity, null);
    };
    $scope.editAnniv = function(entity, anniv) {
      var instance;
      instance = $modal.open({
        templateUrl: '/partials/days/modal/edit.html',
        controller: 'DaysEditController',
        resolve: {
          days: function() {
            if (anniv) {
              return anniv;
            } else {
              return {
                name: '',
                desc: '',
                anniv_at: '',
                entity_id: entity.id
              };
            }
          }
        }
      });
      return instance.result.then(function(selectItem) {
        showSuccessMessage('保存しました');
        return $scope.loadDetail();
      }, function() {
        return $log.info('dismiss editAnniv');
      });
    };
    return $scope.deleteAnniv = function(anniv) {
      if (confirm(anniv.name + " を削除します。よろしいですか？")) {
        return $http({
          method: 'delete',
          url: '/api/entities/' + anniv.entity_id + '/days/' + anniv.id
        }).success(function(json) {
          return $scope.loadDetail();
        }).error(networkError);
      }
    };
  });

  mainControllers.controller('EntityEditController', function($scope, $modalInstance, $http, entity) {
    $scope.entity = $.extend({}, entity);
    $scope.save = function() {
      var endPoint, method;
      method = 'post';
      endPoint = "/api/entities";
      if (entity.id) {
        method = 'put';
        endPoint += "/" + entity.id;
      }
      return $http({
        method: method,
        url: endPoint,
        data: $scope.entity
      }).success(function(json) {
        return $modalInstance.close(json);
      }).error(networkError);
    };
    return $scope.cancel = function() {
      return $modalInstance.dismiss('cancel');
    };
  });

  mainControllers.controller('DaysEditController', function($scope, $modalInstance, $http, $filter, days) {
    $scope.days = $.extend({}, days);
    $scope.today = function() {
      return $scope.days.anniv_at = new Date();
    };
    $scope.clear = function() {
      return $scope.days.anniv_at = null;
    };
    $scope.open = function($event) {
      $event.preventDefault();
      $event.stopPropagation();
      return $scope.opened = true;
    };
    $scope.dateOptions = {
      formatYear: 'yy',
      startingDay: 1
    };
    $scope.format = 'yyyy-MM-dd';
    $scope.save = function() {
      var endPoint, method;
      $scope.days.anniv_at = $filter('date')($scope.days.anniv_at, $scope.format);
      method = 'post';
      endPoint = "/api/entities/" + days.entity_id + "/days";
      if (days.id) {
        method = 'put';
        endPoint += "/" + days.id;
      }
      return $http({
        method: method,
        url: endPoint,
        data: $scope.days
      }).success(function(json) {
        return $modalInstance.close(json);
      }).error(networkError);
    };
    return $scope.cancel = function() {
      return $modalInstance.dismiss('cancel');
    };
  });

}).call(this);

//# sourceMappingURL=app.js.map