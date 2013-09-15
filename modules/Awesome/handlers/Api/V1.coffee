module.exports= (App, Account, User, log) ->
    class AwesomeApiV1 extends App



        @loadUser: (param) ->
            (req, res, next) ->
                userId= if param then req.param param else req.account.user.id

                log 'loadUser', userId

                req.user= User.get userId, null
                req.user (user) ->
                        res.user= user
                ,   (err) ->
                        res.errors.push res.error= err

                do next



        @authCurrentUser: () ->
            (req, res, next) ->

                log 'authCurrentUser'

                do next



        @queryUser: () ->
            (req, res, next) ->
                query= req.query

                log 'queryUser', query

                req.users= User.query query, null
                req.users (users) ->
                        res.users= users
                ,   (err) ->
                        res.errors.push res.error= err

                do next
