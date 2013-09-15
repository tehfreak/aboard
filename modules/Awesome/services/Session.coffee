RedisStore= require 'connect-redis'

module.exports= (App, log) -> class SessionService

    @Store= RedisStore App



    constructor: () ->
        @store= new @constructor.Store



    init: (options) ->
        App.session
            secret: options.secret
            store: @store
