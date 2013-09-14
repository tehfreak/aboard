{Module}= require 'di'

module.exports= class ConfigModule extends Module

    constructor: (config) ->
        super

        @value 'config', config
