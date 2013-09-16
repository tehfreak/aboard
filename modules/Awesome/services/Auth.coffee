{Passport}= require 'passport'

module.exports= (Account, AccountGithub, log) -> class AuthService extends Passport



    constructor: () ->
        super

        @serializeUser= (account, done) ->
            Account.serialize account, null, done

        @deserializeUser= (id, done) ->
            Account.deserialize id, null, done

        passportLocal= require 'passport-local'

        @use new passportLocal.Strategy (name, pass, done) ->
            console.log 'auth', arguments
            Account.auth name, pass, null, done

        passportGithub= require 'passport-github'

        @use new passportGithub.Strategy
            clientID: '8356143f06e12555a13e'
            clientSecret: 'a279d0c58218564979d5b5188fb48c0b5a481414'
        ,   (accessToken, refreshToken, profile, done) ->
                account= AccountGithub.auth profile, null, done
                account (account) ->
                        log 'account resolved', account
                        done null, account
                ,   (err) ->
                        log 'account rejected', err
                        done err



    init: () ->
        @initialize
            userProperty: 'account'



    sess: () ->
        @session()
