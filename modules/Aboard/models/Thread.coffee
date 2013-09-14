deferred= require 'deferred'

module.exports= (log) ->
    class Thread

        constructor: () ->



        @query: (query, db, callback) ->
            threads= []

            dfd= do deferred

            setTimeout =>

                dfd.resolve threads
                if callback instanceof Function
                    process.nextTick ->
                        callback null, threads

            ,   1023

            dfd.promise



        @get: (id, db, callback) ->
            thread= null

            dfd= do deferred

            setTimeout =>

                dfd.resolve thread
                if callback instanceof Function
                    process.nextTick ->
                        callback null, thread

            ,   127

            dfd.promise
