// Based loosely around work by Witold Szczerba - https://github.com/witoldsz/angular-http-auth
angular.module('auth', ['ui.bootstrap'])
.factory('Session', ['$http', '$q', '$location', '$log', '$modal', function($http, $q, $location, $log, $dialog) {

  // redirect to the given url (defaults to '/')
  function redirect(url) {
    url = url || '/';
    $location.path(url);
  }

  // the public api of the service
  var service = {
    // get the first reason for needing a login
    //
    //getLoginReason: function() {
    //
    //return queue.retryReason();
    //
    //},
    // attempt to authenticate a user by the given email and password
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
    logout: function(redirectto) {
      $http.post('/logout').then(function() {
        service.currentuser = null;
        redirect(redirectto);
      });
    },
    doRedirect: function(url) {
      redirect(url);
    },
    // ask the backend to see if a user is already authenticated - this may be from a previous session.
    requestcurrentuser: function() {
      if ( service.isAuthenticated() ) {
        console.log("not making http request to /current_user");
        return $q.when(service.currentuser);
      } else {
        return $http.get('/current-user').then(function(response) {
          console.log("making http request to /current_user");
          service.currentuser = response.data.username;
          return service.currentuser;
        });
      }
    },
    // information about the current user
    currentuser: null,

    // is the current user authenticated?
    isAuthenticated: function(){
      return !!service.currentuser;
    },

    // is the current user an adminstrator?
    isadmin: function() {
      return !!(service.currentuser && service.currentuser.admin);
    }
  };

  return service;
}])
.controller('LoginStatusController', ['$scope', 'Session', function($scope, security) {
  $scope.isAuthenticated = security.isAuthenticated;
  $scope.$watch(function() {
    return security.currentuser;
  }, function(currentuser) {
    $scope.username = currentuser;
  });
  $scope.logout = security.logout;
}])
.controller('LoginModalController', ['$scope', 'Session', '$modal', 'authService', '$log', function($scope, security, $modal, authService, $log) {
 
  $scope.open = function() {
    var modalInstance = $modal.open({
      templateUrl: '/templates/auth/form.tmpl', 
      controller: 'LoginModalInstanceController'
    });
    modalInstance.result.then(function() {
      authService.loginConfirmed();
    }, function() {
      //queue.cancelAll();
      security.doRedirect();
    });
  }

  $scope.$on('event:auth-loginRequired', function() {
    $scope.open();
  });
}])
.controller('LoginModalInstanceController', ['$scope', '$modalInstance', 'Session', '$log', 'authService', function($scope, $modalInstance, security, $log, authService) {
  // The model for this form 
  $scope.user = {
    email: 'louisgarman@gmail.com',
    password: 'j843874q'
  };

  // Any error message from failing to login
  $scope.authError = null;

  // The reason that we are being asked to login - for instance because we tried to access something to which we are not authorized
  // We could do something diffent for each reason here but to keep it simple...
  $scope.authReason = 'not authenticated';

  // Attempt to authenticate the user specified in the form's model
  $scope.login = function() {
    // Clear any previous security errors
    $scope.authError = null;

    // Try to login
    security.login($scope.user.email, $scope.user.password).then(function(response) {
      var currentuser = security.requirecurrentuser;
      $log.info(currentuser);
      $modalInstance.close();
    }, function(err) {
      $scope.authError = err;
    });
  };

  $scope.clear = function() {
    $scope.user = {};
  };
 
  $scope.cancel = function() {
    $log.info("cancelling");
    $modalInstance.dismiss('cancel');
    security.doRedirect();
  };
}])
// The loginToolbar directive is a reusable widget that can show login or logout buttons
// and information the current authenticated user
.directive('loginToolbar', ['Session', function(Session) {
  var directive = {
    templateUrl: '/templates/auth/login.tmpl',
    restrict: 'E',
    replace: true,
    scope: true,
    link: function($scope, $element, $attrs, $controller) {
      $scope.isAuthenticated = Session.isAuthenticated;
      $scope.login = Session.showLogin();
      $scope.logout = Session.logout;
      $scope.$watch(function() {
        return Session.currentUser;
      }, function(currentUser) {
        $scope.currentUser = currentUser;
      });
    }
  };
  return directive;
}])
.controller('LoginCtrl', ['$scope', 'Session', '$log', function($scope, Session, $log) {
  // The model for this form
  $scope.user = {};

  // Any error message from failing to login
  $scope.authError = null;

  // The reason that we are being asked to login - for instance because we tried to access something to which we are not authorized
  // We could do something diffent for each reason here but to keep it simple...
  Session.requestcurrentuser().then(function(userInfo) {
    $scope.status = userInfo;
  });
}]);
