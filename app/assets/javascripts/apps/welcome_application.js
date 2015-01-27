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
    url: '/brothers',
    templateUrl: 'welcome-brothers.html'
  })

  .state('form.sisters', {
    url: '/sisters',
    templateUrl: 'welcome-sisters.html'
  })

  .state('form.sons', {
    url: '/sons',
    templateUrl: 'welcome-sons.html'
  })


  .state('form.daughters', {
    url: '/daughters',
    templateUrl: 'welcome-daughters.html'
  })

  .state('form.wife', {
    url: '/wife',
    templateUrl: 'welcome-wife.html'
  })


  .state('form.husband', {
    url: '/husband',
    templateUrl: 'welcome-husband.html'
  })

  .state('form.father-father', {
    url: '/father-father',
    templateUrl: 'welcome-father-father.html'
  })


  .state('form.father-mother', {
    url: '/father-mother',
    templateUrl: 'welcome-father-mother.html'
  })


  .state('form.mother-father', {
    url: '/mother-father',
    templateUrl: 'welcome-mother-father.html'
  })


  .state('form.mother-mother', {
    url: '/mother-mother',
    templateUrl: 'welcome-mother-mother.html'
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



  // Start Drag form
  $('#start form').draggable({ handle: "#dragger" });


  // Error container
  // $scope.errors = {};

  $scope.empty_family = {
    author: '',
    father: '',
    mother: '',
    brothers: [],
    sisters: [],
    sons: [],
    daughters: [],
    wife: '',
    husband: '',
    father_father:'',
    father_mother:'',
    mother_father:'',
    mother_mother:''
  }



  // Required fields
  $scope.required = {
    author: true,
    father: true,
    mother: true,
    brothers: false,
    sisters: false,
    sons: false,
    daughters: false,
    wife: false,
    husband: false,
    father_father:false,
    father_mother:false,
    mother_father:false,
    mother_mother:false
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
    husband: '',
    father_father:'',
    father_mother:'',
    mother_father:'',
    mother_mother:''
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
    // removeDataFormGraph(modelName);
    if (modelName == 'author'){
      $scope.resetFamily();
      // removeAllDataFormGraph();
    }else{
      // removeDataFormGraph(modelName);
    }
    eval('$scope.family.'+modelName+'={name: name};');
  };



  $scope.onSelectName = function(model, modelName){
    console.log("onSelectName "+ Date.now() );
    eval('$scope.family'+modelName+'= model;');
    // pushDataToGraph(modelName, model);
  }



  $scope.changeMemberName = function(modelName, index, name){
    // По всей видимости баг в angular или в ui-bootstrap
    // который ломает выпадающий список при изменении данных на ng-change
    // поэтому чистим возможный аттрибуты таким образом
    eval("delete $scope.family."+modelName+"[index]['sex_id']");
    eval("delete $scope.family."+modelName+"[index]['id']");
    eval("delete $scope.family."+modelName+"[index]['new']");
    eval("delete $scope.family."+modelName+"[index]['search_name_id']");
    eval("delete $scope.family."+modelName+"[index]['parent_name']");
    // removeMultipleDataFormGraph(modelName, index);
  }




  // $scope.changeMultipleName = function(modelName, index, name){
  //   console.log("changeMultipleName "+ Date.now());
  //   console.log(name);
  //   removeMultipleDataFormGraph(modelName, index);
  //   eval('$scope.family.'+modelName+'[index] = {name: name};');
  // };



  $scope.onMultipleSelectName = function(model, modelName, index){
    console.log("onMultipleSelectName "+ Date.now() );
    eval('$scope.family.'+modelName+'[index] = model;');
    // pushMultipleDataToGraph(modelName, model, index);
  }



  // Add or remove member
  $scope.addMember = function(modelName) {
    console.log("addMember "+ Date.now() );
    eval('$scope.family.'+modelName+'.push({name:""}) ');
    setTimeout(function(){$("input:text:visible:last").focus();}, 100);

  };


  $scope.removeMember = function(index, modelName) {
    console.log("removeMember "+ Date.now() );
    // removeMultipleDataFormGraph(modelName, index);
    eval('$scope.family.'+modelName+'.splice('+index+', 1);');
  };


  $scope.addNameDescription = function(modeName, data, index){
    if (typeof index != 'undefined'){
      eval('$scope.family.'+modelName+'[index].name_description = data;')
    }else{
      eval('$scope.family.'+modelName+'.name_description = data;')
    }
  }



  $scope.resetFamily = function(){
    $scope.family.author = '';
    $scope.family.father = '';
    $scope.family.mother = '';
    $scope.family.brothers = [];
    $scope.family.sisters = [];
    $scope.family.sons = [];
    $scope.family.daughters = [];
    $scope.family.wife = '';
    $scope.family.husband = '';
    $scope.family.father_father = '';
    $scope.family.father_mother = '';
    $scope.family.mother_father = '';
    $scope.family.mother_mother = '';
  }





  /* Validation
  ------------------------------------------ */
  // Single name fields
  $scope.validateName = function(modelName){
    // if ( $scope.stepIsRequired(modelName) && $scope.isNameValid(modelName) ){
    if ( $scope.isNameValid(modelName) ){
      // push only if name exist
      if (!$scope.isNameBlank(modelName)){
        // pushDataToGraph(modelName, eval('$scope.family.'+modelName+';') );
      }

      $scope.goToNextStep();
    }
  }



  // Multiple name fields validation
  $scope.validateNames = function(modelName){
    var members = eval("$scope.family."+ modelName);
    var no_errors;
    if (members.length > 0 ){
      angular.forEach( eval("$scope.family."+ modelName), function(value, key) {

        // If name selected from list
        if ( value.hasOwnProperty('name') && value.hasOwnProperty('sex_id') ){
          no_errors = true;
          // pushMultipleDataToGraph(modelName, value, key);
          return true;
        }else{
          // Validate blank name
          if ( $scope.isNameBlank(modelName, key) ){
            var name_error = {name: "", error: "Нужно указать имя"};
            eval('$scope.family.'+modelName+'[key] = name_error;');
            no_errors = false;
            return false;
          }

          // if name not selected from list
          $http.get('/names/find', {
            params: {term: value.name}
          }).success(function(response){
            eval('$scope.family.'+modelName+'[key] = response;');
            $scope.validateNames(modelName); // reRun names validation
            return true;
          }).error(function(){
            var name_error = {name: value.name, new: true, error: "Вы указали имя, которого нет у нас в базе. Вы уверены, что не ошиблись при вводе?"}
            eval('$scope.family.'+modelName+'[key] = name_error;');
            no_errors = false;
            return false;
          })
        }
      }) // each

      // // if memebrs has no error
      if (no_errors){
        $scope.goToNextStep();
      }
    }else{
      $scope.goToNextStep();
    }
  }



  /* Helpers
  ------------------------------------------ */
  // Обязательное имя?
  $scope.stepIsRequired = function(modelName){
    return eval('$scope.required.'+modelName+';');
  }




  // Пустое имя?
  $scope.isNameBlank = function(modelName, index){
    if (typeof index != 'undefined'){
        if ( eval('$scope.family.'+modelName+'[index].hasOwnProperty("name");') ){
          return eval('$scope.family.'+modelName+'[index].name.length == 0;');
        }else{
          return true;
        }
    }else{
      if ( eval('$scope.family.'+modelName+'.hasOwnProperty("name");') ){
        return eval('$scope.family.'+modelName+'.name.length == 0;');
      }else{
        // try grab raw input
        var rawName = eval('$scope.family.'+modelName);
        if (rawName.length == 0){
          return true;
        }else{
          eval('$scope.family.'+modelName+'.name='+rawName);
          return false;
        }

      }
    }
  }



  // Check name
  $scope.isNameValid = function(modelName){
    try {
      // If name selected from list
      var model = eval("$scope.family."+modelName+";");
      if ( model.hasOwnProperty('name') && model.hasOwnProperty('sex_id') ){
        return true;

      // if name not selected from list
      }else{

        // if name required
        if ( $scope.stepIsRequired(modelName) && $scope.isNameBlank(modelName)){
          var name_error = {name: "", error: "Нужно указать имя"};
          eval('$scope.family.'+modelName+' = name_error;');
          return false;
        }

        // alert( $scope.isNameBlank(modelName) );

        // if name required and name is blank
        // if ( $scope.stepIsRequired(modelName) && $scope.isNameBlank(modelName) ) {
        //   alert("1 cath!");
        //   var name_error = {name: "", error: "Нужно указать имя"};
        //   eval('$scope.family.'+modelName+' = name_error;');
        //   return false;
        // }
        //
        // if ( $scope.stepIsRequired(modelName) && !!$scope.isNameBlank(modelName) ){
        //   alert('2 Catch me!');
        // }




        // if name NOT required and blank
        if (!$scope.stepIsRequired(modelName) && $scope.isNameBlank(modelName) ){
          return true;
        }

        // otherwise
        $http.get('/names/find', {
          params: {term: model.name}
        }).success(function(response){
          eval('$scope.family.'+modelName+' = response;');
          $scope.validateName(modelName); // reRun name validation
          return true;
        }).error(function(){
          var name_error = {name: model.name, new: true, error: "Вы указали имя, которого нет у нас в базе. Вы уверены, что не ошиблись при вводе?", name_description: model.name_description}
          eval('$scope.family.'+modelName+' = name_error;');
          return false;
        })

      }
    }catch(e){
      return false;
    }
  }



  $scope.confirmNewName = function(modelName, sex_id, index){
    if (typeof index != 'undefined'){
      $scope.clearNameError(modelName, index);
      eval('$scope.family.'+modelName+'[index]["sex_id"] = sex_id;');
    }else{
      $scope.clearNameError(modelName);
      eval('$scope.family.'+modelName+'["sex_id"] = sex_id;');
    }
  }


  $scope.resetNewName = function(modelName, index){
    if (typeof index != 'undefined'){
      eval('$scope.family.'+modelName+'[index]={name: ""}');
    }else{
      eval('$scope.family.'+modelName+' = "";');
    }
  }


  $scope.clearNameError = function(modelName, index){
    if (typeof index != 'undefined'){
      eval('delete $scope.family.'+modelName+'[index]["error"];');
    }else{
      eval('delete $scope.family.'+modelName+'["error"];');
    }
  }



  // Check if model has errors
  $scope.hasError = function(modelName, index){
    if (typeof index != 'undefined'){
      return eval('$scope.family.'+modelName+'[index].hasOwnProperty("error");');
    }else{
      return eval('$scope.family.'+modelName+'.hasOwnProperty("error");');
    }
  }



  $scope.hasNewName = function(modelName, index){
    if (typeof index != 'undefined'){
      var result = ( (eval('$scope.family.'+modelName+'[index].hasOwnProperty("new")')) && !(eval('$scope.family.'+modelName+'[index].hasOwnProperty("sex_id")'))  );
    }else{
      var result = ( (eval('$scope.family.'+modelName+'.hasOwnProperty("new")')) && !(eval('$scope.family.'+modelName+'.hasOwnProperty("sex_id")'))  );
    }
    return result;
  }






  // State validation with redirect
  $scope.$on('$viewContentLoaded', function () {
    $("input:text:visible:last").focus();
  });

  /*
  $scope.$on('$viewContentLoaded', function () {

    // father -> author
    // проверяем пред шаг
    if ($state.current.name == 'form.father'){
      if (!$scope.isNameValid('author')){
        $state.go('form.author');
      }
    }

    // mother -> father
    if ($state.current.name == 'form.mother'){
      if (!$scope.isNameValid('father')){
        $state.go('form.father');
      }
    }


    // brothers -> mother
    if ($state.current.name == 'form.brothers'){
      if (!$scope.isNameValid('mother')){
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
  */



  // Redirect to next state from current
  $scope.goToNextStep = function(){
    // author -> father
    if ($state.current.name == 'form.author'){
      $state.go('form.father');
    }


    // father -> mother
    if ($state.current.name == 'form.father'){
      $state.go('form.mother');
    }


    // mother -> brothers
    if ($state.current.name == 'form.mother'){
      $state.go('form.brothers');
    }


    // brothers -> sisters
    if ($state.current.name == 'form.brothers'){
      $state.go('form.sisters');
    }


    // sisters -> sons
    if ($state.current.name == 'form.sisters'){
      $state.go('form.sons');
    }


    // sons -> daughters
    if ($state.current.name == 'form.sons'){
      $state.go('form.daughters');
    }


    // daughters -> wife || husband
    if ($state.current.name == 'form.daughters'){
      if ($scope.family.author.sex_id == 0){
        $state.go('form.husband');
      }else{
        $state.go('form.wife');
      }
    }



    // wife || husband -> father.father
    if (($state.current.name == 'form.husband') || ($state.current.name == 'form.wife')){
      $state.go('form.father-father');
    }


    // father.father -> father.mother
    if ($state.current.name == 'form.father-father'){
      $state.go('form.father-mother');
    }


    // father.mother -> mother.father
    if ($state.current.name == 'form.father-mother'){
      $state.go('form.mother-father');
    }


    // mother.father -> mother.mother
    if ($state.current.name == 'form.mother-father'){
      $state.go('form.mother-mother');
    }


    // mother.mother-> email
    if ($state.current.name == 'form.mother-mother'){
      $state.go('form.email');
    }


  }




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
        window.location.href = data.redirect;
      }
    }).error(function(data){
      $scope.loading = false;
      alert('Неизвестная ошибка ;(');
    });
  };

});





// app.directive('autoFocus', function($timeout) {
//   return {
//     restrict: 'AC',
//     link: function(_scope, _element) {
//       $timeout(function(){
//         _element[0].focus();
//       }, 0);
//     }
//   };
// });
