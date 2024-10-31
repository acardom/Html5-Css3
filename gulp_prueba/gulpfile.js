const gulp = require('gulp'),
    sass = require('gulp-sass')(require('sass')),
    autoprefixer = require('gulp-autoprefixer');

gulp.task('sass', ()=>
    gulp.src('./scss/style.scss')
        .pipe(sass({
            outputStyle: 'compressed',
            sourceComments: true
        }))
        .pipe(gulp.dest('./css'))
);

gulp.task('default', () => {
    gulp.watch('./scss/style.scss', gulp.parallel('sass'))
})