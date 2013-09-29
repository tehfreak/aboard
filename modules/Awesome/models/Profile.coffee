deferred= require 'deferred'

module.exports= (Account, ProfileGroup, ProfilePermission, log) -> class Profile
    @table= 'profile'

    @Account= Account
    @Group= ProfileGroup
    @Permission= ProfilePermission



    constructor: (data) ->

        @id= data.id
        @name= data.name
        @title= data.title

        @enabledAt= data.enabledAt
        @updatedAt= data.updatedAt

        @accounts= data.accounts or JSON.parse (data.accountsJson or null)
        @groups= data.groups or JSON.parse (data.groupsJson or null)
        @permissions= data.permissions or JSON.parse (data.permissionsJson or null)



    @query: (query, db, done) ->
        profiles= null

        dfd= do deferred

        db.query """
            SELECT

                Profile.*,

                CONCAT('[', GROUP_CONCAT(DISTINCT CONCAT('{',
                    '"id":',Account.id,',',
                    '"type":"',Account.type,'"',
                '}') ORDER BY
                    (Account.type <=> 'local') DESC,
                    Account.type
                ),']') as accountsJson,

                CONCAT('[', GROUP_CONCAT(DISTINCT CONCAT('{',
                    '"id":',ProfileGroup.groupId,',',
                    '"name":"',ProfileGroupProfile.name,'",',
                    '"priority":',ProfileGroup.priority,
                '}') ORDER BY
                    ProfileGroup.priority
                ),']') as groupsJson,

                CONCAT('[', GROUP_CONCAT(DISTINCT CONCAT('{',
                    '"id":',Permission.id,',',
                    '"name":"',Permission.name,'",',
                    '"profileId":',ProfilePermission.profileId,',',
                    '"priority":',IF(Profile.id<=>ProfilePermission.profileId,0,ProfileGroup.priority),',',
                    '"value":',ProfilePermission.value,
                '}') ORDER BY
                    (Profile.id <=> ProfilePermission.profileId) DESC,
                    ProfileGroup.priority,
                    Permission.name,
                    ProfilePermission.value
                ),']') as permissionsJson

              FROM ??
                as Profile

              LEFT JOIN ??
                as Account
                ON Account.profileId = Profile.id

              LEFT JOIN ??
                as ProfileGroup
                ON ProfileGroup.profileId = Profile.id

              LEFT JOIN ??
                as ProfileGroupProfile
                ON ProfileGroupProfile.id = ProfileGroup.groupId

              LEFT JOIN ??
                as ProfilePermission
                ON ProfilePermission.profileId = Profile.id OR ProfilePermission.profileId= ProfileGroup.groupId

              LEFT JOIN ??
                as Permission
                ON Permission.id = ProfilePermission.permissionId

             WHERE
                Profile.type = ?

             GROUP BY
                Profile.id
            """
        ,   [@table, @Account.table, @Group.table, @table, @Permission.table, @Permission.Permission.tablePermission, 'user']
        ,   (err, rows) =>
                if not err
                    profiles= []
                    if rows.length
                        for row in rows
                            profiles.push new @ row
                    dfd.resolve profiles
                else
                    dfd.reject err

                if done instanceof Function
                    process.nextTick ->
                        done err, profiles

        dfd.promise



    @getById: (id, db, done) ->
        dfd= do deferred

        err= null
        if not id
            dfd.reject err= Error 'id cannot be null'

        if done and err
            return process.nextTick ->
                done err

        db.query """
            SELECT

                Profile.*,

                CONCAT('[', GROUP_CONCAT(DISTINCT CONCAT('{',
                    '"id":',Account.id,',',
                    '"type":"',Account.type,'"',
                '}') ORDER BY
                    (Account.type <=> 'local') DESC,
                    Account.type
                ),']') as accountsJson,

                CONCAT('[', GROUP_CONCAT(DISTINCT CONCAT('{',
                    '"id":',ProfileGroup.groupId,',',
                    '"name":"',ProfileGroupProfile.name,'",',
                    '"priority":',ProfileGroup.priority,
                '}') ORDER BY
                    ProfileGroup.priority
                ),']') as groupsJson,

                CONCAT('[', GROUP_CONCAT(DISTINCT CONCAT('{',
                    '"id":',Permission.id,',',
                    '"name":"',Permission.name,'",',
                    '"profileId":',ProfilePermission.profileId,',',
                    '"priority":',IF(Profile.id<=>ProfilePermission.profileId,0,ProfileGroup.priority),',',
                    '"value":',ProfilePermission.value,
                '}') ORDER BY
                    (Profile.id <=> ProfilePermission.profileId) DESC,
                    ProfileGroup.priority,
                    Permission.name,
                    ProfilePermission.value
                ),']') as permissionsJson

              FROM ??
                as Profile

              LEFT JOIN ??
                as Account
                ON Account.profileId = Profile.id

              LEFT JOIN ??
                as ProfileGroup
                ON ProfileGroup.profileId = Profile.id

              LEFT JOIN ??
                as ProfileGroupProfile
                ON ProfileGroupProfile.id = ProfileGroup.groupId

              LEFT JOIN ??
                as ProfilePermission
                ON ProfilePermission.profileId = Profile.id OR ProfilePermission.profileId= ProfileGroup.groupId

              LEFT JOIN ??
                as Permission
                ON Permission.id = ProfilePermission.permissionId

             WHERE
                Profile.id= ?
            """
        ,   [@table, @Account.table, @Group.table, @table, @Permission.table, @Permission.Permission.tablePermission, id]
        ,   (err, rows) =>
                profile= null

                if not err
                    if rows.length
                        profile= new @ rows.shift()
                    dfd.resolve profile
                else
                    dfd.reject err

                if done instanceof Function
                    process.nextTick ->
                        done err, profile

        dfd.promise



    @getByName: (name, db, done) ->
        dfd= do deferred

        err= null
        if not name
            dfd.reject err= Error 'name cannot be null'

        if done and err
            return process.nextTick ->
                done err

        db.query """
            SELECT

                Profile.*,

                CONCAT('[', GROUP_CONCAT(DISTINCT CONCAT('{',
                    '"id":',Account.id,',',
                    '"type":"',Account.type,'"',
                '}') ORDER BY
                    (Account.type <=> 'local') DESC,
                    Account.type
                ),']') as accountsJson,

                CONCAT('[', GROUP_CONCAT(DISTINCT CONCAT('{',
                    '"id":',ProfileGroup.groupId,',',
                    '"name":"',ProfileGroupProfile.name,'",',
                    '"priority":',ProfileGroup.priority,
                '}') ORDER BY
                    ProfileGroup.priority
                ),']') as groupsJson,

                CONCAT('[', GROUP_CONCAT(DISTINCT CONCAT('{',
                    '"id":',Permission.id,',',
                    '"name":"',Permission.name,'",',
                    '"profileId":',ProfilePermission.profileId,',',
                    '"priority":',IF(Profile.id<=>ProfilePermission.profileId,0,ProfileGroup.priority),',',
                    '"value":',ProfilePermission.value,
                '}') ORDER BY
                    (Profile.id <=> ProfilePermission.profileId) DESC,
                    ProfileGroup.priority,
                    Permission.name,
                    ProfilePermission.value
                ),']') as permissionsJson

              FROM ??
                as Profile

              LEFT JOIN ??
                as Account
                ON Account.profileId = Profile.id

              LEFT JOIN ??
                as ProfileGroup
                ON ProfileGroup.profileId = Profile.id

              LEFT JOIN ??
                as ProfileGroupProfile
                ON ProfileGroupProfile.id = ProfileGroup.groupId

              LEFT JOIN ??
                as ProfilePermission
                ON ProfilePermission.profileId = Profile.id OR ProfilePermission.profileId= ProfileGroup.groupId

              LEFT JOIN ??
                as Permission
                ON Permission.id = ProfilePermission.permissionId

             WHERE
                Profile.name= ?
            """
        ,   [@table, @Account.table, @Group.table, @table, @Permission.table, @Permission.Permission.tablePermission, name]
        ,   (err, rows) =>
                profile= null

                if not err
                    if rows.length
                        row= rows.shift()
                        if row.id
                            profile= new @ row
                        dfd.resolve profile
                else
                    dfd.reject err

                if done instanceof Function
                    process.nextTick ->
                        done err, profile

        dfd.promise



    @update: (id, data, db, done) ->
        dfd= do deferred

        err= null
        if not id
            err= Error 'id cannot be null'

        if not data
            err= Error 'data cannot be null'

        try
            data= new @ data
        catch e
            err= e

        if err
            if done instanceof Function
                process.nextTick ->
                    done err
            return dfd.reject err

        db.query """
            UPDATE
                ??
               SET
                title= ?
             WHERE
                id= ?
            ;
            SELECT

                Profile.*,

                CONCAT('[', GROUP_CONCAT(DISTINCT CONCAT('{',
                    '"id":',Account.id,',',
                    '"type":"',Account.type,'"',
                '}') ORDER BY
                    (Account.type <=> 'local') DESC,
                    Account.type
                ),']') as accountsJson,

                CONCAT('[', GROUP_CONCAT(DISTINCT CONCAT('{',
                    '"id":',ProfileGroup.groupId,',',
                    '"name":"',ProfileGroupProfile.name,'",',
                    '"priority":',ProfileGroup.priority,
                '}') ORDER BY
                    ProfileGroup.priority
                ),']') as groupsJson,

                CONCAT('[', GROUP_CONCAT(DISTINCT CONCAT('{',
                    '"id":',Permission.id,',',
                    '"name":"',Permission.name,'",',
                    '"profileId":',ProfilePermission.profileId,',',
                    '"priority":',IF(Profile.id<=>ProfilePermission.profileId,0,ProfileGroup.priority),',',
                    '"value":',ProfilePermission.value,
                '}') ORDER BY
                    (Profile.id <=> ProfilePermission.profileId) DESC,
                    ProfileGroup.priority,
                    Permission.name,
                    ProfilePermission.value
                ),']') as permissionsJson

              FROM ??
                as Profile

              LEFT JOIN ??
                as Account
                ON Account.profileId = Profile.id

              LEFT JOIN ??
                as ProfileGroup
                ON ProfileGroup.profileId = Profile.id

              LEFT JOIN ??
                as ProfileGroupProfile
                ON ProfileGroupProfile.id = ProfileGroup.groupId

              LEFT JOIN ??
                as ProfilePermission
                ON ProfilePermission.profileId = Profile.id OR ProfilePermission.profileId= ProfileGroup.groupId

              LEFT JOIN ??
                as Permission
                ON Permission.id = ProfilePermission.permissionId

             WHERE
                Profile.id= ?
            """
        ,   [@table, data.title, id, @table, @Account.table, @Group.table, @table, @Permission.table, @Permission.Permission.tablePermission, id]
        ,   (err, res) =>

                if not err and res[0].affectedRows == 1 and res[1].length == 1
                    data= new @ res[1][0]
                    dfd.resolve data
                else
                    dfd.reject err

                if done instanceof Function
                    process.nextTick ->
                        done err, data

        dfd.promise
