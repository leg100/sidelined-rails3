// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
angular.module('revisions', ['rails', 'ui.bootstrap', 'alerts'])
.factory('Revision', ['railsResourceFactory', function(railsResourceFactory) {
  return railsResourceFactory({
    url: '/api/history_trackers',
    name: 'history_tracker',
    responseInterceptors: [function(promise) {
      return promise.then(function(response) {
        if (response.originalData.meta)
          response.data.$total = response.originalData.meta.total;
        return response;
      });
    }]
  });
}])
.factory('RevisionListingService', ['$rootScope', function($rootScope) {
  var revisionListingService = {};
  revisionListingService.broadcastItem = function() {
    $rootScope.$broadcast('handleBroadcast')
  };
  return revisionListingService;
}])
.controller('RevisionListCtrl', ['$scope', 'Revision', 'AlertBroker', function($scope, Revision,  AlertBroker) {
  $scope.itemsPerPage = 100;

  $scope.format = 'dd-MMMM-yyyy';

  var query = function(page) {
    Revision.query({page: page}).then(function(resp){
      $scope.revisions = resp;
      $scope.currentPage = page;
      $scope.totalItems = resp.$total;
      $scope.maxSize = 10;
    });
  };

  $scope.$on('handleBroadcast', function() {
    query(1);
  });

  $scope.goToPage = function(page) {
    query(page);
  };

  query(1);
}])
.controller('RevisionCtrl', ['$scope', 'Revision', 'RevisionListingService', 'AlertBroker', function($scope, Revision, RevisionListingService, AlertBroker) {
  $scope.editMode = false;
  $scope.toggleEditMode = function(){
    $scope.editMode = !$scope.editMode;
  };

  $scope.editEvent = function() {
    $scope.toggleEditMode();
  };
}]);
