{Module}= require 'di'

Redis= require './Db/mappers/Redis'
Maria= require './Db/mappers/Maria'

module.exports= class DbModule extends Module

    constructor: () ->
        super

        @factory 'db', (config, log) ->
            db= {}

            if config.db.maria
                db.maria= new Maria config.db.maria

            if config.db.redis
                db.redis= new Redis config.db.redis

            db
