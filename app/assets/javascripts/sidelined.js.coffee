sidelinedApp = angular.module('sidelinedApp', ['auth', 'events'])
.run((authService) -> 
  authService.requestcurrentuser()
  )
