sidelinedApp = angular.module('sidelinedApp', ['ngResource', 'auth'])
.run((authService) -> 
  authService.requestcurrentuser()
  )

