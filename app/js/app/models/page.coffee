class App.Models.Page extends Backbone.Model
  idAttribute: -1 #this is a client-side only model
  
  defaults: -> 
  {
    page: 1
    paragraphs: []
  }
  
  addParagraph: (p) ->
    @.get('paragraphs').push p

  html: ->
    @.get('paragraphs').join('<br/>')
