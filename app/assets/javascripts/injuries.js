// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
angular.module('injuries', ['rails', 'ui.bootstrap', 'alerts', 'players', 'utils'])
.factory('InjuryListingService', ['$rootScope', function($rootScope) {
  var injuryListingService = {};
  injuryListingService.broadcastItem = function() {
    $rootScope.$broadcast('handleBroadcast')
  };
  return injuryListingService;
}])
.factory('Injury', ['railsResourceFactory', function(railsResourceFactory) {
  return railsResourceFactory({
    url: '/api/injuries',
    name: 'injury',
    pluralName: 'injuries',
    responseInterceptors: [function(promise) {
      return promise.then(function(response) {
        if (response.originalData.meta)
          response.data.$total = response.originalData.meta.total;
        return response;
      });
    }]
  });
}])
.controller('InjuryEditCtrl', ['$scope', 'Player', 'Injury', 'InjuryListingService', 'AlertBroker', 'limitToFilter', '$filter', function($scope, Player, Injury, InjuryListingService, AlertBroker, limitToFilter, $filter) {
  // init params
  $scope.type = 'injury';
  $scope.injury || ($scope.injury = {
    player: null,
    source: null,
    quote: null,
    returnDate: null
  });

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
  // WTF is this?
  //$scope.open = function($event) {
  //  $event.preventDefault();
  //  $event.stopPropagation();
  //  $scope.opened = true;
  //};

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
      source: $scope.injury.source,
      quote: $scope.injury.quote,
      player: $scope.injury.player.id,
      return_date: $scope.injury.returnDate
    }).create().then(function(injury) {
      AlertBroker.success("Added new injury to "+ $scope.injury.player.tickerAndName)
      InjuryListingService.broadcastItem();
    }, function(err) {
      AlertBroker.injury(err.data);
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

  $scope.updateInjury = function() {
    $scope.injury.update().then(function(resp) {
      $scope.toggleEditMode();
      AlertBroker.success("Updated injury "+ resp.id);
    }, function(err) {
      AlertBroker.injury(err.data);
    });
  };
}])
.controller('InjuryListCtrl', ['$scope', 'Injury', 'InjuryListingService', 'AlertBroker', 'injuries', '$location', function($scope, Injury, InjuryListingService, AlertBroker, injuries, $location) {
  $scope.itemsPerPage = 100;
  $scope.format = 'dd-MMMM-yyyy';
  $scope.injuries = injuries;
  $scope.currentPage = 1; //$routeParams.page || 1;
  $scope.totalItems = injuries.$total;
  $scope.maxSize = 10;

  $scope.$on('handleBroadcast', function() {
    Injury.query({page: 1, _type: 'Injury'})
      .then(function(resp) {
         $scope.injuries = resp;
      });
  });

  $scope.removeInjury = function(index) {
    var injury = $scope.injuries[index];

    injury.remove().then(function(resp){
      Injury.query({page: 1})
        .then(function(resp) {
           $scope.injuries = resp;
        });
      AlertBroker.success("Removed injury "+ resp.id);
    });
  };

  $scope.goToPage = function(page) {
    $location.path('/all/'+ page);
  };
}])
.controller('InjuryCtrl', ['$scope', 'Injury', 'InjuryListingService', 'AlertBroker', function($scope, Injury, InjuryListingService, AlertBroker) {
  $scope.editMode = false;
  $scope.toggleEditMode = function(){
    $scope.editMode = !$scope.editMode;
  };

  $scope.editInjury = function() {
    $scope.toggleEditMode();
  };
}]);
