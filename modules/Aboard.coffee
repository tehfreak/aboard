{Module}= require 'di'

module.exports= class AboardModule extends Module

    constructor: () ->
        super

        @factory 'AboardApiV1', require './Aboard/handlers/Api/V1'

        @factory 'Tag', require './Aboard/models/Tag'
        @factory 'Thread', require './Aboard/models/Thread'
