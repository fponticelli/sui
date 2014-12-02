var gulp      = require('gulp'),
    seq       = require('gulp-run-sequence'),
    stylus    = require('gulp-stylus'),
    connect   = require('gulp-connect'),
    nib       = require('nib'),
    svgSprite = require("gulp-svg-sprites"),
    execSync  = require('exec-sync'),
    Iconizr   = require('iconizr'),
    tmp       = "assets/tmp";

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

gulp.task('icons', function (cb) {
  var options = {
        render : {
          css : false,
          styl : {
            dest : '../../style/icons.styl',
            template : 'assets/templates/icons.styl'
          }
        },
        prefix : 'sui-icon',
        spritedir : '.',
        quantize : true,
        level : 5,
        keep : false,
      },
      callback = function(err, results) {
        if(err) throw "Failed to convert icons: " + err;
        execSync("rm -rf " + tmp);
        execSync("rm style/icons-png-*.*");
        execSync("rm style/icons-*-sprite.*");
        execSync("mv style/icons-svg-data.styl style/icons.styl");
        cb();
      };

  Iconizr.createIconKit('assets/icons', tmp, options, callback);
});

gulp.task('build', function(cb) {
  seq("stylus", "haxe", cb);
});

gulp.task('haxe', function() {
  execSync("haxe build.hxml");
});

gulp.task('stylus', function() {
  return gulp.src('./style/sui.styl')
    .pipe(stylus({
      use: [nib()],
      compress: true
    }))
    .pipe(gulp.dest('./css'));
});

gulp.task('watch', function () {
  gulp.watch(['./assets/icons/*.svg'], function(cb) { seq('icons', 'build', cb); });
  gulp.watch(['./bin/*.html'], ['html']);
  gulp.watch(['./bin/controls.js'], ['js']);
  gulp.watch(['./style/*.styl'], ['build']);
});

gulp.task('default', function (cb) {
  seq(['connect', 'icons'], ['build', 'watch'], cb);
});