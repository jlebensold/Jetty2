window.App ?= {}
window.App.Views ?= {}
window.App.Models ?= {}
window.App.Collections ?= {}
class App.Application
  start: ->
    @router = new App.Router
    Backbone.history.start()
    #console.log 'ready to go...'