deferred= require 'deferred'
crypto= require 'crypto'

module.exports= (log) -> class Account
    @table: 'user_account'



    constructor: (data) ->
        @id= data.id
        @userId= data.userId
        @name= data.name
        @pass= data.pass



    @serialize: (account, db, done) ->
        log 'serialize account', account
        done null, account

    @deserialize: (account, db, done) ->
        log 'deserialize account', account
        done null, account



    @auth: (account, db, done) ->
        dfd= do deferred

        err= null
        if not account
            dfd.reject err= Error 'account is not be null'

        if done and err
            return process.nextTick ->
                done err, account

        db.query "
            SELECT
                Account.*
              FROM
                ?? as Account
             WHERE
                Account.name= ?
               AND
                Account.pass= ?
            "
        ,   [@table, account.name, account.pass]
        ,   (err, rows) =>
                account= null

                if not err
                    if rows.length
                        account= new @ rows.shift()
                    dfd.resolve account
                else
                    dfd.reject err

                if done instanceof Function
                    process.nextTick ->
                        done err, account

        dfd.promise



    @query: (query, db, done) ->
        accounts= []

        dfd= do deferred

        setTimeout =>

            dfd.resolve accounts
            if done instanceof Function
                process.nextTick ->
                    done null, accounts

        ,   1023

        dfd.promise



    @get: (id, db, done) ->
        account= null

        dfd= do deferred

        setTimeout =>

            dfd.resolve account
            if done instanceof Function
                process.nextTick ->
                    done null, account

        ,   127

        dfd.promise



    @sha1: (pass) ->
        sha1= crypto.createHash 'sha1'
        sha1.update pass
        sha1.digest 'hex'
