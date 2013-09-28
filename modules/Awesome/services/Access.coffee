module.exports= (log) -> class AccessService

    constructor: () ->

        access= (args...) -> (req, res, next) ->
            if req.isAuthenticated()
                return do next
            return next 401

        @constructor.prototype.__proto__= access.__proto__
        access.__proto__= AccessService.prototype

        return access

