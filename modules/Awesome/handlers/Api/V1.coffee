module.exports= (App, log) ->
    class AwesomeApiV1 extends App



        @queryUser: () ->
            (req, res, next) ->

                log 'queryUser', req.query

                #req.users= Entry.query req.query, null
                #req.users (users) ->
                #        res.users= users
                #,   (err) ->
                #        res.errors.push res.error= err

                do next
