# aboard node
 

 
### Подключение зависимостей

 
##### Подключает конфиг

    manifest= require './package.json'

 
##### Подключает инъектор

    di= require 'di'


 
### Подключение модулей

 
##### Подключает модули инъектора

    App= require './modules/App'
    Config= require './modules/Config'
    Db= require './modules/Db'

    Aboard= require './modules/Aboard'
    Awesome= require './modules/Awesome'

 
##### Инстанцирует инъектор

    injector= new di.Injector [
        new App()
        new Config(manifest.config)
        new Db()

        new Aboard()
        new Awesome()
    ]
 

 
### Конфигурация приложения

 
##### Сервер приложения

    injector.invoke (app, log) ->

        module.exports= app

        app.listen port= 1337, () ->
            log 'listening on port - %d', port

 
### Регистрация обработчиков запросов

    injector.invoke (app, App) ->

 
##### Лог запросов к приложению

        app.use App.logger 'dev'

 
##### Ресурсы вида

Общие ресурсы

        app.use '/', App.static "./views/assets"
        app.use '/', App.static "./views/templates"

##### Обработчик подключения к базе данных

    injector.invoke (app, db, log) ->

Каждому запросу к приложению, кроме запросов к статике, полагается
подключение к базе данных. Свободное соединение выбирается из пула соединений:

        app.use (req, res, next) ->
            db.maria.getConnection (err, maria) ->
                log 'maria connection', !!maria, err

Полученное соединение сохраняется в запросе:

                req.maria= maria if not err

После выполнения запроса соединение возвращается в пул:

                req.on 'end', () ->
                    if req.maria
                        do req.maria.release

                next err

 
##### Обработчик маршрутов Aboard API

    injector.invoke (app, App, config, auth, session, log) ->

Регистрирует парсер печенек:

        app.use do App.cookieParser

Регистрирует парсер тела запроса:

        app.use do App.bodyParser

Регистрирует обработчик сессий:

        app.use session.init
            secret: config.session.secret

Регистрирует обработчики аутентификации:

        app.use do auth.init
        app.use do auth.sess

Создает и монтирует субприложение:

        app.use '/api/v1', injector.invoke (AboardApiV1, AwesomeApiV1) ->
            app= new AboardApiV1

Регистрирует обработчики авторизации:

            app.use do AwesomeApiV1.loadUser
            app.use do AwesomeApiV1.loadUserPermission

Объявляет обработчики субприложения:

 
## [GET /api/v1/entries]()
Отдает список записей.

            app.get '/entries'
            ,   AboardApiV1.queryEntry()
            ,   (req, res, next) ->
                    req.entries (entries) ->
                            log 'entries resolved', entries
                            res.json entries
                    ,   (err) ->
                            log 'entries rejected', err
                            next err

 
## [GET /api/v1/entries/:entry]()
Отдает запись по идентификатору.

            app.get '/entries/:entry'
            ,   AboardApiV1.getEntry('entry')
            ,   (req, res, next) ->
                    req.entry (entry) ->
                            log 'entry resolved', entry
                            if not entry
                                res.status 404
                            res.json entry
                    ,   (err) ->
                            log 'entry rejected', err
                            next err

## [POST /api/v1/entries]()
Создает запись.

            app.post '/entries'
            ,   AboardApiV1.queryTag()
            ,   AboardApiV1.addEntry()
            ,   (req, res, next) ->
                    req.entry (entry) ->
                            log 'created entry resolved', entry
                            req.entryTags (tags) ->
                                log 'created entry tags resolved', tags
                            res.json 201, entry
                    ,   (err) ->
                            log 'created entry rejected', err
                            next err
 
## [GET /api/v1/entries/:entry/tags]()
Отдает теги записи по ее идентификатору.

            app.get '/entries/:entry/tags'
            ,   AboardApiV1.queryEntryTag('entry')
            ,   (req, res, next) ->
                    req.entry.tags (tags) ->
                            log 'entry tags resolved', tags
                            res.json tags
                    ,   (err) ->
                            log 'entry tags rejected', err
                            next err

 
## [POST /api/v1/entries/:entry/tags]()
Отдает теги записи по ее идентификатору.

            app.post '/entries/:entry/tags'
            ,   AboardApiV1.postEntryTag('entry')
            ,   (req, res, next) ->
                    req.entry.tag (tag) ->
                            log 'created entry tag resolved', tag
                            res.json tag
                    ,   (err) ->
                            log 'created entry tag rejected', err
                            next err

 
## [GET /api/v1/tags]()
Отдает список тегов.

            app.get '/tags'
            ,   AboardApiV1.queryTag()
            ,   (req, res, next) ->
                    req.tags (tags) ->
                            log 'tags resolved', tags
                            res.json tags
                    ,   (err) ->
                            log 'tags rejected', err
                            next err

 
