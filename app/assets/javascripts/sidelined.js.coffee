sidelinedApp = angular.module('sidelinedApp', ['auth', 'events', 'alerts', 'http-auth-interceptor'])
.run((Session) -> 
  Session.requestcurrentuser()
)
