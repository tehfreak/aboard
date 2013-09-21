deferred= require 'deferred'

module.exports= (Entry, log) -> class Tag
    @table: 'tag'

    @Entry= Entry



    constructor: (data) ->
        @id= data.id
        @name= data.name
        @createdAt= data.createdAt
        @updatedAt= data.updatedAt
        if data.deletedAt
            @deletedAt= data.deletedAt
            @deleted= true



    @query: (query, db, callback) ->
        tags= []

        dfd= do deferred

        setTimeout =>

            dfd.resolve tags
            if callback instanceof Function
                process.nextTick ->
                    callback null, tags

        ,   1023

        dfd.promise



    @post: (data, db, callback) ->
        tag= null

        dfd= do deferred

        setTimeout =>

            dfd.resolve tag= new @ data
            if callback instanceof Function
                process.nextTick ->
                    callback null, tag

        ,   1023

        dfd.promise



    @getByName: (name, db, done) ->
        tag= null
        dfd= do deferred

        err= null
        if not name
            dfd.reject err= Error 'name of tag is not be null'

        if done and err
            return process.nextTick ->
                done err, tag

        db.query "
            SELECT
                Tag.id,
                Tag.name,
                Tag.createdAt,
                Tag.updatedAt,
                Tag.deletedAt
              FROM
                ?? as Tag
              LEFT OUTER JOIN
                ?? as EntryTag
                ON EntryTag.tagId= Tag.id
              LEFT OUTER JOIN
                ?? as Entry
                ON Entry.id= EntryTag.entryId
             WHERE
                Tag.name= ?
             GROUP BY
                Tag.id
            "
        ,   [@table, @Entry.Tag.table, @Entry.table, name]
        ,   (err, rows) =>

                if not err
                    if rows.length
                        tag= new @ rows.shift()
                    dfd.resolve tag
                else
                    dfd.reject err

                if done instanceof Function
                    process.nextTick ->
                        done err, tag

        dfd.promise
