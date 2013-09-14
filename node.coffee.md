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
				#log 'maria connection', maria, err

Полученное соединение сохраняется в запросе:

				req.maria= maria if not err

После выполнения запроса соединение возвращается в пул:

				req.on 'end', () ->
					log 'req end', arguments
					if req.maria
						do req.maria.release

				next err



### Объявляет обработчики маршрутов API

    injector.invoke (app, log) ->

Создает и монтирует субприложение:

        app.use '/api/v1', injector.invoke (AboardApiV1) ->
            app= new AboardApiV1


#### Объявляет обработчики субприложения


##### GET /threads

Отдает список тредов.

< content-type: application/json
< Aboard.Thread {
<   id: Number
<   posts: [
<     post: Aboard.Thread.Post
<   ]
< }

            app.get '/threads'
            ,   AboardApiV1.queryThread('threadId')
            ,   (req, res, next) ->
                    req.threads (threads) ->
                            log 'threads resolved', threads
                            res.json threads
                    ,   (err) ->
                            log 'threads rejected', err
                            next err


##### GET /threads/:thread

Отдает тред по идентификатору.

< content-type: application/json
< Aboard.Thread {
<   id: Number
<   posts: [
<     post: Aboard.Thread.Post
<   ]
< }

            app.get '/threads/:thread'
            ,   AboardApiV1.getThread('thread')
            ,   (req, res, next) ->
                    req.thread (thread) ->
                            log 'thread resolved', thread
                            res.status 404 if not thread
                            res.json thread
                    ,   (err) ->
                            log 'thread rejected', err
                            next err


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
