maria= require 'mysql'

module.exports= class MariaMapper



    constructor: (config) ->

        @pool= maria.createPool config



    getConnection: (done) ->

        @pool.getConnection done
