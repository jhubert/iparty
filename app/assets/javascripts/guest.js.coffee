# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

App.guest_payment = ->
  jQuery ->
    Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
    order.setupForm()

  order =
    checkCreditCardType: (event) ->
      $('.card-icon').removeClass('active');
      $('#credit-card-icons').removeClass('selected');
      if ($(event.target).val() != '')
        card_type = Stripe.cardType($(event.target).val());
        card_type = card_type.replace(' ', '-').toLowerCase();
        elm = $('#' + card_type + '-card')
        if elm[0]
          elm.addClass('active')
          $('#credit-card-icons').addClass('selected');

    setupForm: ->
      $('#card_number').bind('keyup blur', order.checkCreditCardType)

      $('#make_donation').submit (e) ->
        $('input[type=submit]').attr('disabled', true)
        if $('#card_number').length
          order.processCard()
          false
        else
          true

    processCard: ->
      card =
        name: $('#card_name').val()
        number: $('#card_number').val()
        cvc: $('#card_code').val()
        expMonth: $('#card_month').val()
        expYear: $('#card_year').val()

      Stripe.createToken(card, order.handleStripeResponse)
  
    handleStripeResponse: (status, response) ->
      console.log status, response

      if status == 200
        $('#stripe_card_token').val(response.id)
        $('#make_donation')[0].submit()
      else
        $('#stripe_error').text(response.error.message)
        $('input[type=submit]').attr('disabled', false)
