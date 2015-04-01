
showMessage = (type, message, autoclose=true) ->
    $('#message .alert').addClass('alert-'+type).empty().append(message)
    $('#message').removeClass('hidden').show 'fade'
    if autoclose
        setTimeout ->
            $('#message').hide 'fade', ->
                $('#message .alert').removeClass('alert-'+type)
        , 2000
showSuccessMessage = (message) ->
    showMessage 'success', message
showErrorMessage = (message) ->
    showMessage 'danger', message

networkError = (json, status) ->
  if status != 401
    showErrorMessage json.message
  else
    location.href = '/'
