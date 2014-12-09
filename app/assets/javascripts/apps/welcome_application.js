// http://angular-ui.github.io/bootstrap/#/typeahead
var app = angular

// Сreate our angular app and inject dependencies
// =============================================================================
.module('welcomeApplication', ['ui.bootstrap', 'ui.router', 'templates'])

// Сonfiguring our routes
// =============================================================================
.config(function($stateProvider, $urlRouterProvider, $httpProvider) {

  // Set csrf-token
  $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');

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


// Welcome Form controller
// =============================================================================
.controller('welcomeApplicationController', function($scope, $http, $state) {


  // Error container
  $scope.errors = {};

  $scope.empty_family = {
    author: '',
    father: '',
    mother: '',
    brothers: [],
    sisters: [],
    sons: [],
    daughters: [],
    wife: '',
    hasband: ''
  }


  // Data container
  $scope.family = {
    author: '',
    father: '',
    mother: '',
    brothers: [],
    sisters: [],
    sons: [],
    daughters: [],
    wife: '',
    hasband: ''
  }


  // Get names for autocomplete
  $scope.getNames = function(term, sex_id){
    return $http.get('/autocomplete/names', {
      params: {
        term: term,
        sex_id:  (typeof sex_id !== 'undefined' ? sex_id : null)
      }
    }).then(function(response){
      return response.data;
    });
  };



  // Update model
  $scope.changeName = function(modelName, name){
    //clear error on server validation
    console.log("Change name "+ Date.now() + name );
    $scope.error = '';

    // eval('$scope.family.'+modelName+'=null;');


    removeDataFormGraph(modelName);
    if (modelName == 'author'){
      $scope.family = $scope.empty_family;
      removeAllDataFormGraph();
    }else{
      removeDataFormGraph(modelName);
    }

  };



  $scope.onSelectName = function(model, modelName){
    // $scope.author = model;
    eval('$scope.family'+modelName+'= model;');
    pushDataToGraph(modelName, model);
  }


  $scope.changeMultipleName = function(modelName, index){
    removeMultipleDataFormGraph(modelName, index);
    eval('$scope.family.'+modelName+'[index] = "";');
  };


  $scope.onMultipleSelectName = function(model, modelName, index){
    eval('$scope.family.'+modelName+'[index] = model;');
    pushMultipleDataToGraph(modelName, model, index);
  }


  // Add or remove member
  $scope.addMember = function(modelName) {
    // $scope.family.brothers.push("");
    eval('$scope.family.'+modelName+'.push("") ')
  };


  $scope.removeMember = function(index, modelName) {
    // $scope.family.brothers.splice(index, 1);
    removeMultipleDataFormGraph(modelName, index);
    eval('$scope.family.'+modelName+'.splice('+index+', 1);');
  };


  // Validation
  $scope.isNameValid = function(model){
    try {
      return model.hasOwnProperty('name');
    }catch(e){
      return false;
    }
  }


  $scope.isAllNamesValid = function(models){
    if (models.length > 0){
      var name_vals = [];
      angular.forEach(models, function(model) {
        console.log("Each names valid" + $scope.isNameValid(model) );
        name_vals.push( $scope.isNameValid(model) )
      })
      var result = name_vals.indexOf(false) > -1 ? false : true;
      name_vals = [];
      return result;
    }else{
      return true;
    }
  }



  $scope.isAuthorValid = function(){
    try {
      console.log("Validate author name");
      return $scope.family.author.hasOwnProperty('name');
    }catch(e){
      return false;
    }
  }



  $scope.isFatherValid = function(){
    try {
      return $scope.family.father.hasOwnProperty('name');
    }catch(e){
      return false;
    }
  }


  $scope.isMotherValid = function(){
    try {
      return $scope.family.mother.hasOwnProperty('name');
    }catch(e){
      return false;
    }
  }



  // State validation with redirect
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


      // brothers -> mother
      if ($state.current.name == 'form.brothers'){
        if (!$scope.isMotherValid()){
          $state.go('form.mother');
        }
      }

      // sisters -> mother
      if ($state.current.name == 'form.sisters'){
        if (!$scope.isMotherValid()){
          $state.go('form.mother');
        }
      }

      // sons -> mother
      if ($state.current.name == 'form.sons'){
        if (!$scope.isMotherValid()){
          $state.go('form.mother');
        }
      }


      // sons -> mother
      if ($state.current.name == 'form.daughters'){
        if (!$scope.isMotherValid()){
          $state.go('form.mother');
        }
      }


      // wife -> mother
      if ($state.current.name == 'form.wife'){
        if (!$scope.isMotherValid()){
          $state.go('form.mother');
        }
      }


      // husband -> mother
      if ($state.current.name == 'form.husband'){
        if (!$scope.isMotherValid()){
          $state.go('form.mother');
        }
      }

      // email -> mother
      if ($state.current.name == 'form.email'){
        if (!$scope.isMotherValid()){
          $state.go('form.mother');
        }
      }

  });



  $scope.hasWife = function(){
    try {
      return $scope.family.author.sex_id == 1;
    }catch(e){
      return false;
    }
  }

  $scope.hasHusband = function(){
    try {
      return $scope.family.author.sex_id == 0;
    }catch(e){
      return false;
    }
  }



  $scope.submitData = function(){
    $scope.loading = true;
    $http({
      method : 'POST',
      url : '/register',
      data : {family: $scope.family}
    }).success(function(data){
      $scope.loading = false;
      if (data.errors) {
        $scope.error = "Email "+data.errors['email'];
      }else{
        window.location.href = '/home';
      }
    }).error(function(data){
      $scope.loading = false;
      alert('Неизвестная ошибка ;(');
    });
  };

});



// Directives
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
