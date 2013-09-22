{Module}= require 'di'

module.exports= class AboardModule extends Module

    constructor: () ->
        super

        @factory 'AboardApiV1', require './Aboard/handlers/Api/V1'

        @factory 'Permission', require './Aboard/models/Permission'

        @factory 'Entry', require './Aboard/models/Entry'
        @factory 'EntryTag', require './Aboard/models/Entry/Tag'
        @factory 'EntryPermission', require './Aboard/models/Entry/Permission'

        @factory 'Tag', require './Aboard/models/Tag'

        @factory 'Thread', require './Aboard/models/Thread'
