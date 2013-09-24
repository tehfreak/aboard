deferred= require 'deferred'

module.exports= (log) -> class EntryTag
    @table: 'entry_tag'



    constructor: (data) ->
        @id= data.id? or null
        @name= data.name? or null



    @query: (entryId, query, db, callback) ->
        tags= []

        dfd= do deferred

        setTimeout =>

            dfd.resolve tags
            if callback instanceof Function
                process.nextTick ->
                    callback null, tags

        ,   1023

        dfd.promise



    @create: (entryId, tags, db, done) ->

        bulk= []
        for tag in tags
            bulk.push [entryId, tag.id]

        dfd= do deferred

        db.query "
            INSERT INTO
                ??
            (
                entryId,
                tagId
            )
            VALUES
                ?
            "
        ,   [@table, bulk]
        ,   (err, res) =>

                if not err
                    if res.affectedRows == bulk.length
                        dfd.resolve tags
                    else
                        dfd.reject err
                else
                    dfd.reject err

                if done instanceof Function
                    process.nextTick ->
                        done err, tags

        dfd.promise
