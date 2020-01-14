// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()

import 'expose-loader?$!jquery';
import 'bootstrap';
import '../stylesheets/application';

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

$(document).on('turbolinks:load', function() {
    $('.dropdown-toggle').keypress(function() {
        $('.dropdown-menu').dropdown('show')
        $('.dropdown-menu').dropdown('update')
    })

    $('.update-defaults').change(function() {
        let url = $(this).data('defaultsUrl')
        let theater = $('#flight_theater').val()
        let callsign = $('#flight_callsign').val()
        let callsign_number = $('#flight_callsign_number').val()
        $.get(url + '?' + $.param({ t: theater, cs: callsign, n: callsign_number}), function(data) {
            $('#flight_frequency').val(data['freq'])
            $('#flight_group_id').val(data['group'])
            $('#flight_laser').val(data['laser'])
            $('#flight_tacan_channel').val(data['tcn'])
            $('#flight_tacan_polarization').val(data['Y'])
        })
    })
})
