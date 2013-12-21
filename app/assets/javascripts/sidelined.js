sidelinedApp = angular.module('sidelinedApp', ['ngResource', 'auth'])
.run(function(authService){
  authService.requestcurrentuser();
});
