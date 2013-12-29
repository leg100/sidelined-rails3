// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
angular.module('events', ['rails', 'ui.bootstrap', 'alerts'])
.factory('EventListingService', ['$rootScope', function($rootScope) {
  var eventListingService = {};
  eventListingService.broadcastItem = function() {
    $rootScope.$broadcast('handleBroadcast')
  };
  return eventListingService;
}])
.factory('EventService', ['railsResourceFactory', function(railsResourceFactory) {
  return railsResourceFactory({
    url: '/events',
    name: 'event',
    responseInterceptors: [function(promise) {
      return promise.then(function(response) {
        if (response.originalData.meta)
          response.data.$total = response.originalData.meta.total;
        return response;
      });
    }]
  });
}])
.factory('Injury', ['railsResourceFactory', function(railsResourceFactory) {
  return railsResourceFactory({
    url: '/injuries',
    name: 'injury'
  });
}])
.factory('Player', ['railsResourceFactory', function(railsResourceFactory) {
  return railsResourceFactory({
    url: '/players',
    name: 'player'
  });
}])
.controller('EventAddCtrl', ['$scope', 'Player', 'EventService', function($scope, Player, EventService) {
  $scope.type = "injury";
  $scope.source = null;
  Player.query({typeahead: true}).then(function(resp) {
    $scope.players = resp;
    $scope.selected_player = resp[0];
  });
  $scope.add = function() {
    new EventService({
      _type: 'Injury',
      source: $scope.source,
      player: $scope.selected_player.id
    }).create()
  };
}])
.controller('InjuryAddCtrl', ['$scope', 'Player', 'Injury', 'EventListingService', 'AlertBroker', function($scope, Player, Injury, EventListingService, AlertBroker) {
  $scope.source = "http://source";
  $scope.selected_player = null;
  Player.query({typeahead: true}).then(function(resp) {
    $scope.players = resp;
  });
  $scope.add = function() {
    new Injury({
      source: $scope.source,
      player: $scope.selected_player.id
    }).create().then(function(injury) {
      AlertBroker.broadcastAlert("Added new injury to "+ $scope.selected_player.tickerAndName)
      EventListingService.broadcastItem();
    });
  };
}])
.controller('EventListCtrl', ['$scope', 'EventService', 'EventListingService', 'AlertBroker', function($scope, EventService, EventListingService, AlertBroker) {
  $scope.itemsPerPage = 100;

  var query = function(page) {
    EventService.query({page: page}).then(function(resp){
      $scope.events = resp;
      $scope.currentPage = page;
      $scope.totalItems = resp.$total;
      $scope.maxSize = 10;
    });
  };

  $scope.$on('handleBroadcast', function() {
    query(1);
  });

  $scope.removeEvent = function(index) {
    var event = $scope.events[index];

    event.remove().then(function(resp){
      query(1);
      AlertBroker.broadcastAlert("Removed event "+ resp.id) 
    });
  };

  $scope.goToPage = function(page) {
    query(page);
  };

  query(1);
}])
.directive('event', ['$compile', '$http', '$templateCache', 'EventService', function($compile, $http, $templateCache, EventService) {

  var getTemplate = function(templateUrl) {
    return $http.get(templateUrl, {cache: $templateCache});
  };
  var linker = function(scope, element, attrs) {
    console.log("linking");
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

