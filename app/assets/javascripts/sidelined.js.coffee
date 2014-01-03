sidelinedApp = angular.module('sidelinedApp', ['ui.router', 'auth', 'injuries', 'alerts', 'http-auth-interceptor'])
.config(($locationProvider, $stateProvider, $urlRouterProvider) ->
  $locationProvider.html5Mode(true).hashPrefix('!')
  $urlRouterProvider.otherwise("/injuries")
  $stateProvider
    .state("injuries", {
      url: "/injuries{trailing:\/?}",
      templateUrl: "/templates/pages/all.tmpl",
      controller: 'InjuryListCtrl',
      resolve: {
        action: (() ->  
          'Add'
        ),
        injuries: (Injury) ->
          Injury.query({_type: 'Injury'})
      }
    })
    .state("injury", {
      url: "/injuries/:id",
      templateUrl: "/templates/pages/injury.tmpl",
      controller: (($scope, injury, action) ->
        $scope.injury = injury
        $scope.action = action
      ),
      resolve: {
        action: (() ->  
          'Update'
        ),
        injury: (Injury, $stateParams) ->
          Injury.get($stateParams.id)
      }
    })
).run((Session) ->
  Session.requestCurrentUser()
)
