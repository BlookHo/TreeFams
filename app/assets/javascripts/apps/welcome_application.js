// http://www.angularcode.com/how-to-create-a-facebook-style-autocomplete-using-angularjs/
// http://angular-ui.github.io/bootstrap/#/typeahead
var app = angular

// create our angular app and inject dependencies
// =============================================================================
.module('welcomeApplication', ['ui.bootstrap', 'ui.router', 'templates'])

// configuring our routes
// =============================================================================
.config(function($stateProvider, $urlRouterProvider) {

  $stateProvider
    // route to show our basic form (/form)
    .state('form', {
      url: '/form',
      templateUrl: 'welcome-form.html',
      controller: 'welcomeApplicationController'
    })

    // nested states
    // each of these sections will have their own view
    // url will be nested (/form/profile)
    .state('form.author', {
    	url: '/author',
    	templateUrl: 'welcome-author.html'
    })

    .state('form.father', {
      url: '/father',
      templateUrl: 'welcome-father.html'
    })

    .state('form.mother', {
      url: '/mother',
      templateUrl: 'welcome-mother.html'
    })

    .state('form.brothers', {
    	url: '/form.brothers',
    	templateUrl: 'welcome-brothers.html'
    })

    .state('form.sisters', {
      url: '/form.sisters',
      templateUrl: 'welcome-sisters.html'
    })

    .state('form.sons', {
      url: '/form.sons',
      templateUrl: 'welcome-sons.html'
    })


    .state('form.daughters', {
      url: '/form.daughters',
      templateUrl: 'welcome-daughters.html'
    })

    .state('form.wife', {
      url: '/form.wife',
      templateUrl: 'welcome-wife.html'
    })


    .state('form.husband', {
      url: '/form.husband',
      templateUrl: 'welcome-husband.html'
    })

    .state('form.email', {
      url: '/form.email',
      templateUrl: 'welcome-email.html'
    })

    // catch all route
    // send users to the root form page
    $urlRouterProvider.otherwise('/form/author');
})


// our controller for the form
// =============================================================================
.controller('welcomeApplicationController', function($scope, $http) {

  $scope.getNames = function(val){
    return $http.get('/autocomplete/names', {
      params: {
        term: val
      }
    }).then(function(response){
      // return response.data.results.map(function(item){
      //   return item.formatted_address;
      // });
      return response.data;
    });
  };


  // $scope.changeName = function(model){
  //   console.log('changeName'+model);
  // };


  $scope.onNameSelect = function(item, model, label){
    $scope.author = model;
  }


  $scope.isAuthorValid = function(){
    return true;
  }



  // we will store all of our form data in this object
  // $scope.family = {
  //   author:{},
  //   mother:{},
  //   father:{},
  //   wife:{},
  //   husband:{},
  //   email:{},
  //   brothers:[],
  //   sisters:[],
  //   sons:[],
  //   daughters:[]
  // };


  // Оbserver - trigger graph
  // $scope.$watch('family', function(data){
  //   pushDataFromAngular(data);
  // }, true);


  // $scope.$watch('family.brothers', function(data){
  //   // pushDataFromAngular(data);
  // }, true)


  // Brothers
  $scope.addBrother = function() {
    $scope.family.brothers.push({});
  };

  $scope.removeBrother = function(index) {
    $scope.family.brothers.splice(index, 1);
  };

  // Sisters
  $scope.addSister = function() {
    $scope.family.sisters.push({});
  };

  $scope.removeSister = function(index) {
    $scope.family.sisters.splice(index, 1);
  };

  // Sons
  $scope.addSon = function() {
    $scope.family.sons.push({});
  };

  $scope.removeSon = function(index) {
    $scope.family.sons.splice(index, 1);
  };

  // Daughters
  $scope.addDaughter = function() {
    $scope.family.daughters.push({});
  };

  $scope.removeDaughter = function(index) {
    $scope.family.daughters.splice(index, 1);
  };


  $scope.hasWife = function(){
    return $scope.family.author.originalObject.sex_id == 1;
  }

  $scope.hasHusband = function(){
    return $scope.family.author.originalObject.sex_id == 0;
  }


});
