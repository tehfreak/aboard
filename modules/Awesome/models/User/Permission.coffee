deferred= require 'deferred'

module.exports= (Permission, log) -> class UserPermission extends Permission
    @table= 'user_permission'

    @Permission: Permission



    constructor: (data) ->
        @id= data.id
        @name= data.name



    @query: (user, db, done) ->
        permissions= null

        dfd= do deferred

        err= null
        if not user
            dfd.reject err= Error 'user cannot be null'

        if done and err
            return process.nextTick ->
                done err, permissions

        db.query "
            SELECT
                Permission.*
              FROM
                ?? as UserPermission
              JOIN
                ?? as Permission
                ON Permission.id= UserPermission.permissionId
             WHERE
                UserPermission.userId= ?
               AND
                UserPermission.value= 1
            "
        ,   [@table, @tablePermission, user.id]
        ,   (err, rows) =>

                if not err
                    permissions= []
                    for row in rows
                        permissions.push permission= new @ row
                    dfd.resolve permissions
                else
                    dfd.reject err

                if done instanceof Function
                    process.nextTick ->
                        done err, permissions

        dfd.promise
