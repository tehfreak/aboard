deferred= require 'deferred'

module.exports= (Account, Permission, log) -> class User
    @table= 'user'

    @Account= Account
    @Permission= Permission



    constructor: (data) ->
        @id= data.id
        @name= data.name



    @query: (query, db, done) ->
        users= []

        dfd= do deferred

        setTimeout =>

            dfd.resolve users
            if done instanceof Function
                process.nextTick ->
                    done null, users

        ,   1023

        dfd.promise



    @getById: (id, db, done) ->
        dfd= do deferred

        err= null
        if not id
            dfd.reject err= Error 'id is not be null'

        if done and err
            return process.nextTick ->
                done err

        db.query "
            SELECT
                User.*
              FROM
                ?? as User
             WHERE
                User.id= ?
            "
        ,   [@table, id]
        ,   (err, rows) =>
                user= null

                if not err
                    if rows.length
                        user= new @ rows.shift()
                    dfd.resolve user
                else
                    dfd.reject err

                if done instanceof Function
                    process.nextTick ->
                        done err, user

        dfd.promise



    @update: (id, data, db, done) ->
        dfd= do deferred

        err= null
        if not id
            err= Error 'id cannot be null'

        if not data
            err= Error 'data cannot be null'

        data= @filterDataForUpdate data

        if err
            dfd.reject err
            if done and err
                process.nextTick ->
                    done err
        if not err
            db.query "
                UPDATE
                    ??
                   SET
                    ?
                 WHERE
                    id= ?
                "
            ,   [@table, data, id]
            ,   (err, res) =>

                    if not err
                        if res.affectedRows == 1
                            dfd.resolve data
                        else
                            dfd.reject err
                    else
                        dfd.reject err

                    if done instanceof Function
                        process.nextTick ->
                            done err, data

        dfd.promise

    @filterDataForUpdate: (data) ->
        data=
            title: data.title
