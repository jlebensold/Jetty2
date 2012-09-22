class App.Views.ReaderView extends Backbone.View
  className: "reader span12"
  events: ->
    {
    }
  initialize: ->
    _.bindAll @, 'render','load_content_and_authority'
    @template = _.template($('#reader').html())
    @authorities = @options.authorities
    @
  render: ->

    $(@el).html @template()
    $(@el).find(".content").html(@txtview.render().el)
    $(@el).find(".manager").html(@am.render().el)
    @

  load_content_and_authority: (txt,json) -> 
    tree = App.Models.Authority.from_json(json)
    @txtview = new App.Views.TextView({model: new App.Models.Content({text: txt}), authorities: tree })
    @am = new App.Views.AuthorityManagerView({model: tree})

