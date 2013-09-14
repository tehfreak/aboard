module.exports= (grunt) ->
    grunt.initConfig
        pkg: grunt.file.readJSON 'package.json'

        clean:
            all: ['<%= pkg.config.build.dist.views_templates %>/']

        copy:
            views:
                files: [{
                    expand: true
                    cwd: '<%= pkg.config.build.src.views_assets %>'
                    src: ['**/*', '!**/bower_components/**','!**/bower.json', '!**/*.less', '!**/*.jade', '!**/*.coffee', '!**/*.md']
                    dest: '<%= pkg.config.build.dist.views_assets %>'
                }, {
                    expand: true
                    cwd: '<%= pkg.config.build.src.views_assets %>/bower_components/angular'
                    src: ['**/*', '!**/*.json']
                    dest: '<%= pkg.config.build.dist.views_assets %>/scripts/libs/angular'
                }]

        jade:
            compile:
                options:
                    data:
                        debug: false
                files: [{
                    expand: true
                    cwd: '<%= pkg.config.build.src.views_templates %>'
                    src: ['**/*.jade', '!**/layout.jade']
                    dest: '<%= pkg.config.build.dist.views_templates %>'
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

    grunt.registerTask 'default', ['clean', 'copy', 'jade']
