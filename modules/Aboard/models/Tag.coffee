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



    @query: (query, db, done) ->
        tags= null
        dfd= do deferred

        err= null
        if done and err
            return process.nextTick ->
                done err, tags

        db.query "
            SELECT
                Tag.*
              FROM
                ?? as Tag
            "
        ,   [@table]
        ,   (err, rows) =>

                if not err
                    tags= []
                    for row in rows
                        tags.push new @ row
                    dfd.resolve tags
                else
                    dfd.reject err

                if done instanceof Function
                    process.nextTick ->
                        done err, tags

        dfd.promise



    @create: (data, db, done) ->
        tag= new @ data
        dfd= do deferred

        db.query "
            INSERT INTO
                ??
               SET
                ?
            "
        ,   [@table, tag]
        ,   (err, res) =>

                if not err
                    if res.affectedRows == 1
                        tag.id= res.insertId
                        dfd.resolve tag
                    else
                        dfd.reject err
                else
                    dfd.reject err

                if done instanceof Function
                    process.nextTick ->
                        done err, tag

        dfd.promise



    @getById: (id, db, done) ->
        tag= null
        dfd= do deferred

        err= null
        if not id
            dfd.reject err= Error 'id of tag is not be null'

        if done and err
            return process.nextTick ->
                done err, tag

        db.query "
            SELECT
                Tag.*
              FROM
                ?? as Tag
             WHERE
                Tag.id= ?
            "
        ,   [@table, id]
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
                Tag.*
              FROM
                ?? as Tag
             WHERE
                Tag.name= ?
            "
        ,   [@table, name]
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
