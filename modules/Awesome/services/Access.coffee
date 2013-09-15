module.exports= (log) -> class AccessService

    constructor: () ->

        access= (args...) ->
            (req, res, next) ->
                log 'access', args...
                next null

        @constructor.prototype.__proto__= access.__proto__
        access.__proto__= AccessService.prototype

        return access

