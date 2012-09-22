class App.Views.ReaderView extends Backbone.View
  className: "reader span12"
  events: ->
    {
    }
  initialize: ->
    _.bindAll @, 'render','load_content_and_authority'
    @template = _.template($('#reader').html())

    @
  render: ->
    
    $(@el).html @template()
    $(@el).find(".content").html(@txtview.render().el)
    $(@el).find(".manager").html(@am.render().el)
    @

  load_content_and_authority: (txt,json) -> 
    @txtview = new App.Views.TextView({model: new App.Models.Content({text: txt})})
    @am = new App.Views.AuthorityManagerView({model: App.Models.Authority.from_json(json)})

