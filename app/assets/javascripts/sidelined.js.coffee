sidelinedApp = angular.module('sidelinedApp', ['ngRoute', 'auth', 'events', 'alerts', 'http-auth-interceptor'])
.run((Session) -> 
  Session.requestCurrentUser()
).config(($routeProvider) ->
  $routeProvider
    .when('/', {
      templateUrl: 'templates/events/all.tmpl',
      controller: 'EventListCtrl'
    })
    .when('/injuries', {
      templateUrl: 'templates/events/all.tmpl',
      controller: 'EventListCtrl'
    })
    .otherwise({redirectTo: '/'})
)
