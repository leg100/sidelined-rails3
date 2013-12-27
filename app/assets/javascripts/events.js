// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
angular.module('events', ['rails'])
.factory('EventService', ['railsResourceFactory', function(railsResourceFactory) {
  return railsResourceFactory({
    url: '/events',
    name: 'event'
  });
}])
.controller('EventsCtrl', ['$scope', 'EventService', function($scope, EventService) {
  EventService.query({}).then(function(resp){
    console.log(resp[0]);
    console.log(resp[1]);
    $scope.events = resp;
  });
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

