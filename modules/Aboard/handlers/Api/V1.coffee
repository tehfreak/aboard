module.exports= (App, Entry, EntryTag, Tag, TagAncestor, TagDescendant, Thread, log) ->
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

        @addEntry: () -> (req, res, next) ->
            entry= new Entry req.body

            log 'addEntry', entry

            req.entry= Entry.create entry, req.maria
            req.entry (entry) ->
                    res.entry= entry

                    req.tags (tags) ->
                        res.entry.tags= []
                        for t in req.body.tags
                            for tag in tags
                                if tag.name == t
                                    res.entry.tags.push tag
                        req.entry.tags= EntryTag.create res.entry.id, res.entry.tags, req.maria
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



        @queryTag: () -> (req, res, next) ->
            req.tags= Tag.query req.query, req.maria
            req.tags (tags) ->
                    res.tags= tags
            ,   (err) ->
                    res.errors.push res.error= err
            do next

        @addTag: () -> (req, res, next) ->
            req.tag= Tag.create req.body, req.maria
            req.tag (tag) ->
                    res.tag= tag
            ,   (err) ->
                    res.errors.push res.error= err
            do next

        @addTagTags: (param) -> (req, res, next) ->
            tagId= req.param param
            ids= []
            idx= {}
            for tag in req.body
                if not idx[tag.id]
                    idx[tag.id]= tag
                    ids.push tag.id
            req.tags= Tag.queryByIds ids, req.maria
            req.tags (tags) ->
                ids= []
                idx= {}
                for tag in tags
                    if not idx[tag.id]
                        idx[tag.id]= tag
                        ids.push tag.id
                req.ancestors= TagAncestor.queryByTagIds ids, req.maria
                req.ancestors (ancestors) ->
                    for tag in ancestors
                        if not idx[tag.id]
                            idx[tag.id]= tag
                            ids.push tag.id
                    ancestors= []
                    for id in ids
                        ancestors.push idx[id]
                    req.ancestors= TagAncestor.create tagId, ancestors, req.maria, (err, ancestors) ->
                        next err

        @delTag: (param) -> (req, res, next) ->
            tagId= req.param param
            req.tag= Tag.delete tagId, req.maria
            req.tag (tag) ->
                    res.tag= tag
            ,   (err) ->
                    res.errors.push res.error= err
            do next

        @delTagAncestor: (paramTag, paramAncestor) -> (req, res, next) ->
            tagId= req.param paramTag
            ancestorId= req.param paramAncestor
            req.ancestor= TagAncestor.delete tagId, ancestorId, req.maria
            req.ancestor (tag) ->
                    res.ancestor= tag
            ,   (err) ->
                    res.errors.push res.error= err
            do next

        @getTagById: (param) -> (req, res, next) ->
            tagId= req.param param
            req.tag= Tag.getById tagId, req.maria
            req.tag (tag) ->
                    res.tag= tag
            ,   (err) ->
                    res.errors.push res.error= err
            do next

        @getTagByName: (param) -> (req, res, next) ->
            tagName= req.param param
            req.tag= Tag.getByName tagName, req.maria
            req.tag (tag) ->
                    res.tag= tag
            ,   (err) ->
                    res.errors.push res.error= err
            do next

        @getTagDescendants: () -> (req, res, next) ->
            req.tag (tag) ->
                    req.tag.descendants= TagDescendant.queryByTag tag, req.maria
                    req.tag.descendants (tags) ->
                            tag.descendants= tags
                    ,   (err) ->
                            res.errors.push res.error= err
            do next

        @getTagEntries: () -> (req, res, next) ->
            permissions= []
            for permission in req.user.permissions
                permissions.push permission.id
            req.tag (tag) ->
                    req.tag.entries= Entry.queryByTagAndPermissions tag, permissions, req.maria
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
