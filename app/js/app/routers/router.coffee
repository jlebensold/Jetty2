window.App ?= {}
class App.Router extends Backbone.Router
  routes:
    "": "home",
    "home": "home",
    "content-:id": "content"

  initialize: ->
    _.bindAll @, 'home', 'content'
    @contents = new App.Collections.ContentList()
    @al = new App.Collections.AuthorityList()
    @contents.fetch()
    @al.fetch()

  home: ->
    @cv = new App.Views.ContentsView({collection: @contents, el:"#app" })
    @cv.render()
    
  content: (id) -> 
    c  = new App.Models.Content({_id: id})
    new App.Views.ReaderView({collection: @al, el:"#app", model: c })
    c.fetch()