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
          'add'
        ),
        injuries: (Injury) ->
          Injury.query()
      }
    })
    .state("injury", {
      url: "/injuries/:id",
      templateUrl: "/templates/pages/injury.tmpl",
      controller: (($scope, $state, action, injury) ->
        $scope.action = action
        $scope.$state = $state
        $scope.$watch('$state.$current.locals.globals.injury', (injury) ->
          $scope.injury = injury
          console.log($scope.injury)
        )
        $scope.revision_templates = {
          create: '/templates/revisions/create.tmpl',
          update: '/templates/revisions/update.tmpl'
        };
      ),
      resolve: {
        action: (() ->  
          'update'
        ),
        injury: (Injury, $stateParams) ->
          Injury.get($stateParams.id)
      }
    })
).run((Session) ->
  Session.requestCurrentUser()
)
