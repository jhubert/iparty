window.App = {}

App.run = (property) ->
  if App.hasOwnProperty(property)
    jQuery(document).ready ->
      return App[property]()
  else
    return
