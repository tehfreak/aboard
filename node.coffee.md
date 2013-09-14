# Приложение





## Подключение зависимостей



### Подключает конфиг

    manifest= require './package.json'



### Подключает инъектор зависимостей

    di= require 'di'



### Подключает модули инъектора

    App= require './modules/App'
    Config= require './modules/Config'
    Db= require './modules/Db'

    Aboard= require './modules/Aboard'



### Инстанцирует инъектор

    injector= new di.Injector [
        new App()
        new Config(manifest.config)
        new Db()

        new Aboard()
    ]





## Конфигурация приложения



### Запускает сервер приложения на указанном порту

    injector.invoke (app, log) ->

        app.listen port= 1337, () ->
            log 'listening on port - %d', port



### Объявляет обработчики маршрутов приложения

    injector.invoke (app, App) ->

Журнал запросов:

        app.use App.logger 'dev'

Статические файлы:

        app.use '/', App.static "./views"

Домашняя страница приложения:

        app.get '/', (req, res) ->
            res.end 'Welcome aboard, Username :3'



### Объявляет подключение к базе данных

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



### Объявляет обработчики маршрутов API

    injector.invoke (app, log) ->

Создает и монтирует субприложение:

        app.use '/api/v1', injector.invoke (AboardApiV1) ->
            app= new AboardApiV1


#### Объявляет обработчики субприложения


## GET /entries
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


## GET /entries/:entry
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


## GET /entries/:entry/tags
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


## POST /entries/:entry/tags
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


## GET /tags
Отдает список тегов.

            app.get '/tags'
            ,   AboardApiV1.queryTag('tagId')
            ,   (req, res, next) ->
                    req.tags (tags) ->
                            log 'tags resolved', tags
                            res.json tags
                    ,   (err) ->
                            log 'tags rejected', err
                            next err


## POST /tags
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


## GET /tags/:tag
Отдает тег по идентификатору.

            app.get '/tags/:tag'
            ,   AboardApiV1.getTag('tag')
            ,   (req, res, next) ->
                    req.tag (tag) ->
                            log 'tag resolved', tag
                            if not tag
                                res.status 404
                            res.json tag
                    ,   (err) ->
                            log 'tag rejected', err
                            next err


## GET /threads
Отдает список тредов.

            app.get '/threads'
            ,   AboardApiV1.queryThread('threadId')
            ,   (req, res, next) ->
                    req.threads (threads) ->
                            log 'threads resolved', threads
                            res.json threads
                    ,   (err) ->
                            log 'threads rejected', err
                            next err


## GET /threads/:thread
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

            app


### Объявляет обработчики ошибок

    injector.invoke (app, log, Error) ->

        app.use (err, req, res, next) ->
            log 'error', err
            res.status err.status or 500
            res.end 'Error.'

В режиме разработчика объявляет маршрут для симуляции ошибок:

        app.configure 'development', ->

            app.get '/error', (req, res, next) ->
                next Error 'simulated'
