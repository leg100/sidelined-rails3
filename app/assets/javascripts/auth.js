// Based loosely around work by Witold Szczerba - https://github.com/witoldsz/angular-http-auth
angular.module('auth', [])
.factory('authService', ['$http', '$q', '$location', '$log', function($http, $q, $location, $log) {

  // redirect to the given url (defaults to '/')
  function redirect(url) {
    url = url || '/';
    $location.path(url);
  }

  // the public api of the service
  var service = {

    // ask the backend to see if a user is already authenticated - this may be from a previous session.
    requestcurrentuser: function() {
      if ( service.isauthenticated() ) {
        console.log("not making http request to /current_user");
        return $q.when(service.currentuser);
      } else {
        return $http.get('/current-user').then(function(response) {
          console.log("making http request to /current_user");
          console.dir("response: " + response.data.username);
          service.currentuser = response.data;
          return service.currentuser;
        });
      }
    },

    // information about the current user
    currentuser: null,

    // is the current user authenticated?
    isauthenticated: function(){
      return !!service.currentuser;
    },

    // is the current user an adminstrator?
    isadmin: function() {
      return !!(service.currentuser && service.currentuser.admin);
    }
  };

  return service;
}])
.controller('LoginCtrl', ['$scope', 'authService', '$log', function($scope, authService, $log) {
  // The model for this form
  $scope.user = {};

  // Any error message from failing to login
  $scope.authError = null;

  // The reason that we are being asked to login - for instance because we tried to access something to which we are not authorized
  // We could do something diffent for each reason here but to keep it simple...
  authService.requestcurrentuser().then(function(userInfo) {
    $log.info(userInfo);
    $scope.status = userInfo;
  });
}]);
