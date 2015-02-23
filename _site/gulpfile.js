var gulp = require('gulp'),
    sass = require('gulp-ruby-sass'),
    concat = require('gulp-concat'),
    uglify = require('gulp-uglify'),
    minifyCSS = require('gulp-minify-css'),
    jshint = require('gulp-jshint'),
    rename = require('gulp-rename'),
    size = require('gulp-size'),
    sourcemaps = require('gulp-sourcemaps'),
    pkg = require('./package.json');

var asset_path = '.';

var paths = {
  styles: asset_path+'/css/_sass/style.scss',
  scripts: [asset_path+'/js/plugins.js', asset_path+'/js/main.js']
};

gulp.task('styles', ['components'], function() {
  return sass(paths.styles, { sourcemap: true })
  .on('error', function (err) {
    console.error('Error', err.message);
  })
  .pipe(rename('app.css'))
  .pipe(gulp.dest(asset_path+'/css/'))
  .pipe(rename('app.min.css'))
  .pipe(minifyCSS())
  //.pipe(sourcemaps.write())
  .pipe(gulp.dest(asset_path+'/css/'));
});

gulp.task('components', function() {
  return gulp.src([asset_path+'/bower_components/normalize.css/normalize.css'])
  .pipe(rename('_normalize.scss'))
  .pipe(gulp.dest(asset_path+'/bower_components/normalize.css/'));
});

gulp.task('scripts', ['lint'], function() {
  gulp.src(paths.scripts)
    .pipe(concat('app.js'))
    .pipe(gulp.dest(asset_path+'/js/'))
    .pipe(rename('app.min.js'))
    .pipe(uglify({ preserveComments: 'some' }))
    .pipe(size())
    .pipe(gulp.dest(asset_path+'/js/'));
});

gulp.task('lint', function () {
  return gulp.src(asset_path+'/js/main.js')
    .pipe(jshint('.jshintrc'))
    .pipe(jshint.reporter('jshint-stylish'));
});

// The default task (called when you run `gulp` from cli)
gulp.task('default', ['styles', 'scripts']);
