deferred= require 'deferred'

module.exports= (Entry, TagPermission, log) -> class Tag
    @table: 'tag'

    @Entry= Entry
    @Permission= TagPermission



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



    @queryByPermissions: (query, permissions, db, done) ->
        tags= null
        dfd= do deferred

        err= null
        if not permissions.length
            dfd.reject err= Error 'permissions cannot be empty'

        if done and err
            return process.nextTick ->
                done err, tags

        db.query "
            SELECT
                Tag.*
              FROM
                ?? as Tag
              JOIN
                ?? as TagPermission
                ON TagPermission.tagId= Tag.id
                    AND TagPermission.permissionId IN(?)
                    AND TagPermission.value= 1
            "
        ,   [@table, @Permission.table, permissions]
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



    @queryByIds: (ids, db, done) ->
        tags= null
        dfd= do deferred

        err= null
        if not ids.length
            dfd.reject err= Error 'ids is not be empty'

        if done and err
            return process.nextTick ->
                done err, tags

        db.query "
            SELECT
                Tag.*
              FROM
                ?? as Tag
             WHERE
                Tag.id IN(?)
            "
        ,   [@table, ids]
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



    @delete: (id, db, done) ->
        dfd= do deferred

        db.query "
            DELETE
              FROM
                ??
             WHERE
                id= ?
            "
        ,   [@table, id]
        ,   (err, res) =>

                if not err
                    if res.affectedRows == 1
                        dfd.resolve id
                    else
                        dfd.reject new Error 'cannot delete tag'
                else
                    dfd.reject err

                if done instanceof Function
                    process.nextTick ->
                        done err, id

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



    @getByIdAndPermissions: (id, permissions, db, done) ->
        tag= null
        dfd= do deferred

        err= null
        if not id
            dfd.reject err= Error 'id of tag is not be null'
        if not permissions.length
            dfd.reject err= Error 'permissions cannot be empty'

        if done and err
            return process.nextTick ->
                done err, tag

        db.query "
            SELECT
                Tag.*
              FROM
                ?? as Tag
              JOIN
                ?? as TagPermission
                ON TagPermission.tagId= Tag.id
                    AND TagPermission.permissionId IN(?)
                    AND TagPermission.value= 1
             WHERE
                Tag.id= ?
            "
        ,   [@table, @Permission.table, permissions, id]
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



    @getByNameAndPermissions: (name, permissions, db, done) ->
        tag= null
        dfd= do deferred

        err= null
        if not name
            dfd.reject err= Error 'name of tag is not be null'
        if not permissions.length
            dfd.reject err= Error 'permissions cannot be empty'

        if done and err
            return process.nextTick ->
                done err, tag

        db.query "
            SELECT
                Tag.*
              FROM
                ?? as Tag
              JOIN
                ?? as TagPermission
                ON TagPermission.tagId= Tag.id
                    AND TagPermission.permissionId IN(?)
                    AND TagPermission.value= 1
             WHERE
                Tag.name= ?
            "
        ,   [@table, @Permission.table, permissions, name]
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
