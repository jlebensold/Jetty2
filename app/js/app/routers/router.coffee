window.App ?= {}
class Jetty.AppRouter extends Backbone.Router
  routes:
    "": "home",
    "home": "home",
    "content-:id": "content"
    "content-:id/:anchor": "content"
    "authorities/": "authority"

  initialize: ->
    _.bindAll @, 'home', 'content'
    @contents = new App.Collections.ContentList()
    @al = new App.Collections.AuthorityList()
    @contents.fetch()
    @al.fetch()

  home: ->
    @cv = new App.Views.LibraryCollectionView({collection: @contents})
    $("#app").html(@cv.render().el);
    
  authority: ->
    @am = new App.Views.AuthorityManagerView({collection: @al})
    $("#app").html(@am.render().el);
    
  content: (id,anchor) -> 
    #if (anchor)
    #  $('html,body').animate({scrollTop: $("#a_#{anchor}").offset().top},'slow');
    c  = new App.Models.Content({_id: id})
    new App.Views.ReaderView({collection: @al, el:"#app", model: c })
    c.fetch()
