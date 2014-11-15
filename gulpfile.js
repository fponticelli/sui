var gulp = require('gulp'),
    stylus = require('gulp-stylus'),
    connect = require('gulp-connect');

gulp.task('connect', function () {
  connect.server({
    root: ['bin'],
    port: 8000,
    livereload: true
  });
});

gulp.task('html', function () {
  gulp.src('./bin/*.html')
    .pipe(connect.reload());
});

gulp.task('js', function () {
  gulp.src('./bin/*.js')
    .pipe(connect.reload());
});

gulp.task('stylus', function () {
  gulp.src('./style/*.styl')
    .pipe(stylus())
    .pipe(gulp.dest('./bin'))
    .pipe(connect.reload());
});

gulp.task('watch', function () {
  gulp.watch(['./bin/*.html'], ['html']);
  gulp.watch(['./bin/*.js'], ['js']);
  gulp.watch(['./style/*.styl'], ['stylus']);
});

gulp.task('default', ['connect', 'watch']);