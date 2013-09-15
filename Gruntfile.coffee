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
                    cwd: '<%= pkg.build.views.src.assets.cwd %>/bower_components/angular'
                    src: ['**/*', '!**/*.json']
                    dest: '<%= pkg.build.views.app.assets.cwd %>/scripts/libs/angular'
                }, {
                    expand: true
                    cwd: '<%= pkg.build.viewsAboard.src.assets.cwd %>'
                    src: ['**/*', '!**/bower_components/**','!**/bower.json', '!**/*.less', '!**/*.jade', '!**/*.coffee', '!**/*.md']
                    dest: '<%= pkg.build.viewsAboard.app.assets.cwd %>'
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

        watch:
            jade:
                files: ['**/*.jade']
                tasks: ['jade']

    grunt.loadNpmTasks 'grunt-contrib-clean'
    grunt.loadNpmTasks 'grunt-contrib-copy'
    grunt.loadNpmTasks 'grunt-contrib-jade'

    grunt.loadNpmTasks 'grunt-contrib-watch'

    grunt.registerTask 'default', ['clean', 'copy:views', 'jade']
