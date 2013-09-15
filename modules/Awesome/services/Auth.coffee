{Passport}= require 'passport'

module.exports= (Account, log) -> class AuthService extends Passport



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



    init: () ->
        @initialize
            userProperty: 'account'



    sess: () ->
        @session()
