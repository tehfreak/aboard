deferred= require 'deferred'

module.exports= (EntryTag, log) -> class Entry
    @table: 'entry'

    @Tag= EntryTag



    constructor: (data) ->
        @id= data.id
        @name= data.name
        @content= data.content
        @createdAt= data.createdAt
        @updatedAt= data.updatedAt

        if data.deletedAt
            @deletedAt= data.deletedAt
            @deleted= true



    @query: (query, db, callback) ->
        entries= []

        dfd= do deferred

        setTimeout =>

            dfd.resolve entries
            if callback instanceof Function
                process.nextTick ->
                    callback null, entries

        ,   1023

        dfd.promise



    @queryByTag: (tag, db, done) ->
        entries= null

        tagId= tag.id

        dfd= do deferred

        err= null
        if not tag
            dfd.reject err= Error 'tag is not be null'

        if done and err
            return process.nextTick ->
                done err, entries

        db.query "
            SELECT
                Entry.*
              FROM
                ?? as EntryTag
              JOIN
                ?? as Entry
                ON Entry.id= EntryTag.entryId
             WHERE
                EntryTag.tagId= ?
             ORDER BY
                Entry.updatedAt DESC
            "
        ,   [@Tag.table, @table, tag.id]
        ,   (err, rows) =>

                if not err
                    entries= []
                    for row in rows
                        entries.push new @ row
                    dfd.resolve entries
                else
                    dfd.reject err

                if done instanceof Function
                    process.nextTick ->
                        done err, entries

        dfd.promise



    @create: (data, db, done) ->
        entry= new @ data
        dfd= do deferred

        db.query "
            INSERT INTO
                ??
               SET
                ?
            "
        ,   [@table, entry]
        ,   (err, res) =>

                if not err
                    if res.affectedRows == 1
                        entry.id= res.insertId
                        dfd.resolve entry
                    else
                        dfd.reject err
                else
                    dfd.reject err

                if done instanceof Function
                    process.nextTick ->
                        done err, entry
        dfd.promise



    @get: (id, db, callback) ->
        entry= null

        dfd= do deferred

        setTimeout =>

            dfd.resolve entry
            if callback instanceof Function
                process.nextTick ->
                    callback null, entry

        ,   127

        dfd.promise
