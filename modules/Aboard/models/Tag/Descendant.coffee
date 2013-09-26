deferred= require 'deferred'

module.exports= (Tag, log) -> class TagDescendant extends Tag
    @table: 'tag_tag'

    @Tag: Tag



    @queryByTag: (tag, db, done) ->
        tags= null

        tagId= tag.id

        dfd= do deferred

        err= null
        if not tag
            dfd.reject err= Error 'tag is not be null'

        if done and err
            return process.nextTick ->
                done err, tags

        db.query "
            SELECT
                Tag.*,
                GROUP_CONCAT(TT2.parentId) as ancestors
              FROM
                ?? as Tag
              JOIN
                ?? as TT1
                ON TT1.tagId = Tag.id
              LEFT OUTER JOIN
                ?? as TT2
                ON TT2.tagId = Tag.id
             WHERE
                TT1.parentId= ?
             GROUP BY
                Tag.id
            "
        ,   [@Tag.table, @table, @table, tag.id]
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



    @queryByTagAndPermissions: (tag, permissions, db, done) ->
        tags= null

        tagId= tag.id

        dfd= do deferred

        err= null
        if not tag
            dfd.reject err= Error 'tag is not be null'

        if done and err
            return process.nextTick ->
                done err, tags

        db.query "
            SELECT
                Tag.*,
                GROUP_CONCAT(DISTINCT TT2.parentId) as ancestors
              FROM
                ?? as Tag
              JOIN
                ?? as TagPermission
                ON TagPermission.tagId= Tag.id
                    AND TagPermission.permissionId IN(?)
                    AND TagPermission.value= 1
              JOIN
                ?? as TT1
                ON TT1.tagId = Tag.id
              LEFT OUTER JOIN
                ?? as TT2
                ON TT2.tagId = Tag.id
              LEFT JOIN
                ?? as TagPermission2
                ON TagPermission2.tagId= TT2.parentId
             WHERE
                TT1.parentId= ?
               AND
                TagPermission2.permissionId IN(?)
               AND
                TagPermission2.value= 1
             GROUP BY
                Tag.id
            "
        ,   [@Tag.table, @Tag.Permission.table, permissions, @table, @table, @Tag.Permission.table, tag.id, permissions]
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
