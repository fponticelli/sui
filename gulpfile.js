var gulp      = require('gulp');
    seq       = require('run-sequence'),
    connect   = require('gulp-connect');
    exec      = require('gulp-exec'),
    url       = require('stylus').url,
    stylus    = require('gulp-stylus'),
    nib       = require('nib');

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

gulp.task('build', function(cb) {
  seq("stylus", "haxe", cb);
});

gulp.task('haxe', function(cb) {
  exec("haxe build.hxml", function(err, stdout, stderr) {
    cb(err);
  });
});

gulp.task('stylus', function() {
  return gulp.src('./style/sui.styl')
    .pipe(stylus({
      use: [nib()],
      compress: true,
      url: 'embedurl'
    }))
    .pipe(gulp.dest('./css'));
});

gulp.task('watch', function () {
  gulp.watch(['./style/icons/*.svg'], ['build'] );
  gulp.watch(['./bin/*.html'], ['html']);
  gulp.watch(['./bin/controls.js'], ['js']);
  gulp.watch(['./style/*.styl'], ['build']);
});

gulp.task('default', function (cb) {
  seq(['connect'], ['build'], ['watch'], cb);
});
