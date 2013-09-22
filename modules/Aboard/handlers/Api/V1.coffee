module.exports= (App, Entry, EntryTag, Tag, Thread, log) ->
    class AboardApiV1 extends App



        @queryEntry: () ->
            (req, res, next) ->
                query= req.query

                log 'queryEntry', query

                req.entries= Entry.query query, null
                req.entries (entries) ->
                        res.entries= entries
                ,   (err) ->
                        res.errors.push res.error= err

                do next

        @getEntry: (param) ->
            (req, res, next) ->
                entryId= req.param param

                log 'getEntry', entryId

                req.entry= Entry.get entryId, null
                req.entry (entry) ->
                        res.entry= entry
                ,   (err) ->
                        res.errors.push res.error= err

                do next

        @queryEntryTag: (param) ->
            (req, res, next) ->
                entryId= req.param param

                log 'queryEntryTag', entryId, req.query

                req.entry= req.entry or {}
                req.entry.tags= EntryTag.query entryId, req.query, null
                req.entry.tags (tags) ->
                        res.entry= res.entry or {}
                        res.entry.tags= tags
                ,   (err) ->
                        res.errors.push res.error= err

                do next

        @postEntryTag: (param) ->
            (req, res, next) ->
                entryId= req.param param

                log 'createEntryTag', entryId, req.body

                req.entry= req.entry or {}
                req.entry.tag= EntryTag.post entryId, req.body, null
                req.entry.tag (tag) ->
                        res.entry= res.entry or {}
                        res.entry.tag= tag
                ,   (err) ->
                        res.errors.push res.error= err

                do next



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

        @postTag: () ->
            (req, res, next) ->

                log 'postTag', query

                req.tag= Tag.post req.body, null
                req.tag (tag) ->
                        res.tag= res.tag or {}
                        res.tag= tag
                ,   (err) ->
                        res.errors.push res.error= err

                do next


        @getTag: (param) ->
            (req, res, next) ->
                tagId= req.param param

                log 'getTag', tagId

                req.tag= Tag.getByName tagId, req.maria
                req.tag (tag) ->
                        res.tag= tag
                ,   (err) ->
                        res.errors.push res.error= err

                do next

        @getTagEntries: () -> (req, res, next) ->
                roles= ['view.anonymous', 'view']
                req.tag (tag) ->
                        req.tag.entries= Entry.queryByTagAndPermissionRoles tag, roles, req.maria
                        req.tag.entries (entries) ->
                                tag.entries= entries
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
