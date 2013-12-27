// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
angular.module('events', ['rails', 'ui.bootstrap'])
.factory('EventService', ['railsResourceFactory', function(railsResourceFactory) {
  return railsResourceFactory({
    url: '/events',
    name: 'event',
    responseInterceptors: [function(promise) {
      return promise.then(function(response) {
        response.data.$total = response.originalData.meta.total;
        return response;
      });
    }]
  });
}])
.controller('EventListCtrl', ['$scope', 'EventService', function($scope, EventService) {
  $scope.itemsPerPage = 100;

  var query = function(page) {
    EventService.query({page: page}).then(function(resp){
      $scope.events = resp;
      $scope.currentPage = page;
      $scope.totalItems = resp.$total;
      $scope.maxSize = 10;
    });
  };

  $scope.goToPage = function(page) {
    query(page);
  };

  query(1);
}])
.directive('event', ['$compile', '$http', '$templateCache', function($compile, $http, $templateCache) {

  var getTemplate = function(templateUrl) {
    return $http.get(templateUrl, {cache: $templateCache});
  };
  var linker = function(scope, element, attrs) {
    var loader = getTemplate(scope.event.templateUrl);
    var promise = loader.success(function(html) {
      element.html(html);
    }).then(function(resp) {
      element.replaceWith($compile(element.html())(scope));
    });
  };

  return {
    restrict: 'E',
    link: linker
  }
}]);

