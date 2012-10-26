class App.Models.Page extends Backbone.Model
  idAttribute: -1 #this is a client-side only model
  
  defaults: -> 
  {
    paragraphs: []
  }
  
  addParagraph: (p) ->
    @.get('paragraphs').push p

  html: ->
    @.get('paragraphs').join('<br/>')