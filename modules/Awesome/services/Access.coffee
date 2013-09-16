module.exports= (log) -> class AccessService

    constructor: () ->

        access= (args...) ->
            (req, res, next) ->
                log 'access', args...
                if req.isAuthenticated()
                    next null
                else
                    next 401

        @constructor.prototype.__proto__= access.__proto__
        access.__proto__= AccessService.prototype

        return access

