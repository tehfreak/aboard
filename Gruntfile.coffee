module.exports= (grunt) ->
    grunt.initConfig
        pkg: grunt.file.readJSON 'package.json'

        clean:
            views: [
                '<%= pkg.build.views.app.assets %>/'
                '<%= pkg.build.viewsAboard.app.assets %>/'
            ]

        copy:
            views:
                files: [{
                    expand: true
                    cwd: '<%= pkg.build.views.src.assets.cwd %>'
                    src: ['**/*', '!**/bower_components/**','!**/bower.json', '!**/*.less', '!**/*.jade', '!**/*.coffee', '!**/*.md']
                    dest: '<%= pkg.build.views.app.assets.cwd %>'
                }, {
                    expand: true
                    cwd: '<%= pkg.build.views.src.assets.cwd %>/bower_components/ui/js'
                    src: ['**/*', '!**/*.json', '!**/*.md']
                    dest: '<%= pkg.build.views.app.assets.cwd %>/scripts'
                }, {
                    expand: true
                    cwd: '<%= pkg.build.views.src.assets.cwd %>/bower_components/ui/font'
                    src: ['**/*', '!**/*.json', '!**/*.md']
                    dest: '<%= pkg.build.views.app.assets.cwd %>/font'
                }, {
                    expand: true
                    cwd: '<%= pkg.build.views.src.assets.cwd %>/bower_components/ui/i'
                    src: ['**/*', '!**/*.json', '!**/*.md']
                    dest: '<%= pkg.build.views.app.assets.cwd %>/i'
                }, {
                    expand: true
                    cwd: '<%= pkg.build.viewsAboard.src.assets.cwd %>'
                    src: ['**/*', '!**/bower_components/**','!**/bower.json', '!**/*.less', '!**/*.jade', '!**/*.coffee', '!**/*.md']
                    dest: '<%= pkg.build.viewsAboard.app.assets.cwd %>'
                }, {
                    expand: true
                    cwd: '<%= pkg.build.viewsAwesome.src.assets.cwd %>'
                    src: ['**/*', '!**/bower_components/**','!**/bower.json', '!**/*.less', '!**/*.jade', '!**/*.coffee', '!**/*.md']
                    dest: '<%= pkg.build.viewsAwesome.app.assets.cwd %>'
                }]

        coffee:
            compile:
                files: [{
                    expand: true
                    cwd: '<%= pkg.build.views.src.assets.cwd %>/scripts'
                    src: ['**/*.coffee']
                    dest: '<%= pkg.build.views.app.assets.cwd %>/scripts'
                    ext: '.js'
                }, {
                    expand: true
                    cwd: '<%= pkg.build.viewsAboard.src.assets.cwd %>/scripts'
                    src: ['**/*.coffee']
                    dest: '<%= pkg.build.viewsAboard.app.assets.cwd %>/scripts'
                    ext: '.js'
                }, {
                    expand: true
                    cwd: '<%= pkg.build.viewsAwesome.src.assets.cwd %>/scripts'
                    src: ['**/*.coffee']
                    dest: '<%= pkg.build.viewsAwesome.app.assets.cwd %>/scripts'
                    ext: '.js'
                }]

        jade:
            views:
                options:
                    data:
                        debug: false
                files: [{
                    expand: true
                    cwd: '<%= pkg.build.views.src.templates.cwd %>'
                    src: ['**/*.jade', '!**/layout.jade']
                    dest: '<%= pkg.build.views.app.templates.cwd %>'
                    ext: '.html'
                }]
            viewsAboard:
                options:
                    data:
                        debug: false
                files: [{
                    expand: true
                    cwd: '<%= pkg.build.viewsAboard.src.templates.cwd %>'
                    src: ['**/*.jade', '!**/layout.jade']
                    dest: '<%= pkg.build.viewsAboard.app.templates.cwd %>'
                    ext: '.html'
                }]
            viewsAwesome:
                options:
                    data:
                        debug: false
                files: [{
                    expand: true
                    cwd: '<%= pkg.build.viewsAwesome.src.templates.cwd %>'
                    src: ['**/*.jade', '!**/layout.jade']
                    dest: '<%= pkg.build.viewsAwesome.app.templates.cwd %>'
                    ext: '.html'
                }]

        less:
            compile:
                files: [{
                    expand: true
                    cwd: '<%= pkg.build.views.src.assets.cwd %>/styles'
                    src: ['**/*.less']
                    dest: '<%= pkg.build.views.app.assets.cwd %>/styles'
                    ext: '.css'
                }, {
                    expand: true
                    cwd: '<%= pkg.build.viewsAboard.src.assets.cwd %>/styles'
                    src: ['**/*.less']
                    dest: '<%= pkg.build.viewsAboard.app.assets.cwd %>/styles'
                    ext: '.css'
                }, {
                    expand: true
                    cwd: '<%= pkg.build.viewsAwesome.src.assets.cwd %>/styles'
                    src: ['**/*.less']
                    dest: '<%= pkg.build.viewsAwesome.app.assets.cwd %>/styles'
                    ext: '.css'
                }]

        watch:
            jade:
                files: ['**/*.jade']
                tasks: ['jade']
            less:
                files: ['**/*.less']
                tasks: ['less']

    grunt.loadNpmTasks 'grunt-contrib-clean'
    grunt.loadNpmTasks 'grunt-contrib-copy'
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-jade'
    grunt.loadNpmTasks 'grunt-contrib-less'

    grunt.loadNpmTasks 'grunt-contrib-watch'

    grunt.registerTask 'default', ['clean', 'copy:views', 'coffee', 'jade', 'less']
    grunt.registerTask 'dev', ['default', 'watch']
