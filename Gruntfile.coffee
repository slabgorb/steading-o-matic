_ = require('underscore')
module.exports = (grunt) ->
  # Project configuration.
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    copy:
      main:
        files: [
          {
            expand: true
            cwd: 'srv/'
            src: [ 'views/**/*.jade' ]
            dest: 'dist/'
            filter: 'isFile'
          }

        ]


    jst:
      compile:
        files: 'public/js/templates.js': [ 'app/templates/**/*.html' ]
        processName: (filepath) -> console.log(filepath); return _.last filepath.split('/')
        prettify: true
    sass: compile: files: 'public/stylesheets/main.css': [ 'sass/main.scss' ]
    concat:
      vendor_js:
        files: 'public/js/vendor.js': [
          'bower_components/jquery/dist/jquery.min.js'
          'bower_components/jquery-ui/jquery-ui.min.js'
          'bower_components/underscore/underscore-min.js'
          'bower_components/underscore.inflection/lib/underscore.inflection.js'
          'bower_components/backbone/backbone.js'
          'bower_components/backbone-modal/backbone.modal-min.js'
          'bower_components/elasticsearch/elasticsearch.min.js'
          'bower_components/bootstrap/dist/js/bootstrap.min.js'
          'bower_components/jquery-serialize-object/dist/jquery.serialize-object.min.js'
          'bower_components/bootstrap-select/dist/js/bootstrap-select.min.js'
          'bower_components/jquery-ui/jquery-ui.min.js'
        ]
      vendor_css:
        files: 'public/stylesheets/vendor.css': [
          'bower_components/bootstrap/dist/css/bootstrap.min.css'
          'bower_components/bootstrap-select/dist/css/bootstrap-select.min.css'
        ]

    coffee:
      srv:
        files: [
          { cwd: 'srv', expand: true, ext: '.js', dest: 'dist/', src: '**/*.coffee' }
        ]
      app:
        sourceMap: true
        files:
          'public/js/app.js': [
            'app/app.coffee'
            'app/lib/**/*.coffee'
            'app/models/*.coffee'
            'app/views/*.coffee'
            'app/collections/*.coffee'
            'app/routers/base.coffee'
            'app/describers/base.coffee'
            'app/describers/**/*.coffee'
            'app/models/**/*.coffee'
            'app/collections/**/*.coffee'
            'app/views/**/*.coffee'
            'app/routers/**/*.coffee'
            'app/init.coffee'
          ]
    watch:
      views:
        files: 'srv/views/**/*'
        tasks: 'copy'
        options:
          livereload: true
      configFiles:
        files: [
          'Gruntfile.coffee'
          'config/*.coffee'
        ]
        options: reload: true
      css:
        files: '**/*.scss',
        tasks: 'sass',
        options:
          livereload: true
      jst:
        files: 'app/templates/**/*.html'
        tasks: 'jst'
        options:
          livereload: true
      coffeeapp:
        files: ['app/**/*.coffee','app/lib/**/*.coffee']
        tasks: 'coffee:app'
        options:
          livereload: true
      coffeesrv:
        files: [ 'srv/**/*.coffee'],
        tasks: 'coffee:srv'
        options:
          livereload: true

  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-jst'
  grunt.registerTask 'default', [ 'copy', 'concat', 'jst', 'sass', 'coffee', 'watch' ]
  return
