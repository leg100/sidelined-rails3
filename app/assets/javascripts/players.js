angular.module('players', ['rails'])
.factory('Player', ['railsResourceFactory', function(railsResourceFactory) {
  return railsResourceFactory({
    url: '/api/players',
    name: 'player'
  });
}]);
