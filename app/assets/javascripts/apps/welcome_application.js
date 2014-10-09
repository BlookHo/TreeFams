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
.controller('welcomeApplicationController', function($scope, $http, $state) {


  $scope.$on('$viewContentLoaded', function () {
      // father -> author
      if ($state.current.name == 'form.father'){
        if (!$scope.isAuthorValid()){
          $state.go('form.author');
        }
      }

      // mother -> father
      if ($state.current.name == 'form.mother'){
        if (!$scope.isFatherValid()){
          $state.go('form.father');
        }
      }

  });

  $scope.getNames = function(val){
    return $http.get('/autocomplete/names', {
      params: {
        term: val
      }
    }).then(function(response){
      return response.data;
    });
  };


  $scope.changeName = function(modelName){
    //$scope.author = '';
    eval('$scope.'+modelName+'="";');
  };


  $scope.onSelectName = function(model, modelName){
    //$scope.author = model;
    eval('$scope.'+modelName+'=model;');
  }


  $scope.isAuthorValid = function(){
    if ($scope.hasOwnProperty('author')){
      return $scope.author.hasOwnProperty('name');
    }else{
      return false;
    }
  }



  $scope.isFatherValid = function(){
    if ($scope.hasOwnProperty('father')){
      return $scope.father.hasOwnProperty('name');
    }else{
      return false;
    }
  }


  $scope.isMotherValid = function(){
    if ($scope.hasOwnProperty('mother')){
      return $scope.mother.hasOwnProperty('name');
    }else{
      return false;
    }
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


app.directive('autoFocus', function($timeout) {
    return {
        restrict: 'AC',
        link: function(_scope, _element) {
            $timeout(function(){
                _element[0].focus();
            }, 0);
        }
    };
});
