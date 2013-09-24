module.exports= (App, Entry, EntryTag, Tag, TagDescendant, Thread, log) ->
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

        @validateEntry: () -> (req, res, next) ->
            res.entry= new Entry req.body
            do next

        @saveEntry: () -> (req, res, next) ->

            log 'saveEntry', res.entry

            req.entry= Entry.create res.entry, req.maria
            req.entry (entry) ->
                    res.entry= entry

                    req.tags (tags) ->
                        res.entry.tags= []
                        for t in req.body.tags
                            for tag in tags
                                if tag.name == t
                                    res.entry.tags.push tag
                        req.entry.tags= EntryTag.insert res.entry.id, res.entry.tags, req.maria
                        req.entry.tags (tags) ->
                                res.json 201, res.entry
                        ,   (err) ->
                                next err

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

                req.tags= Tag.query query, req.maria
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


        @getTagById: (param) ->
            (req, res, next) ->
                tagId= req.param param

                log 'getTagById', tagId

                req.tag= Tag.getById tagId, req.maria
                req.tag (tag) ->
                        res.tag= tag
                ,   (err) ->
                        res.errors.push res.error= err

                do next

        @getTagByName: (param) ->
            (req, res, next) ->
                tagName= req.param param

                log 'getTagByName', tagName

                req.tag= Tag.getByName tagName, req.maria
                req.tag (tag) ->
                        res.tag= tag
                ,   (err) ->
                        res.errors.push res.error= err

                do next

        @getTagDescendants: () -> (req, res, next) ->
                req.tag (tag) ->
                        log 'query Tag Descendants'
                        req.tag.descendants= TagDescendant.queryByTag tag, req.maria
                        req.tag.descendants (tags) ->
                                tag.descendants= tags
                        ,   (err) ->
                                res.errors.push res.error= err
                do next

        @getTagEntries: () -> (req, res, next) ->
                req.tag (tag) ->
                        req.tag.entries= Entry.queryByTag tag, req.maria
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
