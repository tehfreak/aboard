deferred= require 'deferred'

module.exports= (log) ->
    class EntryTag
        @table: 'entry_tag'



        constructor: (data) ->
            @id= data.id? or null
            @name= data.name? or null



        @query: (entryId, query, db, callback) ->
            tags= []

            dfd= do deferred

            setTimeout =>

                dfd.resolve tags
                if callback instanceof Function
                    process.nextTick ->
                        callback null, tags

            ,   1023

            dfd.promise



        @post: (entryId, data, db, callback) ->
            tag= null

            dfd= do deferred

            setTimeout =>

                dfd.resolve tag= new @ data
                if callback instanceof Function
                    process.nextTick ->
                        callback null, tag

            ,   1023

            dfd.promise
