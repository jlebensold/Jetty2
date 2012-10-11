class App.Views.ReaderView extends Backbone.View
  className: "reader"
  events: ->
    {
    }
  initialize: ->
    _.bindAll @, 'render'
    @template = _.template($('#reader').html())
    

    #FIXME refactor me away
    @collection.on('reset', @render)

    @
  render: ->
    $(@el).html @template()

    @txtview = new App.Views.TextView({model: @model, authorities: @collection.first() })
    @am = new App.Views.AuthorityManagerView({collection: @collection})
    @txtview.notes.fetch();

    $(@el).find(".content").html(@txtview.render().el)
    $(@el).find(".manager").html(@am.render().el)
    @



