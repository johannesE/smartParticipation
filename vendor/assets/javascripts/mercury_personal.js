/**
 * Created by johannes on 28.10.14.
 */
//from the railscast. This does change the saveurl based on the data attribute in #edit_link
$(window).bind('mercury:ready', function() {
    var link = $('#mercury_iframe').contents().find('#edit_link');
    Mercury.saveUrl = link.data('save-url');
    link.hide();
});

$(window).bind('mercury:saved', function() {
    alert("The changes were successfully saved.");
    window.location = window.location.href.replace(/\/editor\//i, '/');
});

$(document).ready(function() {
    return jQuery(parent).trigger('initialize:frame');
});
