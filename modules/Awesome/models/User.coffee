deferred= require 'deferred'

module.exports= (log) -> class User

        constructor: () ->



        @query: (query, db, done) ->
            users= []

            dfd= do deferred

            setTimeout =>

                dfd.resolve users
                if done instanceof Function
                    process.nextTick ->
                        done null, users

            ,   1023

            dfd.promise



        @get: (id, db, done) ->
            user= null

            dfd= do deferred

            setTimeout =>

                dfd.resolve user
                if done instanceof Function
                    process.nextTick ->
                        done null, user

            ,   127

            dfd.promise
