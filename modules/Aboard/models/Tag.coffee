deferred= require 'deferred'

module.exports= (log) ->
    class Tag

        constructor: () ->



        @query: (query, db, callback) ->
            tags= []

            dfd= do deferred

            setTimeout =>

                dfd.resolve tags
                if callback instanceof Function
                    process.nextTick ->
                        callback null, tags

            ,   1023

            dfd.promise



        @get: (id, db, callback) ->
            tag= null

            dfd= do deferred

            setTimeout =>

                dfd.resolve tag
                if callback instanceof Function
                    process.nextTick ->
                        callback null, tag

            ,   127

            dfd.promise
