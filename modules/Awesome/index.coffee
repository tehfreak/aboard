{Module}= require 'di'

module.exports= class Awesome extends Module

    constructor: () ->
        super


        @factory 'AwesomeApiV1', require './handlers/Api/V1'


        # Модель учетной записи

        @factory 'Account', require './models/Account'


        # Модель пользователя

        @factory 'User', require './models/User'


        # Сервис авторизации

        @factory 'Access', require './services/Access'

        @factory 'access', (Access) ->
            new Access


        # Сервис аутентификации

        @factory 'Auth', require './services/Auth'

        @factory 'auth', (Auth) ->
            new Auth


        # Сервис сессий

        @factory 'Session', require './services/Session'

        @factory 'session', (Session) ->
            new Session
