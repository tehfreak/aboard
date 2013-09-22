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

Ресурсы модулей

        app.use '/', App.static "./modules/Aboard/views/assets"
        app.use '/', App.static "./modules/Aboard/views/templates"

        app.enable 'strict routing'

        app.get '/awesome', (req, res) -> res.redirect '/awesome/'
        app.use '/awesome/', App.static "./modules/Awesome/views/assets"
        app.use '/awesome/', App.static "./modules/Awesome/views/templates"

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

    injector.invoke (app, log) ->

Создает и монтирует субприложение:

        app.use '/api/v1', injector.invoke (AboardApiV1) ->
            app= new AboardApiV1

Регистрирует парсер тела запроса:

            app.use do AboardApiV1.bodyParser

Объявляет обработчики субприложения:

 
## [GET /entries]()
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

 
## [GET /entries/:entry]()
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

## [POST /entries]()
Создает запись.

            app.post '/entries'
            ,   AboardApiV1.validateEntry()
            ,   AboardApiV1.queryTag()
            ,   AboardApiV1.saveEntry()
            ,   (req, res, next) ->
                    req.entry (entry) ->
                            log 'saved entry resolved', entry
                            req.entryTags (tags) ->
                                log 'saved tags resolved', tags
                            res.json 201, entry
                    ,   (err) ->
                            log 'entry rejected', err
                            next err
 
## [GET /entries/:entry/tags]()
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

 
## [POST /entries/:entry/tags]()
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

 
## [GET /tags]()
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

 
## [POST /tags]()
Добавляет тег.

            app.post '/tags'
            ,   AboardApiV1.postTag('entry')
            ,   (req, res, next) ->
                    req.tag (tag) ->
                            log 'created entry tag resolved', tag
                            res.json tag
                    ,   (err) ->
                            log 'created entry tag rejected', err
                            next err

 
## [GET /tags/:tag]()
Отдает тег по идентификатору.

            app.get '/tags/:tag'
            ,   AboardApiV1.getTag('tag')
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

 
## [GET /threads]()
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

 
## [GET /threads/:thread]()
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
 

Возвращает субприложение для монтирования к родителю:

            app

 
##### Обработчик маршрутов Awesome API

    injector.invoke (app, access, auth, log) ->

Создает и монтирует субприложение:

        app.use '/', injector.invoke (AwesomeApiV1, session) ->
            app= new AwesomeApiV1

            app.use AwesomeApiV1.cookieParser()

            app.use AwesomeApiV1.bodyParser()

            app.use session.init
                secret: 'awesome'

            app.use auth.init()
            app.use auth.sess()


Объявляет обработчики субприложения:

 
## [GET /api/v1/user]()
Отдает аутентифицированного пользователя.

            app.get '/api/v1/user'
            ,   access('user')
            ,   AwesomeApiV1.loadUser()
            ,   (req, res, next) ->
                    req.user (user) ->
                            log 'user resolved', user
                            res.json user
                    ,   (err) ->
                            log 'user rejected', err
                            next err

 
## [POST /api/v1/user/auth]()
Aутентифицирует пользователя.

            app.post '/api/v1/user/auth'
            ,   auth.authenticate('local')
            ,   (req, res, next) ->
                    res.json req.account

 
## [GET /login/github]()
Aутентифицирует пользователя Гитхаба.

            app.get '/login/github'
            ,   auth.authenticate('github')
            ,   (req, res, next) ->
                    log 'auth from github'

            app.get '/login/github/callback'
            ,   auth.authenticate('github', {failureRedirect: '/login'})
            ,   (req, res) ->
                    log 'вошел с гитхаба', req.account
                    res.send 'Привет!'

 
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

 
##### Главная страница

    injector.invoke (app) ->
        fs= require 'fs'
        app.use (req, res) ->
            fs.readFile './modules/Aboard/views/templates/index.html', 'utf8', (err, content) ->
                res.send content

 
##### Обработчик ошибок

    injector.invoke (app, log, Error) ->
        #app.use (err, req, res, next) ->
        #    log 'error', err
        #    res.status err.status or 500
        #    res.end 'Error.'

В режиме разработчика объявляет маршрут для симуляции ошибок:

        app.configure 'development', ->

            app.get '/error', (req, res, next) ->
                next Error 'simulated'
