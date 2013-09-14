redis= require 'redis'

module.exports= class RedisMapper



    constructor: (config) ->

        @client= redis.createClient config.port, config.host, config.options
