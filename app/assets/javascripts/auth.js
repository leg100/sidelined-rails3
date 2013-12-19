// Based loosely around work by Witold Szczerba - https://github.com/witoldsz/angular-http-auth
angular.module('auth', ['ui.bootstrap'])
.factory('authService', ['$http', '$q', 'securityRetryQueue', '$location', '$log', '$modal', function($http, $q, queue, $location, $log, $dialog) {

  // redirect to the given url (defaults to '/')
  function redirect(url) {
    url = url || '/';
    $location.path(url);
  }

  // the public api of the service
  var service = {
    // get the first reason for needing a login
    getLoginReason: function() {
      return queue.retryReason();
    },
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
.controller('LoginStatusController', ['$scope', 'authService', function($scope, security) {
  $scope.isAuthenticated = security.isAuthenticated;
  $scope.$watch(function() {
    return security.currentuser;
  }, function(currentuser) {
    $scope.username = currentuser;
  });
  $scope.logout = security.logout;
}])
.controller('LoginModalController', ['$scope', 'authService', '$modal', '$log', 'securityRetryQueue', function($scope, security, $modal, $log, queue) {

  $scope.open = function() {
    var modalInstance = $modal.open({
      templateUrl: '/templates/form.tmpl', 
      controller: 'LoginModalInstanceController'
    });
    modalInstance.result.then(function() {
      queue.retryAll();
    }, function() {
      queue.cancelAll();
      security.doRedirect();
    });
  }
}])
.controller('LoginModalInstanceController', ['$scope', '$modalInstance', 'authService', '$log', function($scope, $modalInstance, security, $log) {
  // The model for this form 
  $scope.user = {
    email: 'louisgarman@gmail.com',
    password: 'j843874q'
  };

  // Any error message from failing to login
  $scope.authError = null;

  // The reason that we are being asked to login - for instance because we tried to access something to which we are not authorized
  // We could do something diffent for each reason here but to keep it simple...
  $scope.authReason = null;
  if ( security.getLoginReason() ) {
    $scope.authReason = ( security.isAuthenticated() ) ?
      'not authorized' :
      'not authenticated';
  }

  // Attempt to authenticate the user specified in the form's model
  $scope.login = function() {
    // Clear any previous security errors
    $scope.authError = null;

    // Try to login
    security.login($scope.user.email, $scope.user.password).then(function(response) {
      $log.info(response);
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
.directive('loginToolbar', ['authService', function(authService) {
  var directive = {
    templateUrl: '/templates/login.tmpl',
    restrict: 'E',
    replace: true,
    scope: true,
    link: function($scope, $element, $attrs, $controller) {
      $scope.isAuthenticated = authService.isAuthenticated;
      $scope.login = authService.showLogin();
      $scope.logout = authService.logout;
      $scope.$watch(function() {
        return authService.currentUser;
      }, function(currentUser) {
        $scope.currentUser = currentUser;
      });
    }
  };
  return directive;
}])
.controller('LoginCtrl', ['$scope', 'authService', '$log', function($scope, authService, $log) {
  // The model for this form
  $scope.user = {};

  // Any error message from failing to login
  $scope.authError = null;

  // The reason that we are being asked to login - for instance because we tried to access something to which we are not authorized
  // We could do something diffent for each reason here but to keep it simple...
  authService.requestcurrentuser().then(function(userInfo) {
    $scope.status = userInfo;
  });
}])
// This is a generic retry queue for security failures.  Each item is expected to expose two functions: retry and cancel.
.factory('securityRetryQueue', ['$q', '$log', function($q, $log) {
  var retryQueue = [];
  var service = {
    // The security service puts its own handler in here!
    onItemAddedCallbacks: [],
    
    hasMore: function() {
      return retryQueue.length > 0;
    },
    push: function(retryItem) {
      retryQueue.push(retryItem);
      // Call all the onItemAdded callbacks
      angular.forEach(service.onItemAddedCallbacks, function(cb) {
        try {
          cb(retryItem);
        } catch(e) {
          $log.error('securityRetryQueue.push(retryItem): callback threw an error' + e);
        }
      });
    },
    pushRetryFn: function(reason, retryFn) {
      // The reason parameter is optional
      if ( arguments.length === 1) {
        retryFn = reason;
        reason = undefined;
      }

      // The deferred object that will be resolved or rejected by calling retry or cancel
      var deferred = $q.defer();
      var retryItem = {
        reason: reason,
        retry: function() {
          // Wrap the result of the retryFn into a promise if it is not already
          $q.when(retryFn()).then(function(value) {
            // If it was successful then resolve our deferred
            deferred.resolve(value);
          }, function(value) {
            // Othewise reject it
            deferred.reject(value);
          });
        },
        cancel: function() {
          // Give up on retrying and reject our deferred
          deferred.reject();
        }
      };
      service.push(retryItem);
      return deferred.promise;
    },
    retryReason: function() {
      return service.hasMore() && retryQueue[0].reason;
    },
    cancelAll: function() {
      while(service.hasMore()) {
        retryQueue.shift().cancel();
      }
    },
    retryAll: function() {
      while(service.hasMore()) {
        retryQueue.shift().retry();
      }
    }
  };
  return service;
}]);
