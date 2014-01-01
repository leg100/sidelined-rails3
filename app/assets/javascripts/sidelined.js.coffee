sidelinedApp = angular.module('sidelinedApp', ['ngRoute', 'auth', 'events', 'revisions', 'alerts', 'http-auth-interceptor'])
.config(($routeProvider) ->
  $routeProvider
    .when('/all/:page', {
      templateUrl: '/templates/events/all.tmpl',
      controller: 'EventListCtrl',
      resolve: {
        eventItems: ($route, EventService) ->
          EventService.query({page: $route.current.params.page}).then((resp) -> resp)
      }
    })
    .when('/events', {
      templateUrl: '/templates/events/all.tmpl',
      controller: 'EventListCtrl'
    })
    .when('/revisions', {
      templateUrl: '/templates/events/revisions.tmpl',
      controller: 'RevisionListCtrl'
    })
    .when('/injuries', {
      templateUrl: '/templates/events/all.tmpl',
      controller: 'EventListCtrl'
      resolve: {
        injuryItems: ($route, Injury) ->
          Injury.query({page: $route.current.params.page}).then((resp) -> resp)
      }
    })
    .otherwise({redirectTo: '/all/1'})
).config(($locationProvider) ->
  $locationProvider.html5Mode(true).hashPrefix('!')
).run((Session) ->
  Session.requestCurrentUser()
)
