module.exports= (App, log, Tag, Thread) ->
    class AboardApiV1 extends App



        @queryTag: () ->
            (req, res, next) ->
                query= req.query

                log 'queryTag', query

                req.tags= Tag.query query, null
                req.tags (tags) ->
                        res.tags= tags
                ,   (err) ->
                        res.errors.push res.error= err

                do next

        @getTag: (param) ->
            (req, res, next) ->
                tagId= req.param param

                log 'getTag', tagId

                req.tag= Tag.get tagId, null
                req.tag (tag) ->
                        res.tag= tag
                ,   (err) ->
                        res.errors.push res.error= err

                do next



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
