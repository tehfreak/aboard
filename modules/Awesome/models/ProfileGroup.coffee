deferred= require 'deferred'

module.exports= (Group, log) -> class ProfileGroup extends Group
    @table= 'profile_groups'

    @Group: Group
