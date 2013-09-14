deferred= require 'deferred'

module.exports= (log) ->
    class Entry

        constructor: () ->



        @query: (query, db, callback) ->
            entries= []

            dfd= do deferred

            setTimeout =>

                dfd.resolve entries
                if callback instanceof Function
                    process.nextTick ->
                        callback null, entries

            ,   1023

            dfd.promise



        @get: (id, db, callback) ->
            entry= null

            dfd= do deferred

            setTimeout =>

                dfd.resolve entry
                if callback instanceof Function
                    process.nextTick ->
                        callback null, entry

            ,   127

            dfd.promise
