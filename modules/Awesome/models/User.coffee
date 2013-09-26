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
