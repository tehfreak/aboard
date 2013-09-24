deferred= require 'deferred'

module.exports= (Tag, log) -> class TagAncestor extends Tag
    @table: 'tag_tag'

    @Tag: Tag



    @queryByTagIds: (ids, db, done) ->
        tags= null
        dfd= do deferred

        err= null
        if not ids.length
            dfd.reject err= Error 'ids is not be empty'

        if done and err
            return process.nextTick ->
                done err, tags

        db.query "
            SELECT
                Tag.*
              FROM
                ?? as TagTag
              JOIN
                ?? as Tag
                ON Tag.id= TagTag.parentId
             WHERE
                TagTag.tagId IN(?)
            "
        ,   [@table, @Tag.table, ids]
        ,   (err, rows) =>

                if not err
                    tags= []
                    for row in rows
                        tags.push tag= new @ row
                        tag.ancestors= row.ancestors
                    dfd.resolve tags
                else
                    dfd.reject err

                if done instanceof Function
                    process.nextTick ->
                        done err, tags

        dfd.promise



    @create: (tagId, ancestors, db, done) ->
        dfd= do deferred

        bulk= []
        for tag in ancestors
            bulk.push [tagId, tag.id]

        err= null
        if not bulk.length
            dfd.reject err= Error 'ancestors is not be empty'

        if done and err
            return process.nextTick ->
                done err, tags

        db.query "
            INSERT INTO
                ??
            (
                tagId,
                parentId
            )
            VALUES
                ?
            "
        ,   [@table, bulk]
        ,   (err, res) =>

                if not err
                    if res.affectedRows == bulk.length
                        dfd.resolve ancestors
                    else
                        dfd.reject err
                else
                    dfd.reject err

                if done instanceof Function
                    process.nextTick ->
                        done err, ancestors

        dfd.promise