## [POST /api/v1/tags]()
Добавляет тег.

            app.post '/tags'
            ,   AboardApiV1.addTag()
            ,   (req, res, next) ->
                    req.tag (tag) ->
                            log 'created tag resolved', tag
                            res.json tag
                    ,   (err) ->
                            log 'created tag rejected', err
                            next err

 
## [POST /api/v1/tags/:tag/ancestors]()
Добавляет предков указанному тегу.

            app.post '/tags/:tagId(\\d+)/ancestors'
            ,   AboardApiV1.addTagTags('tagId')
            ,   (req, res, next) ->
                    log 'add tag ancestors', req.body
                    req.ancestors (ancestors) ->
                            log 'created tag ancestors resolved', ancestors
                            res.json 201, ancestors
                    ,   (err) ->
                            log 'created tag ancestors rejected', err
                            next err

 
## [DELETE /api/v1/tags/:tag]()
Удаляет указанный тег.

            app.delete '/tags/:tagId(\\d+)'
            ,   AboardApiV1.delTag('tagId')
            ,   (req, res, next) ->
                    req.tag (tag) ->
                            log 'deleted tag resolved', tag
                            res.json 200, tag
                    ,   (err) ->
                            log 'deleted tag rejected', err
                            next err

## [DELETE /api/v1/tags/:tag/ancestors/:ancestorId]()
Удаляет связь указанного предка с указанным тегом.

            app.delete '/tags/:tagId(\\d+)/ancestors/:ancestorId(\\d+)'
            ,   AboardApiV1.delTagAncestor('tagId', 'ancestorId')
            ,   (req, res, next) ->
                    req.ancestor (tag) ->
                            log 'deleted tag ancestor resolved', tag
                            res.json 200, tag
                    ,   (err) ->
                            log 'deleted tag rejected', err
                            next err

 
## [GET /api/v1/tags/:tag]()
Отдает тег по идентификатору.

            app.get '/tags/:tagId(\\d+)'
            ,   AboardApiV1.getTagById('tagId')
            ,   AboardApiV1.getTagEntries()
            ,   (req, res, next) ->
                    req.tag (tag) ->
                            log 'tag resolved', res.tag
                            if not tag
                                return res.json 404, tag
                            req.tag.entries (entries) ->
                                    log 'tag entries resolved', res.tag.entries
                                    return res.json tag
                    ,   (err) ->
                            log 'tag rejected', err
                            return next err

 
## [GET /api/v1/tags/:tag]()
Отдает тег по идентификатору.

            app.get '/tags/:tag(\\w+)'
            ,   AboardApiV1.getTagByName('tag')
            ,   AboardApiV1.getTagEntries()
            ,   (req, res, next) ->
                    req.tag (tag) ->
                            log 'tag resolved', res.tag
                            if not tag
                                return res.json 404, tag
                            req.tag.entries (entries) ->
                                    log 'tag entries resolved', res.tag.entries
                                    return res.json tag
                    ,   (err) ->
                            log 'tag rejected', err
                            return next err

 
## [GET /api/v1/tags/:tag/descendants]()
Отдает потомков указанного тега.

            app.get '/tags/:tagId(\\d+)/descendants'
            ,   AboardApiV1.getTagById('tagId')
            ,   AboardApiV1.getTagDescendants()
            ,   (req, res, next) ->
                    req.tag (tag) ->
                            log 'tag resolved', res.tag
                            if not tag
                                return res.json 404, tag
                            req.tag.descendants (tags) ->
                                    log 'tag descendants resolved', res.tag.descendants
                                    return res.json tag
                    ,   (err) ->
                            log 'tag rejected', err
                            return next err

            app.get '/tags/:tag(\\w+)/descendants'
            ,   AboardApiV1.getTagByName('tag')
            ,   AboardApiV1.getTagDescendants()
            ,   (req, res, next) ->
                    req.tag (tag) ->
                            log 'tag resolved', res.tag
                            if not tag
                                return res.json 404, tag
                            req.tag.descendants (tags) ->
                                    log 'tag descendants resolved', res.tag.descendants
                                    return res.json tag
                    ,   (err) ->
                            log 'tag rejected', err
                            return next err

 
## [GET /api/v1/threads]()
Отдает список тредов.

            app.get '/threads'
            ,   AboardApiV1.queryThread()
            ,   (req, res, next) ->
                    req.threads (threads) ->
                            log 'threads resolved', threads
                            res.json threads
                    ,   (err) ->
                            log 'threads rejected', err
                            next err

 
## [GET /api/v1/threads/:thread]()
Отдает тред по идентификатору.

            app.get '/threads/:thread'
            ,   AboardApiV1.getThread('thread')
            ,   (req, res, next) ->
                    req.thread (thread) ->
                            log 'thread resolved', thread
                            if not thread
                                res.status 404
                            res.json thread
                    ,   (err) ->
                            log 'thread rejected', err
                            next err
 
