class App.Views.ContentsView extends Backbone.View
  className: "contents"
  events: ->

  initialize: ->
    _.bindAll @, 'render'
    @template = _.template($('#contents').html())
    @collection.on('reset', @render)
    @
  render: ->
    $(@el).html @template()
    @collection.each (c) => 
      $(@el).find('.content_list').append('<li><a href="#content-'+c.get('_id')+'">'+c.get('title')+'</a></li>');
    @



