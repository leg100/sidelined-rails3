angular.module('alerts', [])
// vidiprinter broker
.factory('AlertBroker', ['$rootScope', function($rootScope) {
  var alertBroker = {};
  alertBroker.broadcastAlert = function(msg) {
    this.message = msg;
    $rootScope.$broadcast('alert');
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
  $scope.$on('alert', function() {
    $scope.alerts.push({
      msg: AlertBroker.message,
      type: "success"
    });
    $timeout(closeLastAlert, 5000);
  });
}])