Регистрирует обработчик ошибок:

            #app.use AboardApiV1.handleError()
            app.use AboardApiV1.errorHandler()

Возвращает субприложение для монтирования к родителю:

            app

 
##### Обработчик маршрутов Awesome API

    injector.invoke (app, access, log) ->

Создает и монтирует субприложение:

        app.use '/', injector.invoke (AwesomeApiV1) ->
            app= new AwesomeApiV1

Объявляет обработчики субприложения:

 
## [GET /api/v1/user]()
Отдает аутентифицированного пользователя.

            app.get '/api/v1/user'
            ,   access('user')
            ,   (req, res, next) ->
                    req.user (user) ->
                            log 'user resolved', user
                            res.json user
                    ,   (err) ->
                            log 'user rejected', err
                            next err

 
## [PATCH /api/v1/user]()
Обновляет данные аутентифицированного пользователя.

            app.patch '/api/v1/user'
            ,   access('user')
            ,   AwesomeApiV1.updateUser()
            ,   (req, res, next) ->
                    req.user (user) ->
                            log 'updated user resolved', user
                            res.json user
                    ,   (err) ->
                            log 'updated user rejected', err
                            next err

 
## [PATCH /api/v1/user/account]()
Обновляет данные учетной записи аутентифицированного пользователя.

            app.patch '/api/v1/user/account'
            ,   access('user')
            ,   AwesomeApiV1.updateAccount()
            ,   (req, res, next) ->
                    req.account (account) ->
                            log 'updated user account resolved', account
                            res.json account
                    ,   (err) ->
                            log 'updated user account rejected', err
                            next err

 
## [POST /api/v1/user/auth]()
Aутентифицирует пользователя.

            app.post '/api/v1/user/auth'
            ,   AwesomeApiV1.authUser()
            ,   (req, res, next) ->
                    res.json req.account

 
## [GET /login/github]()
Aутентифицирует пользователя Гитхаба.

            app.get '/login/github'
            ,   AwesomeApiV1.authUserGithub()

            app.get '/login/github/callback'
            ,   AwesomeApiV1.authUserGithub()
            ,   (req, res) ->
                    log 'вошел с гитхаба', req.account
                    res.json req.account

 
## [POST /logout]()
Деаутентифицирует пользователя.

            app.post '/logout'
            ,   (req, res, next) ->
                    req.logout()
                    res.redirect '/'

 
## [POST /api/v1/users]()
Отдает список пользователей.

            app.get '/api/v1/users'
            ,   access('admin.users')
            ,   AwesomeApiV1.queryUser()
            ,   (req, res, next) ->
                    req.users (users) ->
                            log 'users resolved', users
                            res.json users
                    ,   (err) ->
                            log 'users rejected', err
                            next err

 
## [POST /api/v1/users/:userId]()
Отдает пользователя по идентификатору.

            app.get '/api/v1/users/:userId'
            ,   access('admin.users')
            ,   AwesomeApiV1.loadUser('userId')
            ,   (req, res, next) ->
                    req.user (user) ->
                            log 'user resolved', user
                            if not user
                                res.status 404
                            res.json user
                    ,   (err) ->
                            log 'user rejected', err
                            next err
 

Возвращает субприложение для монтирования к родителю:

            app

 
##### Ресурсы приложения

    injector.invoke (app, App, log) ->

Ресурсы модулей:

        app.enable 'strict routing'

        app.use '/', App.static "./modules/Aboard/views/assets"
        app.use '/', App.static "./modules/Aboard/views/templates"

        app.get '/auth', (req, res) -> res.redirect '/auth/'
        app.get '/auth/', (req, res, next) ->
            if req.isUnauthenticated()
                return do next
            res.redirect '/'
        app.use '/auth/', App.static "./modules/Aboard/views/templates/Welcome"

        app.get '/awesome', (req, res) -> res.redirect '/awesome/'
        app.use '/awesome/', (req, res, next) ->
            if req.isAuthenticated()
                return do next
            res.redirect '/auth/'
        app.use '/awesome/', App.static "./modules/Awesome/views/assets"
        app.use '/awesome/', App.static "./modules/Awesome/views/templates"

 
##### Обработчик ошибок

    deferred= require 'deferred'

    injector.invoke (app, log, Error) ->
        deferred.monitor '7000', (err) ->
            log 'promise error', err
        #app.use (err, req, res, next) ->
        #    log 'error', err
        #    res.status err.status or 500
        #    res.end 'Error.'

В режиме разработчика объявляет маршрут для симуляции ошибок:

        app.configure 'development', ->

            app.get '/error', (req, res, next) ->
                next Error 'simulated'
