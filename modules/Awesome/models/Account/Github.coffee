deferred= require 'deferred'

accounts=
    '386459': {id:1, user: {id:1, name:'tehfreak'}}

module.exports= (log) -> class Account

    constructor: () ->



    @auth: (profile, db, done) ->

        log 'аутентифицировать или зарегистрировать пользователя'

        dfd= do deferred

        account= @get profile.id, db
        account (account) ->
            log 'аккаунт найден', account
            dfd.resolve account

        dfd.promise



    @get: (id, db, done) ->
        account= null

        log 'найти аккаунт гитхабера', id

        dfd= do deferred

        setTimeout =>

            account= accounts[id]

            dfd.resolve account
            if done instanceof Function
                process.nextTick ->
                    done null, accounts

        ,   1023

        dfd.promise
