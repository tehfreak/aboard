{Module}= require 'di'

module.exports= class Awesome extends Module

    constructor: () ->
        super


        @factory 'AwesomeApiV1', require './handlers/Api/V1'



        @factory 'Account', require './models/Account'
        @factory 'AccountGithub', require './models/Account/Github'

        @factory 'Group', require './models/Group'

        @factory 'Permission', require './models/Permission'

        @factory 'Profile', require './models/Profile'
        @factory 'ProfileGroup', require './models/ProfileGroup'
        @factory 'ProfilePermission', require './models/ProfilePermission'

        @factory 'ProfileSession', require './models/ProfileSession'



        @factory 'Access', require './services/Access'

        @factory 'access', (Access) ->
            new Access



        @factory 'Auth', require './services/Auth'

        @factory 'auth', (Auth) ->
            new Auth



        @factory 'Session', require './services/Session'

        @factory 'session', (Session) ->
            new Session
