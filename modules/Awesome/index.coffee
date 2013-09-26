{Module}= require 'di'

module.exports= class Awesome extends Module

    constructor: () ->
        super


        @factory 'AwesomeApiV1', require './handlers/Api/V1'


        # Модель разрешения

        @factory 'Permission', require './models/Permission'


        # Модель учетной записи

        @factory 'Account', require './models/Account'


        # Модель учетной записи гитхаба

        @factory 'AccountGithub', require './models/Account/Github'


        # Модель пользователя

        @factory 'User', require './models/User'

        # Модель разрешения пользователя

        @factory 'UserPermission', require './models/User/Permission'


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
