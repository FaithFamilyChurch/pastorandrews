
$( document ).ready(function() {

    $(window).scroll(function () {
        console.log($(window).scrollTop())
        if ($(window).scrollTop() > 170) {
            $('#navbar').addClass('navbar-fixed');
            $('#navbar-inner').addClass('navbar-inner-fixed');
            $('.title').css('height', "200px");
            $('.titlelinks').css('border', "none");
        }
        if ($(window).scrollTop() < 171) {
            $('#navbar').removeClass('navbar-fixed');
            $('#navbar-inner').removeClass('navbar-inner-fixed');
            $('.title').css('height', "150px");
            $('.titlelinks').css('border-top', "1px solid #c1b8be");
        }
    });

});
