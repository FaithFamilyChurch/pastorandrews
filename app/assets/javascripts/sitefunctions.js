
// $( document ).ready(function() {
jQuery( document ).on('turbolinks:load', function() {

    $('.welcomeslides').slick({
        autoplay: true,
        fade: true,
        prevArrow: $(".prevbutton"),
        nextArrow: $(".nextbutton")
    });

    $( ".nav-div" ).click(function() {
        $(".nav-indicator").each(function() {
            $(this).css("background-color", "transparent");
        });
    });

    $("#subscribe_button").click(function() {
        sendSubscriptionRequest();
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


function normalizeArray(aFormData)
{
    var oNormalizedData = {};
    for(var i = 0; i < aFormData.length; i++)
    {
        oNormalizedData[aFormData[i]['name']] = aFormData[i]['value'];
    }
    return oNormalizedData;
}


function sendSubscriptionRequest()
{
    var oFormData = normalizeArray($("#subscription_form").serializeArray());

    if(oFormData['subscribe_email'] === null || typeof oFormData['subscribe_email'] === "undefined" || /^\s*$/.test(oFormData['subscribe_email']))
    {
        alert("Please make sure you've entered your email address!");
        return false;
    }

    if(oFormData['subscribe_fname'] === null || typeof oFormData['subscribe_fname'] === "undefined")
    {
        oFormData['subscribe_fname'] = "";
    }

    if(oFormData['subscribe_lname'] === null || typeof oFormData['subscribe_lname'] === "undefined")
    {
        oFormData['subscribe_lname'] = "";
    }

	var info = {
		"type": "POST",
		"path": "pages/1/requestNewSubscription",
		"data": oFormData,
		"func": subscriptionRequestResponse
	};
	FUSION.lib.ajaxCall(info);

}


function subscriptionRequestResponse(h)
{

}
