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
.controller('AlertCtrl', ['$scope', 'AlertBroker', function($scope, AlertBroker) {
  $scope.alerts = [];
  $scope.$on('alert', function() {
    $scope.alerts.push({
      msg: AlertBroker.message,
      type: "success"
    });
  });
  $scope.closeAlert = function(index) {
    $scope.alerts.splice(index, 1);
  };
}])
