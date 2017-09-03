
// $( document ).ready(function() {
jQuery( document ).on('turbolinks:load', function() {

    $( ".nav-div" ).click(function() {
        $(".nav-indicator").each(function() {
            $(this).css("background-color", "transparent");
        });
    });

    var sPath = window.location.pathname.split("/")[1];
    sPath = FUSION.lib.isBlank(sPath) ? "home" : sPath;
    FUSION.get.node(sPath + "_indicator").style.backgroundColor = "#483D3F";

    $(window).scroll(function () {
//        debugger;
        if ($(window).scrollTop() > 170) {
            $('#navbar').addClass('navbar-fixed');
            $('#navbar-inner').addClass('navbar-inner-fixed');
            $('.title').css('height', "200px");
            $('.titlelinks').css('border', "none");
            $('.nav-indicator').css('margin-top', '0px');
            $('.titlelink').css('padding', "4px 10px 10px 10px");
            //$('.feature .nav-indicator').css('margin-bottom', "-6px");
        }
        if ($(window).scrollTop() < 171) {
            $('#navbar').removeClass('navbar-fixed');
            $('#navbar-inner').removeClass('navbar-inner-fixed');
            $('.title').css('height', "150px");
            $('.titlelinks').css('border-top', "1px solid #c1b8be");
            $('.nav-indicator').css('margin-top', '-6px');
            //$('.feature .nav-indicator').css('margin-bottom', "0px");
            $('.titlelink').css('padding', "9px 30px 11px");
        }
    });

});
