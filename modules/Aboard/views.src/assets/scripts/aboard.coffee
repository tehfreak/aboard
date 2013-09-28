app= angular.module 'aboard', ['ngResource']

app.factory 'User', ($resource) ->
    $resource '/api/v1/user', {}
