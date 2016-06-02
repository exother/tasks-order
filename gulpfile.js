var gulp = require('gulp');
var uglify = require('gulp-uglify');
var coffee = require('gulp-coffee');
var ngClassify = require('gulp-ng-classify');
var ngAnnotate = require('gulp-ng-annotate');
var concat = require('gulp-concat');
var strip_log = require('gulp-strip-debug');



gulp.task('default', function() {
    gulp.src('./lib/angular/*.coffee')
        .pipe(ngClassify())
        .pipe(coffee())
        .pipe(ngAnnotate())
        .pipe(concat('page.js'))
        .pipe(strip_log())
        .pipe(uglify())
        .pipe(gulp.dest('./app/assets/javascripts/angular/'))
});