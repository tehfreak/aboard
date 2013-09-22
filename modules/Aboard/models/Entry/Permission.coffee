deferred= require 'deferred'

module.exports= (Permission, log) -> class EntryPermission extends Permission
    @table: 'entry_permission'
