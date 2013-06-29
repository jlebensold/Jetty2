class App.Views.ReaderView extends Backbone.View
  className: "reader"
  events: ->
  initialize: ->
    _.bindAll @, 'render','nextPage','previousPage', 'setPage'
    @template = _.template($('#reader').html())
    
    @collection.on('reset', @render)
    @model.on('change', @render)

    @

  nextPage: (e)->
    e.preventDefault()
    @txtview.nextPage()
  
  previousPage: (e) ->
    e.preventDefault()
    @txtview.previousPage()

  setPage: (page) ->
    @txtview.current_page = page
    @txtview.render()

  render: ->
    if (@model.get('text').length == 0 || @collection.length == 0)
      return @
    $(@el).html @template()
    @txtview = new App.Views.TextView({model: @model, authorities: @collection.first() })
    #@am = new App.Views.AuthorityManagerView({collection: @collection})
    @txtview.notes.fetch();

    $(@el).find(".content").html(@txtview.render().el)
    #    $(@el).find(".manager").html(@am.render().el)
    @



