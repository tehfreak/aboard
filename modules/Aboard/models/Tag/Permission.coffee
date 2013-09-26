deferred= require 'deferred'

module.exports= (Permission, log) -> class TagPermission extends Permission
    @table: 'tag_permission'
