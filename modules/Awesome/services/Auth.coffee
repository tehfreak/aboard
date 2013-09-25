{Passport}= require 'passport'

module.exports= (Account, AccountGithub, config, log) -> class AuthService extends Passport



    constructor: () ->
        super

        @serializeUser= (account, done) ->
            Account.serialize account, null, done

        @deserializeUser= (id, done) ->
            Account.deserialize id, null, done

        passportLocal= require 'passport-local'
        @use new passportLocal.Strategy
            usernameField: 'name'
            passwordField: 'pass'
        ,   (name, pass, done) =>
                done null, new Account
                    name: name
                    pass: Account.sha1 pass

        passportGithub= require 'passport-github'
        @use new passportGithub.Strategy
            clientID: config.auth.github.clientID
            clientSecret: config.auth.github.clientSecret
        ,   (accessToken, refreshToken, github, done) ->
                done null, new AccountGithub
                    providerId: github.id
                    providerName: github.username



    init: () ->
        @initialize
            userProperty: 'account'



    sess: () ->
        @session()
