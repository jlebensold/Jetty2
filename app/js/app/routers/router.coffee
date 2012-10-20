window.App ?= {}
class App.Router extends Backbone.Router
  routes:
    "": "home",
    "home": "home",
    "content-:id": "content"
    "content-:id/:anchor": "content"

  initialize: ->
    _.bindAll @, 'home', 'content'
    @contents = new App.Collections.ContentList()
    @al = new App.Collections.AuthorityList()
    @contents.fetch()
    @al.fetch()

  home: ->
    @cv = new App.Views.ContentsView({collection: @contents, el:"#app" })
    @cv.render()
    
  content: (id,anchor) -> 
    console.log "TODO: #{anchor}"
    #if (anchor)
    #  $('html,body').animate({scrollTop: $("#a_#{anchor}").offset().top},'slow');

    c  = new App.Models.Content({_id: id})
    new App.Views.ReaderView({collection: @al, el:"#app", model: c })
    c.fetch()
