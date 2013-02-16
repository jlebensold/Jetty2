class App.Views.LibraryItemView extends Marionette.ItemView
  template: '#library-item-template'
  tagName: 'li'

class App.Views.LibraryCollectionView extends Marionette.CollectionView
  className: 'library'
  template: '#contents'
  tagName: 'ul'
  itemView: App.Views.LibraryItemView

  events: ->

  initialize: ->
    _.bindAll @, 'render'
    @template = _.template($(@template).html())
    @collection.on('reset', @render)
    @

