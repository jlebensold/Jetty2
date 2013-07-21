window.App ?= {}
window.App.Views ?= {}
window.App.Models ?= {}
window.App.Collections ?= {}

window.Jetty = {
  Views: {}
  Controller: {}
  Routers: {}
  Models: {}
}
@init = ->
  Jetty.App = new Backbone.Marionette.Application()                                                                                                                                       
  Jetty.App.appRouter = new Jetty.AppRouter
  Backbone.history.start() if (!Backbone.History.started)                                                                                                                            
  Jetty.App.vent.on('selection:showslider',(note,view) ->
    txt = note.text(view)
    $( "#slider-range" ).slider({
      range: true,
      min: 0,
      max: txt.length,
      values: [ note.get('start_paragraph_char'), note.get('end_paragraph_char') ],
      slide: ( event, ui ) ->
        note.set({start_paragraph_char: ui.values[0], end_paragraph_char: ui.values[1]})
      stop: (event, ui) -> 
        note.save({start_paragraph_char: ui.values[0], end_paragraph_char: ui.values[1]})
    })
  )
