deferred= require 'deferred'

accounts=
    'tehfreak': {id:1, user: {id:1, name:'tehfreak'}}

module.exports= (log) -> class Account

    constructor: () ->



    @serialize: (account, db, done) ->
        log 'serialize account', account
        done null, account

    @deserialize: (account, db, done) ->
        log 'deserialize account', account
        done null, account



    @auth: (identity, credential, db, done) ->
        account= null

        dfd= do deferred

        setTimeout =>

            account= accounts[identity]

            if account
                err= null
                dfd.resolve account
            else
                err= Error 'bad credentials'
                dfd.reject err

            if done instanceof Function
                process.nextTick ->
                    done err, account

        ,   127

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
