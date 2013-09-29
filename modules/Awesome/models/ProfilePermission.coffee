deferred= require 'deferred'

module.exports= (Permission, log) -> class ProfilePermission extends Permission
    @table= 'profile_permissions'

    @Permission: Permission
