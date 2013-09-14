module.exports= (App, log, Thread) ->
    class AboardApiV1 extends App



        @queryThread: () ->
            (req, res, next) ->

                log 'queryThread'

                req.threads= Thread.query req.query, null
                req.threads (threads) ->
                        res.threads= threads
                        log 'Thread.query() resolved', res.threads
                ,   (err) ->
                        res.errors.push res.error= err
                        log 'Thread.query() rejected', res.error

                do next



        @getThread: (param) ->
            (req, res, next) ->
                threadId= req.param param

                log 'getThread', threadId

                req.thread= Thread.get threadId, null
                req.thread (thread) ->
                        res.thread= thread
                        log 'Thread.get(%d) resolved', res.thread
                ,   (err) ->
                        res.errors.push res.error= err
                        log 'Thread.get(%d) rejected', res.error

                do next
