{Module}= require 'di'

module.exports= class Awesome extends Module

    constructor: () ->
        super


        @factory 'AwesomeApiV1', require './handlers/Api/V1'


        @factory 'Access', require './services/Access'

        @factory 'access', (Access) ->
            new Access
