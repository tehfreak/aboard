{Module}= require 'di'

App= require './App/models/App'

module.exports= class AppModule extends Module

    constructor: () ->
        super


        @factory 'log', () ->
            console.log


        @factory 'App', () ->
            App

        @factory 'app', (App) ->
            new App


        @factory 'Error', () ->
            Error
