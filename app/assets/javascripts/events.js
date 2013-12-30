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
    url: '/api/events',
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
    url: '/api/injuries',
    name: 'injury'
  });
}])
.factory('Player', ['railsResourceFactory', function(railsResourceFactory) {
  return railsResourceFactory({
    url: '/api/players',
    name: 'player'
  });
}])
.controller('InjuryEditCtrl', ['$scope', 'Player', 'Injury', 'EventListingService', 'AlertBroker', 'limitToFilter', '$filter', function($scope, Player, Injury, EventListingService, AlertBroker, limitToFilter, $filter) {
  // init params
  $scope.type = 'injury';

  // datepicker
  $scope.dateOptions = {
    'year-format': "'yy'",
    'starting-day': 1
  };
  $scope.today = function() {
    $scope.minDate = new Date();
  };
  $scope.today();
  $scope.formats = ['dd-MMMM-yyyy', 'yyyy/MM/dd', 'shortDate'];
  $scope.format = $scope.formats[0];
  $scope.open = function($event) {
    $event.preventDefault();
    $event.stopPropagation();
    $scope.opened = true;
  };

  // populate typeahead
  $scope.getPlayers = function(substring) {
    return Player.query(
      {typeahead: true}
    ).then(function(resp) {
      return limitToFilter( $filter('filter')(resp, substring), 8);
    });
  };

  // trigger update
  $scope.add = function() {
    new Injury({
      source: $scope.event.source,
      player: $scope.event.selected_player.id,
      return_date: $scope.event.returnDate
    }).create().then(function(injury) {
      AlertBroker.success("Added new injury to "+ $scope.event.selected_player.tickerAndName)
      EventListingService.broadcastItem();
    }, function(err) {
      AlertBroker.error(err.data);
    });
  };

  $scope.canSave = function() {
    return $scope.form.$dirty && $scope.form.$valid;
  };

  $scope.canUpdate = function() {
    return $scope.form.$dirty && $scope.form.$valid;
  };

  $scope.cancelUpdate = function() {
    $scope.toggleEditMode();
  };

  $scope.updateEvent = function() {
    $scope.event.update().then(function(resp) {
      $scope.toggleEditMode();
      AlertBroker.success("Updated event "+ resp.id);
    }, function(err) {
      AlertBroker.error(err.data);
    });
  };
}])
.controller('EventListCtrl', ['$scope', 'EventService', 'EventListingService', 'AlertBroker', function($scope, EventService, EventListingService, AlertBroker) {
  $scope.itemsPerPage = 100;

  $scope.formats = ['dd-MMMM-yyyy', 'yyyy/MM/dd', 'shortDate'];
  $scope.format = $scope.formats[0];

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
      AlertBroker.success("Removed event "+ resp.id) 
    });
  };

  $scope.goToPage = function(page) {
    query(page);
  };

  query(1);
}])
.controller('EventCtrl', ['$scope', 'EventService', 'EventListingService', 'AlertBroker', function($scope, EventService, EventListingService, AlertBroker) {
  $scope.editMode = false;
  $scope.toggleEditMode = function(){
    $scope.editMode = !$scope.editMode;
  };

  $scope.editEvent = function() {
    $scope.toggleEditMode();
  };
}]);
