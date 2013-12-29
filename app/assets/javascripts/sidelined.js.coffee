sidelinedApp = angular.module('sidelinedApp', ['auth', 'events', 'alerts'])
.run((authService) -> 
  authService.requestcurrentuser()
  )
