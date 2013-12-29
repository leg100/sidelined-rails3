angular.module('alerts', [])
// vidiprinter broker
.factory('AlertBroker', ['$rootScope', function($rootScope) {
  var alertBroker = {};
  alertBroker.success = function(msg) {
    this.message = msg;
    $rootScope.$broadcast('alert-success');
  };
  alertBroker.error = function(msg) {
    this.message = msg;
    $rootScope.$broadcast('alert-error');
  };
  return alertBroker;
}])
.controller('AlertCtrl', ['$scope', 'AlertBroker', '$timeout', function($scope, AlertBroker, $timeout) {
  $scope.alerts = [];
  $scope.closeAlert = function(index) {
    $scope.alerts.splice(index, 1);
  };

  function closeLastAlert() {
    $scope.alerts.pop();
  };

  function createAlert(type) {
    $scope.alerts.push({
      msg: AlertBroker.message,
      type: type
    });
    $timeout(closeLastAlert, 5000);
  };

  $scope.$on('alert-success', function() {
    createAlert('success');
  });

  $scope.$on('alert-error', function() {
    createAlert('danger');
  });
}])
