# Приложение





### Подключает инъектор зависимостей

	di= require 'di'

### Подключает модули инъектора

	AppModule= require './modules/App'

### Инстанцирует инъектор

	injector= new di.Injector [new AppModule]





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
