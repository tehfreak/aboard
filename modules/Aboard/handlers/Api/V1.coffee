module.exports= (App, log, Thread) ->
    class AboardApiV1 extends App



        @queryThread: () ->
            (req, res, next) ->
                query= req.query

                log 'queryThread', query

                req.threads= Thread.query query, null
                req.threads (threads) ->
                        res.threads= threads
                ,   (err) ->
                        res.errors.push res.error= err

                do next



        @getThread: (param) ->
            (req, res, next) ->
                threadId= req.param param

                log 'getThread', threadId

                req.thread= Thread.get threadId, null
                req.thread (thread) ->
                        res.thread= thread
                ,   (err) ->
                        res.errors.push res.error= err

                do next
