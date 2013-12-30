// Based loosely around work by Witold Szczerba - https://github.com/witoldsz/angular-http-auth
angular.module('auth', ['ui.bootstrap'])
.factory('Session', ['$http', '$q', '$location', function($http, $q, $location) {

  function redirect(url) {
    url = url || '/';
    $location.path(url);
  }

  // the public api of the service
  var service = {
    login: function(email, password) {
      $http.defaults.headers.post = { 
        'Accept' : 'application/json',
        'Content-Type' : 'application/json' };

      return $http.post('/login', {user: {login: email, password: password}})
        .then( function(resp) {
          if (resp.data.success) {
            service.currentuser = resp.data.data.username;
            return resp.data.data.username;
          } else {
            // reject promise with error message
            return $q.reject(resp.data.info);
          }
        }, function(resp) {
          return $q.reject(resp.data.info);
        });
    },
    // logout the current user and redirect
    logout: function(redirectTo) {
      $http.post('/logout').then(function() {
        service.currentuser = null;
        redirect(redirectTo);
      });
    },
    doRedirect: function(url) {
      redirect(url);
    },
    // ask the backend to see if a user is already authenticated - this may be from a previous session.
    requestCurrentUser: function() {
      if ( service.isAuthenticated() ) {
        return $q.when(service.currentUser);
      } else {
        return $http.get('/current-user').then(function(response) {
          service.currentUser = response.data.username;
          return service.currentUser;
        });
      }
    },
    currentUser: null,

    isAuthenticated: function(){
      return !!service.currentUser;
    }
  };

  return service;
}])
.controller('LoginStatusController', ['$scope', 'Session', function($scope, security) {
  $scope.isAuthenticated = security.isAuthenticated;
  $scope.$watch(function() {
    return security.currentUser;
  }, function(currentUser) {
    $scope.username = currentUser;
  });
  $scope.logout = security.logout;
}])
.controller('LoginModalController', ['$scope', 'Session', '$modal', 'authService', function($scope, security, $modal, authService) {
 
  $scope.open = function() {
    var modalInstance = $modal.open({
      templateUrl: '/templates/auth/form.tmpl', 
      controller: 'LoginModalInstanceController'
    });
    modalInstance.result.then(function() {
      authService.loginConfirmed();
    }, function() {
      security.doRedirect();
    });
  }

  $scope.$on('event:auth-loginRequired', function() {
    $scope.open();
  });
}])
.controller('LoginModalInstanceController', ['$scope', '$modalInstance', 'Session', function($scope, $modalInstance, security) {
  $scope.user = {
    email: 'louisgarman@gmail.com',
    password: 'j843874q'
  };

  $scope.authError = null;
  $scope.authReason = 'not authenticated';

  $scope.login = function() {
    // Clear any previous security errors
    $scope.authError = null;

    security.login($scope.user.email, $scope.user.password).then(function(response) {
      security.requireCurrentUser;
      $modalInstance.close();
    }, function(err) {
      $scope.authError = err;
    });
  };

  $scope.clear = function() {
    $scope.user = {};
  };
 
  $scope.cancel = function() {
    $modalInstance.dismiss('cancel');
    security.doRedirect();
  };
}]);
